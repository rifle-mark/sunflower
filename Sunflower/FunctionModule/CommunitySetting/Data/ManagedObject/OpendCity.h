//
//  OpendCity.h
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_OPENDCITY      @"OpendCity"

@interface OpendCity : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * cityId;
@property (nonatomic, retain) NSString * province;

@end

@interface OpendCityInfo : MKWInfoObject

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSNumber * cityId;
@property (nonatomic, strong) NSString * province;

@end
