//
//  CommonModel.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CommonModel.h"
#import "UserModel.h"
#import "GCExtension.h"

#import <AFNetworking.h>
#import "ServerProxy.h"

#import "MKWModelHandler.h"
#import "Community.h"
#import "APIGenerator.h"


#define k_USERDEFAULTS_KEY_CURRENTCOMMUNITYID       @"User_CurrentCommunityID"
#define k_USERDEFAULTS_KEY_CURRENTCITY              @"User_CurrentCity"

@implementation CommonModel

+ (instancetype)sharedModel {
    static CommonModel  *retVal = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        retVal = [[CommonModel alloc] init];
    });
    return retVal;
}

- (instancetype)init {
    if (self = [super init]) {
        _currentCommunityId = [[NSUserDefaults standardUserDefaults] objectForKey:k_USERDEFAULTS_KEY_CURRENTCOMMUNITYID];
        _currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:k_USERDEFAULTS_KEY_CURRENTCITY];
        
        [self _startObserver];
    }
    return self;
}


- (void)_startObserver {
    _weak(self);
    [self addObserverForNotificationName:k_NOTIFY_NAME_COMMUNITY_CHANGED usingBlock:^(NSNotification *notification) {
        _strong(self);
        [self _setCurrentCommunityId:[[notification userInfo] objectForKey:k_NOTIFY_KEY_COMMUNITY_CHANGED] withDefaults:YES];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_CITY_CHANGED usingBlock:^(NSNotification *notification) {
        _strong(self);
        [self _setCurrentCity:[[notification userInfo] objectForKey:k_NOTIFY_KEY_CITY_CHANGED]];
    }];
    
    [self addObserverForNotificationName:k_NOTIFY_NAME_PROPERTY_USER_LOGIN usingBlock:^(NSNotification *notification) {
        _strong(self);
        [self _setCurrentCommunityId:[[[UserModel sharedModel] currentAdminUser] communityId] withDefaults:NO];
    }];
    
    [self addObserverForNotificationName:k_NOTIFY_NAME_PROPERTY_USER_LOGOUT usingBlock:^(NSNotification *notification) {
        _strong(self);
        [self _setCurrentCommunityId:[[NSUserDefaults standardUserDefaults] objectForKey:k_USERDEFAULTS_KEY_CURRENTCOMMUNITYID] withDefaults:NO];
    }];
}

- (void)_setCurrentCommunityId:(NSNumber *)communityId {
    _currentCommunityId = communityId;
    [[NSUserDefaults standardUserDefaults] setObject:communityId forKey:k_USERDEFAULTS_KEY_CURRENTCOMMUNITYID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)_setCurrentCommunityId:(NSNumber *)communityId withDefaults:(BOOL)defaults {
    if (defaults) {
        [self _setCurrentCommunityId:communityId];
    }
    else {
        _currentCommunityId = communityId;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_CURRENT_COMMUNITY_CHANGED object:nil userInfo:@{k_NOTIFY_KEY_COMMUNITY_CHANGED:self.currentCommunityId}];
}

- (void)_setCurrentCity:(NSString *)city {
    _currentCity = city;
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:k_USERDEFAULTS_KEY_CURRENTCITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)currentCommunityName {
    Community *c = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:@"Community" predicate:[NSPredicate predicateWithFormat:@"communityId=%@", self.currentCommunityId]] firstObject];
    if (c) {
        return c.name;
    }
    return @"";
}

- (CommunityInfo *)currentCommunity {
    Community *c = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:@"Community" predicate:[NSPredicate predicateWithFormat:@"communityId=%@", self.currentCommunityId]] firstObject];

    return [CommunityInfo infoWithManagedObj:c];
}

- (void)uploadImage:(UIImage *)img
               path:(NSString *)path
           progress:(void(^)())progress
        remoteBlock:(void(^)(NSString *url, NSError *error))remote {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:[APIGenerator uploadImgAddressWithSuffix:k_API_UPLOAD_IMAGE] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *err;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"imgFile" fileName:[path lastPathComponent] mimeType:[NSString stringWithFormat:@"image/%@", [path pathExtension]] error:&err];
        if (err) {
            GCBlockInvoke(remote, nil, err);
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        if (![[jsonDic objectForKey:@"error"] boolValue]) {
            GCBlockInvoke(remote, [jsonDic objectForKey:@"url"], nil);
        }
        else {
            GCBlockInvoke(remote, nil, [[NSError alloc] initWithDomain:@"上传失败" code:1000091 userInfo:nil]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)asyncLocationAddrWithLatitude:(CLLocationDegrees)latitude
                            Longitude:(CLLocationDegrees)longitude
                          remoteBlock:(void(^)(NSArray *locationList, NSError *error))remote {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置返回格式：
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:[APIGenerator apiAddressWithSuffix:k_API_L_LOCATION_QUERY], @(latitude), @(longitude)] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"renderReverse&&renderReverse(" withString:@""];
        responseStr = [responseStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@")"]];
        NSError *error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            GCBlockInvoke(remote,[LocationAddrInfo infoArrayWithJSONArray:[[jsonDic objectForKey:@"result" ] objectForKey:@"pois"]], nil);
            return;
        }
        GCBlockInvoke(remote, nil, [[NSError alloc] initWithDomain:@"数据错误" code:1000001 userInfo:nil]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

@end
