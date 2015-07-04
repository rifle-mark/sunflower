//
//  CommonModel.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationAddr.h"

@class CommunityInfo;
@interface CommonModel : NSObject

@property(nonatomic,strong,readonly)NSNumber        *currentCommunityId;
@property(nonatomic,strong,readonly)NSString        *currentCity;

+ (instancetype)sharedModel;

- (NSString *)currentCommunityName;
- (CommunityInfo *)currentCommunity;

- (void)uploadImage:(UIImage *)img
               path:(NSString *)path
           progress:(void(^)())progress
        remoteBlock:(void(^)(NSString *url, NSError *error))remote;

- (void)asyncLocationAddrWithLatitude:(CLLocationDegrees)latitude
                            Longitude:(CLLocationDegrees)longitude
                          remoteBlock:(void(^)(NSArray *locationList, NSError *error))remote;
@end
