//
//  UserModel.m
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "UserModel.h"
#import "ServerProxy.h"

#import "MKWModelHandler.h"
#import "FixIssue.h"
#import "Payment.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@interface UserModel ()

@end

@implementation UserModel

+ (instancetype)sharedModel {
    static UserModel *retVal = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        retVal = [[UserModel alloc] init];
    });
    return retVal;
}

- (instancetype)init {
    if (self = [super init]) {
        User *u = (User*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_USER] firstObject];
        if (u) {
            _currentNormalUser = [UserInfo infoWithManagedObj:u];
        }
        
        AdminUser *ad = (AdminUser*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_ADMINUSER] firstObject];
        if (ad) {
            _currentAdminUser = [AdminUserInfo infoWithManagedObj:ad];
        }
    }
    return self;
}

- (BOOL)isNormalLogined {
    return self.currentNormalUser != nil;
}

- (BOOL)isBusinessAdminLogined {
    if ([self.currentAdminUser.adminType integerValue] == Business) {
        return YES;
    }
    return NO;
}
- (BOOL)isPropertyAdminLogined {
    if ([self.currentAdminUser.adminType integerValue] == Property) {
        return YES;
    }
    return NO;
}

#pragma mark - Normal User

- (void)normalRegisterWithPhoneNumber:(NSString *)phoneNumber
                             password:(NSString *)passwd
                          remoteBlock:(void(^)(UserInfo *user, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_USER_REGISTER parameters:@{@"regUser":@{@"UserName":phoneNumber, @"Password":passwd, @"Type":@1}} success:^(NSDictionary *responseJSON) {
        if ([[responseJSON objectForKey:@"isSuc"] boolValue]) {
            // 注册成功
            
            GCBlockInvoke(remote, [self _handleUserInfoWithDic:responseJSON], nil);
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_REGISTER object:nil];
            
        }
        else {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:1801002 userInfo:nil]);
        }
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)normalLoginWithUserName:(NSString *)phoneNumber
                       password:(NSString *)passwd
                    remoteBlock:(void(^)(UserInfo *user, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_USER_LOGIN_NORMAL parameters:@{@"userName":phoneNumber, @"password":passwd} success:^(NSDictionary *responseJSON) {
        if ([[responseJSON objectForKey:@"isSuc"] boolValue]) {
            // 登录成功
            
            GCBlockInvoke(remote, [self _handleUserInfoWithDic:responseJSON], nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_LOGIN object:nil];
        }
        else {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:1801003 userInfo:nil]);
        }
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)snsLoginWithInfoDic:(NSDictionary *)logInfo
                remoteBlock:(void(^)(UserInfo *user, NSError *error))remote {
    
}

- (UserInfo*)_handleUserInfoWithDic:(NSDictionary *)dic {
    UserInfo *info = [[UserInfo alloc] init];
    [info infoWithJSONDic:[dic objectForKey:@"result"]];
    [info saveToDb];
    _currentNormalUser = info;
    [[NSUserDefaults standardUserDefaults] setValue:info.token forKey:k_USERDEFAULTS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return info;
}

- (void)normalLogOut {
    _currentNormalUser = nil;
    [[MKWModelHandler defaultHandler] deleteObjectsInEntity:k_ENTITY_USER];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_USERDEFAULTS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_LOGOUT_NORMAL object:nil];
}

- (void)updateUserInfoWithNickName:(NSString *)nickName
                            avatar:(NSString *)avatar
                       remoteBlock:(void(^)(UserInfo *user, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_USER_INFO_UPDATE parameters:@{@"userInfo":@{@"Avatar":avatar,@"NickName":nickName}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:-1 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [self _handleUserInfoWithDic:responseJSON], nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_INFO_UPDATE object:nil];
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)setPasswordWithPhoneNumber:(NSString *)phoneNumber
                          password:(NSString *)passwd
                              type:(UserRegisterType)type
                       remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    NSString *url = @"";
    if (type == NormalUser) {
        url = k_API_P_USER_RESET_PASSWD;
    }
    else {
        url = k_API_P_USER_REST_PASSWD_BUSINESS;
    }
    [JSONServerProxy postJSONWithUrl:url parameters:@{@"phonenum":phoneNumber, @"password":passwd} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [[responseJSON objectForKey:@"isSuc"] boolValue], [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, @"网络错误", error);
    }];
}

