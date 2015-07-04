//
//  UserCouponJudge.h
//  Sunflower
//
//  Created by makewei on 15/6/21.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserCouponJudge : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * couponId;
@property (nonatomic, retain) NSNumber * hasJudged;

@end
