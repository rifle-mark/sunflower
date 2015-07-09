//
//  CSSettingModel.m
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CSSettingModel.h"
#import "MKWModelHandler.h"
#import "ServerProxy.h"
#import "GCExtension.h"

#import <AFNetworking.h>

@implementation CSSettingModel

+ (instancetype)sharedModel {
    static CSSettingModel *retVal = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        retVal = [[CSSettingModel alloc] init];
    });
    return retVal;
}



#pragma mark - opend citys
- (NSArray*)localOpendCitys {
    return [[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_OPENDCITY];
}

- (void)asyncOpendCityWithPage:(NSNumber*)page pageSize:(NSNumber*)pageSize CacheBlock:(void(^)(NSArray* cityArray))cache remoteBlock:(void(^)(NSArray *cityArray, NSError *error))remote {
    GCBlockInvoke(cache, [self localOpendCitys]);
    
    [JSONServerProxy postJSONWithUrl:k_API_ALL_OPENED_CITY parameters:@{@"pageindex":page, @"pagesize":pageSize} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [OpendCityInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)refreshLocalOpendCitysWithArray:(NSArray *)citys {
    [[MKWModelHandler defaultHandler] deleteObjectsInEntity:k_ENTITY_OPENDCITY];
    for (OpendCityInfo *info in citys) {
        [info saveToDb];
    }
}

#pragma mark - areas
- (NSArray*)localAreaWithCity:(OpendCityInfo*)city {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"openCityId = %@", city.cityId];
    NSSortDescriptor *s = [NSSortDescriptor sortDescriptorWithKey:@"orderId" ascending:YES];
    return [[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_OPENDAREA predicate:p sortDescriptors:@[s] error:NULL];
}
- (void)asyncAreaWithCity:(OpendCityInfo*)city cacheBlock:(void(^)(NSArray *areaArray))cache remoteBlock:(void(^)(NSArray *areaArray, NSError *error))remote {
    GCBlockInvoke(cache, [self localAreaWithCity:city]);
    
    [JSONServerProxy postJSONWithUrl:k_API_ALL_CITY_AREA parameters:@{@"cityName":city.city} success:^(NSDictionary *responseJSON) {
        NSArray *areaArray = [OpendAreaInfo infoArrayWithJSONArray:[responseJSON objectForKey:@"result"]];
        for (OpendAreaInfo *area in areaArray) {
            area.openCityId = city.cityId;
        }
        GCBlockInvoke(remote, areaArray, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}
- (void)refreshLocalAreasWithCity:(OpendCityInfo*)city areaArray:(NSArray*)areas {
    NSArray *deleteAreas = [self localAreaWithCity:city];
    for (OpendArea *area in deleteAreas) {
        [[MKWModelHandler defaultHandler] deleteObject:area];
    }
    
    for (OpendAreaInfo *info in areas) {
        [info saveToDb];
    }
}


#pragma mark - community
- (NSArray*)localCommunityWithCity:(OpendCityInfo*)city area:(OpendAreaInfo*)area {
    return [[NSArray alloc] init];
}
- (void)asyncCommunityWithCity:(OpendCityInfo*)city
                          area:(OpendAreaInfo*)area
                      keyWords:(NSString*)keywords
                     pageIndex:(NSNumber*)page
                      pageSize:(NSNumber*)pageSize
                    cacheBlock:(void(^)(NSArray* communityArray))cache
                   remoteBlock:(void(^)(NSArray* communityArray, NSError *error))remote {
    GCBlockInvoke(cache, [self localCommunityWithCity:city area:area]);
    
    [JSONServerProxy postJSONWithUrl:k_API_COMMUNITY_QUERY parameters:@{@"queryCommunity":@{@"PageIndex":page, @"PageSize":pageSize, @"Keywords":keywords, @"Province":city.province, @"City":city.city, @"Area":area.area}} success:^(NSDictionary *responseJSON) {
        GCBlockInvoke(remote, [OpendCommunityInfo opendCommunityArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

@end
