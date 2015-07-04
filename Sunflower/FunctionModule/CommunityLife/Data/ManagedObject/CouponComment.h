//
//  CouponComment.h
//  Sunflower
//
//  Created by makewei on 15/6/20.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_COUPONCOMMENT      @"CouponComment"

@interface CouponComment : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * couponCommentId;
@property (nonatomic, retain) NSNumber * couponId;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSNumber * isCommentDeleted;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * userId;

@end


@interface CouponCommentInfo : MKWInfoObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * couponCommentId;
@property (nonatomic, strong) NSNumber * couponId;
@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSNumber * isCommentDeleted;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSNumber * userId;

@end