//
//  LocationAddr.h
//  Sunflower
//
//  Created by makewei on 15/6/7.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"


#define k_ENTITY_LOCATIONADDR       @"LocationAddr"

@interface LocationAddr : NSManagedObject

@property (nonatomic, retain) NSString * addr;
@property (nonatomic, retain) NSString * cp;
@property (nonatomic, retain) NSString * direction;
@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * poiType;
@property (nonatomic, retain) NSNumber * pointX;
@property (nonatomic, retain) NSNumber * pointY;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * zip;

@end

@interface LocationAddrInfo : MKWInfoObject
@property (nonatomic, strong) NSString * addr;
@property (nonatomic, strong) NSString * cp;
@property (nonatomic, strong) NSString * direction;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * poiType;
@property (nonatomic, strong) NSNumber * pointX;
@property (nonatomic, strong) NSNumber * pointY;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * zip;
@end