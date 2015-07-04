//
//  Payment.h
//  Sunflower
//
//  Created by makewei on 15/6/11.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_PAYMENT            @"Payment"

@interface Payment : NSManagedObject

@property (nonatomic, retain) NSNumber * chargeId;
@property (nonatomic, retain) NSNumber * chargeDate;
@property (nonatomic, retain) NSNumber * chargePrice;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSString * phoneNum;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * chargeType;
@property (nonatomic, retain) NSNumber * type;

@end


@interface PaymentInfo : MKWInfoObject
@property (nonatomic, strong) NSNumber * chargeId;
@property (nonatomic, strong) NSNumber * chargeDate;
@property (nonatomic, strong) NSNumber * chargePrice;
@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSString * phoneNum;
@property (nonatomic, strong) NSNumber * state;
@property (nonatomic, strong) NSNumber * chargeType;
@property (nonatomic, strong) NSNumber * type;
@end