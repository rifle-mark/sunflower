//
//  UserModel.h
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "AdminUser.h"
#import "CouponList.h"
#import "Shop.h"
#import "ShopStore.h"
#import "Coupon.h"
#import "CouponUser.h"
#import "RentList.h"
#import "UserPoint.h"
#import "PointRuler.h"
#import "Feed.h"
#import <ShareSDK/ShareSDK.h>

typedef NS_ENUM(NSUInteger, UserRegisterType) {
    NormalUser,
    BusinessUser,
};

@interface UserModel : NSObject

@property(nonatomic,strong, readonly)UserInfo         *currentNormalUser;
@property(nonatomic,strong, readonly)AdminUserInfo    *currentAdminUser;

+ (instancetype)sharedModel;

#pragma mark - Normal User
- (BOOL)isNormalLogined;

- (void)asyncCheckCodeWithPhoneNumber:(NSString *)phoneNumber
                          remoteBlock:(void(^)(NSString *code, NSString *msg, NSError *error))remote;

- (void)normalRegisterWithPhoneNumber:(NSString *)phoneNumber
                             password:(NSString *)passwd
                          remoteBlock:(void(^)(UserInfo *user, NSError *error))remote;

- (void)normalLoginWithUserName:(NSString *)phoneNumber
                       password:(NSString *)passwd
                    remoteBlock:(void(^)(UserInfo *user, NSError *error))remote;

- (void)snsLoginWithInfoDic:(NSDictionary *)logInfo
                remoteBlock:(void(^)(UserInfo *user, NSError *error))remote;

- (void)normalLogOut;

- (void)updateUserInfoWithNickName:(NSString *)nickName
                            avatar:(NSString *)avatar
                       remoteBlock:(void(^)(UserInfo *user, NSError *error))remote;

- (void)setPasswordWithPhoneNumber:(NSString *)phoneNumber
                          password:(NSString *)passwd
                              type:(UserRegisterType)type
                       remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncGetUserValidCouponAtPage:(NSNumber *)page
                             pageSize:(NSNumber *)pageSize
                           cacheBlock:(void(^)(NSArray *couponList))cache
                          remoteBlock:(void(^)(NSArray *couponList, NSNumber *cPage, NSError *error))remote;

- (void)asyncGetUserExpiredCouponAtPage:(NSNumber *)page
                               pageSize:(NSNumber *)pageSize
                             cacheBlock:(void(^)(NSArray *couponList))cache
                            remoteBlock:(void(^)(NSArray *couponList, NSNumber *cPage,  NSError *error))remote;

- (void)asyncGetUserUsedCouponAtPage:(NSNumber *)page
                            pageSize:(NSNumber *)pageSize
                          cacheBlock:(void(^)(NSArray *couponList))cache
                         remoteBlock:(void(^)(NSArray *couponList, NSNumber *cPage,  NSError *error))remote;

- (void)asyncDeleteMyCouponWithId:(NSNumber *)couponId
                      remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncDeleteMyCouponWithArray:(NSArray *)couponIdArray
                         remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncAddUserCouponWithId:(NSNumber *)couponId
                     remoteBlock:(void(^)(BOOL isSuccess, NSString *couponCode, NSString *msg, NSError *error))remote;

- (void)asyncGetUserHouseListAtPage:(NSNumber *)page
                           pageSize:(NSNumber *)pageSize
                         cacheBlock:(void(^)(NSArray *houseList))cache
                        remoteBlock:(void(^)(NSArray *houseList, NSNumber *cPage,  NSError *error))remote;

- (void)asyncDeleteMyHouseWithId:(NSNumber *)houseId
                     remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncDeleteMyHouseWithArray:(NSArray *)houseIdArray
                        remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;


- (void)asyncGetUserAuditTelNumbersWithCommunityId:(NSNumber *)communityId
                                             build:(NSString *)build
                                              unit:(NSString *)unit
                                              room:(NSString *)room
                                            remote:(void(^)(NSArray *telNums, NSError *error))remote;

- (void)asyncAuditWithInfoDic:(NSDictionary *)auditInfo
                  remoteBlock:(void(^)(UserInfo *user, NSError *error))remote;

- (void)asyncAddUserPointWithType:(NSNumber *)type
                      remoteBlock:(void(^)(UserPointInfo *point, NSError *error))remote;

