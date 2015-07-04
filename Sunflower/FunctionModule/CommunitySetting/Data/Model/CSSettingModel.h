//
//  CSSettingModel.h
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpendCity.h"
#import "OpendArea.h"
#import "OpendCommunity.h"

@interface CSSettingModel : NSObject

+ (instancetype)sharedModel;

- (NSArray*)localOpendCitys;
- (void)asyncOpendCityWithPage:(NSNumber*)page pageSize:(NSNumber*)pageSize CacheBlock:(void(^)(NSArray* cityArray))cache remoteBlock:(void(^)(NSArray *cityArray, NSError *error))remote;
- (void)refreshLocalOpendCitysWithArray:(NSArray *)citys;


- (NSArray*)localAreaWithCity:(OpendCityInfo*)city;
- (void)asyncAreaWithCity:(OpendCityInfo*)city cacheBlock:(void(^)(NSArray *areaArray))cache remoteBlock:(void(^)(NSArray *areaArray, NSError *error))remote;
- (void)refreshLocalAreasWithCity:(OpendCityInfo*)city areaArray:(NSArray*)areas;


- (NSArray*)localCommunityWithCity:(OpendCityInfo*)city area:(OpendAreaInfo*)area;
- (void)asyncCommunityWithCity:(OpendCityInfo*)city
                          area:(OpendAreaInfo*)area
                      keyWords:(NSString*)keywords
                     pageIndex:(NSNumber*)page
                      pageSize:(NSNumber*)pageSize
                    cacheBlock:(void(^)(NSArray* communityArray))cache
                   remoteBlock:(void(^)(NSArray* communityArray, NSError *error))remote;
@end
