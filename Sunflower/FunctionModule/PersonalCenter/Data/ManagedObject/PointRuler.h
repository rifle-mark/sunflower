//
//  PointRuler.h
//  Sunflower
//
//  Created by makewei on 15/7/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_POINTRULER     @"PointRuler"


@interface PointRuler : NSManagedObject

@property (nonatomic, retain) NSNumber * rulerId;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;

@end

@interface PointRulerInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * rulerId;
@property (nonatomic, strong) NSNumber * points;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * type;

@end
