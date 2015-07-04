//
//  UserGuanjia.h
//  Sunflower
//
//  Created by makewei on 15/6/19.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define k_ENTITY_USERGUANJIA        @"UserGuanjia"
@interface UserGuanjia : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * guanJiaId;
@property (nonatomic, retain) NSNumber * isUped;

@end
