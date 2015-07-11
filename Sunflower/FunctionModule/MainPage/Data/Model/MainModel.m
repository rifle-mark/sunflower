//
//  MainModel.m
//  Sunflower
//
//  Created by makewei on 15/5/31.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MainModel.h"
#import "ServerProxy.h"
#import "JSONServerProxy.h"

#import "MKWModelHandler.h"

@implementation MainModel


+ (void)asyncGetCommunityInfoWithId:(NSNumber *)communityId
                         cacheBlock:(void(^)(CommunityInfo *community, NSArray *buildList))cache
                        remoteBlock:(void(^)(CommunityInfo *community, NSArray *buildList, NSError *error))remote {
    Community *obj = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITY predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]] firstObject];
    NSArray *builds = [[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYBUILD predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]];
    if (obj && builds) {
        NSMutableArray *blockBuilds = [@[] mutableCopy];
        for (CommunityBuild *build in builds) {
            [blockBuilds addObject:[CommunityBuildInfo infoWithManagedObj:build]];
        }
        GCBlockInvoke(cache, [CommunityInfo infoWithManagedObj:obj], blockBuilds);
    }
    
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@", k_API_MAIN_COMMUNITYINFO_QUERY, communityId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            
            return;
        }
        CommunityInfo *community = [[CommunityInfo alloc] init];
        community = [community infoWithJSONDic:[responseJSON objectForKey:@"result"]];
        [community saveToDb];
        NSArray *buildings = [CommunityBuildInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"buildings"]];
        GCBlockInvoke(remote, community, buildings, nil);
        
//        [[MKWModelHandler defaultHandler] deleteObjectsInEntity:k_ENTITY_COMMUNITY];
//        [[MKWModelHandler defaultHandler] deleteObjectsInEntity:k_ENTITY_COMMUNITYBUILD];
        
        for (CommunityBuildInfo *build in buildings) {
            [build saveToDb];
        }
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, nil, error);
    }];
}

+ (void)asyncGetWeatherInfoWithCityName:(NSString *)city
                            remoteBlock:(void(^)(NSDictionary *info, NSError *error))remote {
    NSString *cityparam = [city stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"市"]];
    [JSONServerProxy getWithUrl:k_API_MAIN_WEATHER_QUERY params:@{@"cityname":cityparam} success:^(NSDictionary *responseJSON) {
        if ([[responseJSON objectForKey:@"errNum"] integerValue] != 0) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"errMsg"] code:[[responseJSON objectForKey:@"errNum"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [responseJSON objectForKey:@"retData"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}
@end
