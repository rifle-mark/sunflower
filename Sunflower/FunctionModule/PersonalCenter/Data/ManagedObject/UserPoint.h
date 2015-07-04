//
//  UserPoint.h
//  Sunflower
//
//  Created by makewei on 15/6/18.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_USERPOINT      @"UserPoint"

@interface UserPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * pointId;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSNumber * userId;

@end


@interface UserPointInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSNumber * experience;
@property (nonatomic, strong) NSNumber * pointId;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * points;
@property (nonatomic, strong) NSNumber * userId;

@end