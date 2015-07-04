//
//  UserPointHandler.m
//  Sunflower
//
//  Created by makewei on 15/6/18.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "UserPointHandler.h"
#import "UserModel.h"

@implementation UserPointHandler

+ (void)addUserPointWithType:(UserPointType)type showInfo:(BOOL)showInfo {
    [[UserModel sharedModel] asyncAddUserPointWithType:@(type) remoteBlock:^(UserPointInfo *point, NSError *error) {
        if (!error && showInfo) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"获得%@积分", point.points]];
        }
        if (!error) {
            UserInfo *cUser = [UserModel sharedModel].currentNormalUser;
            cUser.points = @([cUser.points integerValue] + [point.points integerValue]);
            [cUser saveToDb];
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_INFO_UPDATE object:nil];
        }
    }];
}

@end
