//
//  UserPointHandler.h
//  Sunflower
//
//  Created by makewei on 15/6/18.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UserPointType) {
    CheckIn = 1,
    WeiCommentAdd,
    ActionUp,
    WeiCommentSubComment,
    ChargePay,
    FixAdd,
    UserInfoAdd,
    NoteRead,
    RentAdd,
    RentRead,
    CouponGet,
    CommunityAudit,
    CouponJudgeAdd,
    CouponCommentAdd
};

@interface UserPointHandler : NSObject

+ (void)addUserPointWithType:(UserPointType)type showInfo:(BOOL)showInfo;
@end
