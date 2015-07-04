//
//  CouponCommentView.h
//  Sunflower
//
//  Created by makewei on 15/6/22.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponInfo;
@interface CouponCommentView : UIView

@property (nonatomic, strong) NSString* placeholderString;
@property (nonatomic, strong) CouponInfo* coupon;
@property (nonatomic, strong) UITextView* commentTextView;

- (instancetype)withSubmitAction:(void (^)(NSString* commentContent, NSNumber* couponId))action;

- (void)clearContent;
@end
