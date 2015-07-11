//
//  OpendArea.h
//  Sunflower
//
//  Created by mark on 15/4/28.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_OPENDAREA      @"OpendArea"

@interface OpendArea : NSManagedObject

@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * areaId;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSNumber * openCityId;

@end


@interface OpendAreaInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * orderId;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSString * areaId;
@property (nonatomic, strong) NSString * cityId;
@property (nonatomic, strong) NSNumber * openCityId;

@end
