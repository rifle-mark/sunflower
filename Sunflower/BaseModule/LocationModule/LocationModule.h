//
//  LocationModule.h
//  Sunflower
//
//  Created by mark on 15/4/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationModule : NSObject

+ (instancetype)sharedModule;

- (instancetype)withUpdateToLocationBlock:(void(^)(CLLocationManager *manager, CLLocation *toLocation, CLLocation *fromLocation))block;
- (instancetype)withFailedWithErrorBlock:(void(^)(CLLocationManager *manager, NSError *error))block;

- (void)startLocation;
- (void)stopLocation;
@end
