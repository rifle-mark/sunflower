//
//  CouponUser.h
//  Sunflower
//
//  Created by makewei on 15/5/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_COUPONUSER     @"CouponUser"

@interface CouponUser : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSNumber * couponId;
@property (nonatomic, retain) NSString * couponName;
@property (nonatomic, retain) NSString * couponNum;
@property (nonatomic, retain) NSNumber * endDate;
@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic, retain) NSNumber * beDeleted;
@property (nonatomic, retain) NSNumber * beUsed;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;

@end

@interface CouponUserInfo : MKWInfoObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSNumber * couponId;
@property (nonatomic, strong) NSString * couponName;
@property (nonatomic, strong) NSString * couponNum;
@property (nonatomic, strong) NSNumber * endDate;
@property (nonatomic, strong) NSNumber * orderId;
@property (nonatomic, strong) NSNumber * beDeleted;
@property (nonatomic, strong) NSNumber * beUsed;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * userName;
@end