//
//  CouponList.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_COUPONLIST         @"CouponList"

@interface CouponList : NSManagedObject

@property (nonatomic, retain) NSNumber * couponId;
@property (nonatomic, retain) NSNumber * startDate;
@property (nonatomic, retain) NSNumber * endDate;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSNumber * useCount;
@property (nonatomic, retain) NSNumber * hasUseCount;
@property (nonatomic, retain) NSNumber * state;

@end


@interface CouponListInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * couponId;
@property (nonatomic, strong) NSNumber * startDate;
@property (nonatomic, strong) NSNumber * endDate;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * subTitle;
@property (nonatomic, strong) NSNumber * useCount;
@property (nonatomic, strong) NSNumber * hasUseCount;
@property (nonatomic, strong) NSNumber * state;

@end