- (void)asyncFixRecordListWithCommunityId:(NSNumber *)communityId
                                     page:(NSNumber *)page
                                 pageSize:(NSNumber *)pageSize
                              remoteBlock:(void(^)(NSArray *list, NSNumber *cPage, NSError *error))remote;

- (void)asyncFixRecordDeleteWithIdArray:(NSArray *)idArray
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)asyncChargeRecordListWithPage:(NSNumber *)page
                             pageSize:(NSNumber *)pageSize
                          remoteBlock:(void(^)(NSArray *list, NSNumber *page, NSError *error))remote;


- (void)asyncThirdPartyLoginWithShareType:(ShareType)type
                              remoteBlock:(void(^)(UserInfo *user, NSError *error))remote;

- (void)asyncUserPointRuleListWithRemoteBlock:(void(^)(NSArray *list, NSError *error))remote;

- (void)asyncAddFeedWithContent:(NSString *)content
                      imageUrls:(NSArray *)imageUrls
                    remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)asyncFeedListWithWithPage:(NSNumber *)page
                         pageSize:(NSNumber *)pageSize
                      remoteBlock:(void(^)(NSArray *list, NSNumber *page, NSError *error))remote;

#pragma mark - Admin User
- (BOOL)isBusinessAdminLogined;
- (BOOL)isPropertyAdminLogined;

- (void)adminLoginWithUserName:(NSString *)phoneNumber
                      password:(NSString *)passwd
                          type:(AdminUserType)type
                   remoteBlock:(void(^)(AdminUserInfo *admin, NSError *error))remote;

- (void)adminLogOutWithType:(AdminUserType)type;

- (void)asyncApplyPropertyWithProvince:(NSString *)province
                                  city:(NSString *)city
                               address:(NSString *)address
                         communityName:(NSString *)communityName
                              userName:(NSString *)name
                                   tel:(NSString *)tel
                           remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)updateAdminInfoWithNickName:(NSString *)nickName
                             avatar:(NSString *)avatar
                        remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;


#pragma mark - Business

- (void)businessUserRegistWithName:(NSString *)name
                          phoneNum:(NSString *)phoneNum
                          password:(NSString *)password
                       communityId:(NSNumber *)communityId
                              type:(NSNumber *)type
                       remoteBlock:(void(^)(AdminUserInfo *admin, NSError *error))remote;

- (void)asyncGetShopInfoWithCacheBlock:(void(^)(ShopInfo *shop, NSArray *shopStoreList))cache
                           remoteBlock:(void(^)(ShopInfo *shop, NSArray *shopStoreList, NSError *error))remote;

- (void)asyncUpdateShopInfoWithName:(NSString *)name
                                tel:(NSString *)tel
                            address:(NSString *)address
                               logo:(NSString *)logo
                               desc:(NSString *)desc
                        remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncAddShopStoreWithName:(NSString *)name
                                tel:(NSString *)tel
                            address:(NSString *)address
                        remoteBlock:(void(^)(BOOL isSuccess, NSNumber *shopId, NSString *msg, NSError *error))remote;

- (void)asyncUpdateShopStoreWithShopId:(NSNumber *)shopId
                                  name:(NSString *)name
                                   tel:(NSString *)tel
                               address:(NSString *)address
                           remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncDeleteShopStoreWithShopId:(NSNumber *)shopId
                           remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncGetShopCouponListWithPage:(NSNumber *)page
                              pageSize:(NSNumber *)pageSize
                            CacheBlock:(void(^)(NSArray *couponList))cache
                           remoteBlock:(void(^)(NSArray *couponList, NSNumber *cPage, NSError *error))remote;

- (void)asyncAddCouponWithName:(NSString *)name
                      subTitle:(NSString *)them
                       endDate:(NSString *)enddate
                        detail:(NSString *)detail
                        imgUrl:(NSString *)imgurl
                   remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncUpdateCouponWithCouponId:(NSNumber *)couponId
                                 name:(NSString *)name
                             subTitle:(NSString *)them
                              endDate:(NSString *)enddate
                               detail:(NSString *)detail
                               imgUrl:(NSString *)imgurl
                          remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncDeleteCouponWithCouponId:(NSNumber *)couponId
                          remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncGetOrderUserWithKey:(NSString *)key
                            page:(NSNumber *)page
                        pageSize:(NSNumber *)pageSize
                     remoteBlock:(void(^)(NSArray *orderList, NSNumber *cPage, NSError *error))remote;

- (void)asyncSetOrderUsedWithId:(NSNumber *)orderId
                    remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

@end