- (void)asyncGetUserValidCouponAtPage:(NSNumber *)page
                             pageSize:(NSNumber *)pageSize
                           cacheBlock:(void(^)(NSArray *couponList))cache
                          remoteBlock:(void(^)(NSArray *couponList, NSNumber *cPage, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@",k_API_P_COUPON_MY_QUERY,page,pageSize] success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CouponListInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncGetUserExpiredCouponAtPage:(NSNumber *)page
                               pageSize:(NSNumber *)pageSize
                             cacheBlock:(void(^)(NSArray *couponList))cache
                            remoteBlock:(void(^)(NSArray *couponList, NSNumber *cPage,  NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@",k_API_P_COUPON_MY_EXPIRED_QUERY,page,pageSize] success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CouponListInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncGetUserUsedCouponAtPage:(NSNumber *)page
                            pageSize:(NSNumber *)pageSize
                          cacheBlock:(void(^)(NSArray *couponList))cache
                         remoteBlock:(void(^)(NSArray *couponList, NSNumber *cPage,  NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@",k_API_P_COUPON_MY_USED_QUERY,page,pageSize] success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CouponListInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncDeleteMyCouponWithId:(NSNumber *)couponId
                      remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_COUPON_MY_DELETE parameters:@{@"couponId":couponId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        self.currentNormalUser.couponCount = @([self.currentNormalUser.couponCount integerValue] -1);
        [self.currentNormalUser saveToDb];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_INFO_UPDATE object:nil];
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncDeleteMyCouponWithArray:(NSArray *)couponIdArray
                         remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_COUPON_MY_DELETE_ARRAY parameters:@{@"couponIds":couponIdArray} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        self.currentNormalUser.couponCount = @([self.currentNormalUser.couponCount integerValue]-[couponIdArray count]);
        [self.currentNormalUser saveToDb];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_INFO_UPDATE object:nil];
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncAddUserCouponWithId:(NSNumber *)couponId
                     remoteBlock:(void(^)(BOOL isSuccess, NSString *couponCode, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_COUPON_MY_ADD parameters:@{@"couponId":couponId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, nil, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        self.currentNormalUser.couponCount = @([self.currentNormalUser.couponCount integerValue] +1);
        [self.currentNormalUser saveToDb];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_INFO_UPDATE object:nil];
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"result"], [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, nil, error.domain, error);
    }];
}


- (void)asyncGetUserHouseListAtPage:(NSNumber *)page
                           pageSize:(NSNumber *)pageSize
                         cacheBlock:(void(^)(NSArray *houseList))cache
                        remoteBlock:(void(^)(NSArray *houseList, NSNumber *cPage,  NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@",k_API_P_HOUSE_MY_LIST_QUERY,page,pageSize] success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [RentListInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncDeleteMyHouseWithId:(NSNumber *)houseId
                     remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@",k_API_P_HOUSE_MY_DELETE, houseId] success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncDeleteMyHouseWithArray:(NSArray *)houseIdArray
                        remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_HOUSE_MY_DELETE_ARRAY parameters:@{@"ids":houseIdArray} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncGetUserAuditTelNumbersWithCommunityId:(NSNumber *)communityId
                                             build:(NSString *)build
                                              unit:(NSString *)unit
                                              room:(NSString *)room
                                            remote:(void(^)(NSArray *telNums, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_AUDIT_TELNUM_QUERY parameters:@{@"info":@{@"CommunityId":communityId,@"Build":build,@"Units":unit,@"Rooms":room}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        NSString *tels = (NSString*)[responseJSON objectForKey:@"result"];
        GCBlockInvoke(remote, [tels componentsSeparatedByString:@","], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)asyncAuditWithInfoDic:(NSDictionary *)auditInfo
                  remoteBlock:(void(^)(UserInfo *user, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_AUDIT_AUDIT parameters:auditInfo success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [self _handleUserInfoWithDic:responseJSON], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)asyncAddUserPointWithType:(NSNumber *)type
                      remoteBlock:(void(^)(UserPointInfo *point, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_USER_POINT_ADD parameters:@{@"type":type} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        UserPointInfo *info = [[UserPointInfo alloc] init];
        GCBlockInvoke(remote, [info infoWithJSONDic:[responseJSON objectForKey:@"result"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)asyncFixRecordListWithCommunityId:(NSNumber *)communityId
                                     page:(NSNumber *)page
                                 pageSize:(NSNumber *)pageSize
                              remoteBlock:(void(^)(NSArray *list, NSNumber *cPage, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_FIX_QUERY parameters:@{@"pageindex":page,@"pagesize":pageSize,@"communityid":communityId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [FixIssueInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncFixRecordDeleteWithIdArray:(NSArray *)idArray
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_FIX_DELETE parameters:@{@"ids":idArray} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}

- (void)asyncChargeRecordListWithPage:(NSNumber *)page
                             pageSize:(NSNumber *)pageSize
                          remoteBlock:(void(^)(NSArray *list, NSNumber *page, NSError *error))remote {
    k_API_P_CHARGE_QUERY;
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@", k_API_P_CHARGE_QUERY, page, pageSize] success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [[NSError alloc] initWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [PaymentInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
    
}

-(void)asyncThirdPartyLoginWithShareType:(ShareType)type
                             remoteBlock:(void(^)(UserInfo *user, NSError *error))remote{
    if (type == ShareTypeWeixiSession) {
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"sunflower" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
        _weak(self);
        [self addObserverForNotificationName:k_NOTIFY_NAME_WXAUTH_SUCCESS usingBlock:^(NSNotification *notification) {
            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx9d7542e3d90fd680",@"65794a56b94ac0ff176c609f4103068e",[notification.userInfo objectForKey:@"code"]];
            
            [HTMLServerProxy getWithUrl:url success:^(NSDictionary *responseJSON) {
                NSString *token = [responseJSON objectForKey:@"access_token"];
                NSString *infourl =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,[responseJSON objectForKey:@"openid"]];
                _weak(token);
                [HTMLServerProxy getWithUrl:infourl success:^(NSDictionary *responseJSON) {
                    _strong(token);
                    [JSONServerProxy postJSONWithUrl:k_API_P_USER_LOGIN_SOCIAL parameters:@{@"socialuser":@{@"Platform":@4, @"OpenId":[responseJSON objectForKey:@"openid"], @"Token":token, @"Avatar":[responseJSON objectForKey:@"headimgurl"], @"AppId":@"", @"NickName":[responseJSON objectForKey:@"nickname"]}} success:^(NSDictionary *responseJSON) {
                        if ([[responseJSON objectForKey:@"isSuc"] boolValue]) {
                            // 登录成功
                            _strong(self);
                            GCBlockInvoke(remote, [self _handleUserInfoWithDic:responseJSON], nil);
                            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_LOGIN object:nil];
                        }
                        else {
                            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
                        }
                    } failed:^(NSError *error) {
                        GCBlockInvoke(remote, nil, error);
                    }];
                } failed:^(NSError *error) {
                    GCBlockInvoke(remote, nil, [NSError errorWithDomain:@"认证失败" code:-1 userInfo:nil]);
                }];
            } failed:^(NSError *error) {
                GCBlockInvoke(remote, nil, [NSError errorWithDomain:@"认证失败" code:-1 userInfo:nil]);
            }];
            
        }];
        [self addObserverForNotificationName:k_NOTIFY_NAME_WXAUTH_FAILED usingBlock:^(NSNotification *notification) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:@"认证失败" code:-1 userInfo:nil]);
        }];
        
        return;
    }
    else {
        [ShareSDK authWithType:type options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
            if (state == SSAuthStateSuccess) {
                [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> terror) {
                    if(result){
                        NSNumber *platform = @0;
                        if (type == ShareTypeQQSpace) {
                            platform = @3;
                        }
                        if (type == ShareTypeWeixiSession) {
                            platform = @4;
                        }
                        [JSONServerProxy postJSONWithUrl:k_API_P_USER_LOGIN_SOCIAL parameters:@{@"socialuser":@{@"Platform":platform, @"OpenId":[userInfo uid], @"Token":[[userInfo credential] token], @"Avatar":[userInfo profileImage], @"AppId":@"", @"NickName":[userInfo nickname]}} success:^(NSDictionary *responseJSON) {
                            if ([[responseJSON objectForKey:@"isSuc"] boolValue]) {
                                // 登录成功
                                GCBlockInvoke(remote, [self _handleUserInfoWithDic:responseJSON], nil);
                                [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_USER_LOGIN object:nil];
                            }
                            else {
                                GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
                            }
                        } failed:^(NSError *error) {
                            GCBlockInvoke(remote, nil, error);
                        }];
                    }
                    else {
                        GCBlockInvoke(remote, nil, [NSError errorWithDomain:terror.errorDescription code:terror.errorCode userInfo:nil]);
                    }
                    
                }];
            }
            else {
                GCBlockInvoke(remote, nil, [NSError errorWithDomain:@"授权失败" code:-1 userInfo:nil]);
            }
        }];
    }
}

- (void)asyncUserPointRuleListWithRemoteBlock:(void(^)(NSArray *list, NSError *error))remote {
    [JSONServerProxy getWithUrl:k_API_P_USER_POINT_RULE_QUERY success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [PointRulerInfo infoArrayWithJSONArray:[responseJSON objectForKey:@"result"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}


#pragma mark - Admin User

- (void)adminLoginWithUserName:(NSString *)phoneNumber
                      password:(NSString *)passwd
                          type:(AdminUserType)type
                   remoteBlock:(void(^)(AdminUserInfo *admin, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:(type==Business?k_API_P_USER_LOGIN_BUSINESS:k_API_P_USER_LOGIN_PROPERTY) parameters:@{@"userName":phoneNumber,@"password":passwd} success:^(NSDictionary *responseJSON) {
        if ([[responseJSON objectForKey:@"isSuc"] boolValue]) {
            // 登录成功
            
            GCBlockInvoke(remote, [self _handleAdminUserInfoWithDic:responseJSON type:type], nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:(type==Business?k_NOTIFY_NAME_BUSINESS_USER_LOGIN:k_NOTIFY_NAME_PROPERTY_USER_LOGIN) object:nil];
        }
        else {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)businessUserRegistWithName:(NSString *)name
                          phoneNum:(NSString *)phoneNum
                          password:(NSString *)password
                       communityId:(NSNumber *)communityId
                              type:(NSNumber *)type
                       remoteBlock:(void(^)(AdminUserInfo *admin, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_USER_REGIST_BUSINESS parameters:@{@"userName":phoneNum, @"password":password, @"realName":name, @"communityid":communityId, @"sellertype":type} success:^(NSDictionary *responseJSON) {
        if ([[responseJSON objectForKey:@"isSuc"] boolValue]) {
            // 注册成功
            
            GCBlockInvoke(remote, [self _handleAdminUserInfoWithDic:responseJSON type:Business], nil);
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_BUSINESS_USER_REGISTER object:nil];
            
        }
        else {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
        }
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}


- (AdminUserInfo*)_handleAdminUserInfoWithDic:(NSDictionary *)dic type:(AdminUserType)type {
    AdminUserInfo *info = [[AdminUserInfo alloc] init];
    [info infoWithJSONDic:[dic objectForKey:@"result"]];
    info.adminType = @(type);
    [info saveToDb];
    _currentAdminUser = info;
    [[NSUserDefaults standardUserDefaults] setValue:info.adminToken forKey:k_USERDEFAULTS_ADMIN_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return info;
}

- (void)adminLogOutWithType:(AdminUserType)type {
    if ([_currentAdminUser.adminType integerValue] == type) {
        _currentAdminUser = nil;
        [[MKWModelHandler defaultHandler] deleteObjectsInEntity:k_ENTITY_ADMINUSER];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_USERDEFAULTS_ADMIN_TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:(type==Business?k_NOTIFY_NAME_BUSINESS_USER_LOGOUT:k_NOTIFY_NAME_PROPERTY_USER_LOGOUT) object:nil];
    }
    
}

- (void)updateAdminInfoWithNickName:(NSString *)nickName
                             avatar:(NSString *)avatar
                        remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_USER_ADMINE_INFO_UPDATE parameters:@{@"userInfo":@{@"RealName":nickName,@"Avatar":avatar,@"Password":@""}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}

- (void)asyncCheckCodeWithPhoneNumber:(NSString *)phoneNumber
                          remoteBlock:(void(^)(NSString *code, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_CHECKCODE_QUERY parameters:@{@"phonenum":phoneNumber} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [responseJSON objectForKey:@"result"], [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, nil, error);
    }];
}

- (void)asyncApplyPropertyWithProvince:(NSString *)province
                                  city:(NSString *)city
                               address:(NSString *)address
                         communityName:(NSString *)communityName
                              userName:(NSString *)name
                                   tel:(NSString *)tel
                           remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_USER_APPLY_PROPERTY parameters:@{@"apply":@{@"Province":province,@"City":city,@"Address":address,@"CommunityName":communityName,@"TrueName":name,@"Tel":tel}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}



- (void)asyncGetShopInfoWithCacheBlock:(void(^)(ShopInfo *shop, NSArray *shopStoreList))cache
                           remoteBlock:(void(^)(ShopInfo *shop, NSArray *shopStoreList, NSError *error))remote {
    [JSONServerProxy getWithUrl:k_API_P_SHOP_INFO success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        ShopInfo *shop = [[ShopInfo alloc] init];
        GCBlockInvoke(remote, [shop infoWithJSONDic:[responseJSON objectForKey:@"result"]], [ShopStoreInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"shopPictures"]], nil);
        
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, nil, error);
    }];
}

- (void)asyncUpdateShopInfoWithName:(NSString *)name
                                tel:(NSString *)tel
                            address:(NSString *)address
                               logo:(NSString *)logo
                               desc:(NSString *)desc
                        remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_INFO_UPDATE parameters:@{@"seller":@{@"Name":[MKWStringHelper isNilEmptyOrBlankString:name]?@"":name,@"Tel":[MKWStringHelper isNilEmptyOrBlankString:tel]?@"":tel,@"Address":[MKWStringHelper isNilEmptyOrBlankString:address]?@"":address,@"Logo":[MKWStringHelper isNilEmptyOrBlankString:logo]?@"":logo,@"Description":[MKWStringHelper isNilEmptyOrBlankString:desc]?@"":desc}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, @"保存失败", [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, @"保存成功", nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, @"保存失败", error);
    }];
}

- (void)asyncAddShopStoreWithName:(NSString *)name
                              tel:(NSString *)tel
                          address:(NSString *)address
                      remoteBlock:(void(^)(BOOL isSuccess, NSNumber *shopId, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_ADD_STORE parameters:@{@"sellerShop":@{@"Name":name, @"Tel":tel, @"Address":address}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, @-1, @"添加失败", [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"result"], @"添加成功", nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, @-1, @"添加失败", error);
    }];
}

- (void)asyncUpdateShopStoreWithShopId:(NSNumber *)shopId
                                  name:(NSString *)name
                                   tel:(NSString *)tel
                               address:(NSString *)address
                           remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_UPDATE_STORE parameters:@{@"sellerShop":@{@"ShopId":shopId, @"Name":name, @"Tel":tel, @"Address":address}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, @"保存失败", [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, @"保存成功", nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, @"保存失败", error);
    }];
}

- (void)asyncDeleteShopStoreWithShopId:(NSNumber *)shopId
                           remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_DELETE_STORE parameters:@{@"shopid":shopId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, @"删除失败", [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, @"删除成功", nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, @"删除失败", error);
    }];
}



- (void)asyncGetShopCouponListWithPage:(NSNumber *)page
                              pageSize:(NSNumber *)pageSize
                            CacheBlock:(void(^)(NSArray *couponList))cache
                           remoteBlock:(void(^)(NSArray *couponList, NSNumber *cPage, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@", k_API_P_SHOP_COUPON_QUERY, page, pageSize] success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CouponListInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncAddCouponWithName:(NSString *)name
                      subTitle:(NSString *)them
                       endDate:(NSString *)enddate
                        detail:(NSString *)detail
                        imgUrl:(NSString *)imgurl
                   remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_COUPON_ADD parameters:@{@"coupon":@{@"Name":name,@"SubTitle":them,@"Image":imgurl,@"EndDate":enddate,@"Description":detail}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncUpdateCouponWithCouponId:(NSNumber *)couponId
                                 name:(NSString *)name
                             subTitle:(NSString *)them
                              endDate:(NSString *)enddate
                               detail:(NSString *)detail
                               imgUrl:(NSString *)imgurl
                          remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_COUPON_UPDATE parameters:@{@"coupon":@{@"Id":couponId, @"Name":name,@"SubTitle":them,@"Image":imgurl,@"EndDate":enddate,@"Description":detail}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncDeleteCouponWithCouponId:(NSNumber *)couponId
                          remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_COUPON_DELETE parameters:@{@"Id":couponId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}


- (void)asyncGetOrderUserWithKey:(NSString *)key
                            page:(NSNumber *)page
                        pageSize:(NSNumber *)pageSize
                     remoteBlock:(void(^)(NSArray *orderList, NSNumber *cPage, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_COUPON_USER_QUERY parameters:@{@"pageindex":page,@"pagesize":pageSize,@"key":key} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CouponUserInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncSetOrderUsedWithId:(NSNumber *)orderId
                    remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_P_SHOP_COUPON_USER_USE parameters:@{@"Id":orderId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

@end
