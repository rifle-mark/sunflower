//
//  LocationModule.m
//  Sunflower
//
//  Created by mark on 15/4/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "LocationModule.h"
#import "GCExtension.h"

@interface LocationModule () <CLLocationManagerDelegate>


@property(nonatomic,strong)CLLocationManager    *lmanager;
@property(nonatomic,copy)void(^updateToLocationBlock)(CLLocationManager *manager, CLLocation *toLocation, CLLocation *fromLocation);
@property(nonatomic,copy)void(^failedWithErrorBlock)(CLLocationManager *, NSError *error);
@end

@implementation LocationModule

+ (instancetype)sharedModule {
    static LocationModule* retVal = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        LocationModule* ret = [[LocationModule alloc] init];
        retVal = ret;
    });
    return retVal;
}

- (instancetype)init {
    if (self = [super init]) {
        _lmanager = [[CLLocationManager alloc] init];
        
        if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            NSLog(@"没有定位权限");
        }
        
        if ([_lmanager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_lmanager requestAlwaysAuthorization];
            [_lmanager requestWhenInUseAuthorization];
        }
        _lmanager.delegate = self;
        _lmanager.desiredAccuracy = kCLLocationAccuracyBest;
        _lmanager.distanceFilter = 10.0f;
    }
    return self;
}

- (instancetype)withUpdateToLocationBlock:(void(^)(CLLocationManager *manager, CLLocation *toLocation, CLLocation *fromLocation))block {
    if (block) {
        self.updateToLocationBlock = block;
    }
    return self;
}
- (instancetype)withFailedWithErrorBlock:(void(^)(CLLocationManager *manager, NSError *error))block {
    if (block) {
        self.failedWithErrorBlock = block;
    }
    return self;
}

- (void)startLocation {
    [_lmanager startUpdatingLocation];
}

- (void)stopLocation {
    [_lmanager stopUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    GCBlockInvoke(self.updateToLocationBlock, manager, newLocation, oldLocation);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    GCBlockInvoke(self.failedWithErrorBlock, manager, error);
}
@end
