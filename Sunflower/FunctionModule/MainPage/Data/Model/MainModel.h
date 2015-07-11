//
//  MainModel.h
//  Sunflower
//
//  Created by makewei on 15/5/31.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Community.h"
#import "CommunityBuild.h"

@interface MainModel : NSObject

+ (void)asyncGetCommunityInfoWithId:(NSNumber *)communityId
                         cacheBlock:(void(^)(CommunityInfo *community, NSArray *buildList))cache
                        remoteBlock:(void(^)(CommunityInfo *community, NSArray *buildList, NSError *error))remote;

+ (void)asyncGetWeatherInfoWithCityName:(NSString *)city
                            remoteBlock:(void(^)(NSDictionary *info, NSError *error))remote;
@end
