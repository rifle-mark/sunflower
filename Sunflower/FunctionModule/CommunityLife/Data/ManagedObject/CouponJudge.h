//
//  CouponJudge.h
//  Sunflower
//
//  Created by makewei on 15/6/20.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_COUPONJUDGE        @"CouponJudge"

@interface CouponJudge : NSManagedObject

@property (nonatomic, retain) NSNumber * couponId;
@property (nonatomic, retain) NSNumber * questionId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * five;
@property (nonatomic, retain) NSNumber * four;
@property (nonatomic, retain) NSNumber * three;
@property (nonatomic, retain) NSNumber * two;
@property (nonatomic, retain) NSNumber * one;
@property (nonatomic, retain) NSNumber * zero;

@end

@interface CouponJudgeInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * couponId;
@property (nonatomic, strong) NSNumber * questionId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * five;
@property (nonatomic, strong) NSNumber * four;
@property (nonatomic, strong) NSNumber * three;
@property (nonatomic, strong) NSNumber * two;
@property (nonatomic, strong) NSNumber * one;
@property (nonatomic, strong) NSNumber * zero;

@end
