//
//  CommunityLifeModel.h
//  Sunflower
//
//  Created by mark on 15/5/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponList.h"
#import "Coupon.h"
#import "ShopPicture.h"
#import "LifeServer.h"
#import "RentList.h"
#import "RentHouse.h"
#import "HouseImage.h"
#import "PropertyShop.h"
#import "WeiComment.h"
#import "CouponComment.h"
#import "CouponJudge.h"

typedef NS_ENUM(NSUInteger, CouponType) {
    Coupon_all,
    Coupon_yi,
    Coupon_shi,
    Coupon_zhu,
    Coupon_xing,
    Coupon_le,
    Coupon_xiang,
};

typedef NS_ENUM(NSUInteger, RentType) {
    Rent_Out = 1,
    Rent_Sale,
    Rent_In
};

typedef NS_ENUM(NSUInteger, CouponCommentType) {
    CommentToShow,
    CommentToManage,
    CommentOfMine
};

@interface CommunityLifeModel : NSObject

+ (instancetype)sharedModel;

#pragma mark - 优惠
- (NSArray*)localCouponListWithCommunityId:(NSNumber*)communityId;
- (void)asyncCouponListWithCommunityId:(NSNumber*)communityId
                             pageIndex:(NSNumber*)page
                              pageSize:(NSNumber*)pageSize
                                  type:(CouponType)type
                            cacheBlock:(void(^)(NSArray *list))cache
                           remoteBlock:(void(^)(NSArray *list, NSError *error))remote;

- (CouponInfo*)localCouponWithCouponId:(NSNumber*)couponId;
- (void)asyncCouponWithCouponId:(NSNumber*)couponId
                     cacheBlock:(void(^)(CouponInfo *info, NSArray *shopList))cache
                    remoteBlock:(void(^)(CouponInfo *info, NSArray *shopList, NSError *error))remote;

- (NSArray*)localShopListWithCouponId:(NSNumber*)couponId;

//// 优惠券评论列表
//#define k_API_L_COUPON_COMMENT_QUERY    @"couponcomment/list"
//// 优惠券评论管理列表
//#define k_API_L_COUPON_COMMENT_MANAGE   @"couponcomment/manage"
//// 用户优惠券评论列表
//#define k_API_L_COUPON_COMMENT_MY       @"couponcomment/mylist"
- (void)asyncCouponCommentListWithType:(CouponCommentType)type
                              couponId:(NSNumber *)couponId
                                  page:(NSNumber*)page
                              pageSize:(NSNumber*)pageSize
                           remoteBlock:(void(^)(NSArray *list, NSNumber *page, NSError *error))remote;
//// 优惠券评论添加
//#define k_API_L_COUPON_COMMENT_ADD      @"couponcomment/add"
- (void)asyncCouponCommentAddWithCouponId:(NSNumber *)couponId
                                  content:(NSString *)content
                              remoteBlock:(void(^)(BOOL isSucces, CouponCommentInfo *info, NSError *error))remote;
//// 优惠券评论设置显示
//#define k_API_L_COUPON_COMMENT_SHOW     @"couponcomment/show"
- (void)asyncCouponCommentShowWithCommentId:(NSNumber *)commentId
                                remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;
//// 优惠券评论设置隐藏
//#define k_API_L_COUPON_COMMENT_HIDE     @"couponcomment/hide"
- (void)asyncCouponCommentHideWithCommentId:(NSNumber *)commentId
                                remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;
- (void)asyncCouponCommentDeleteWithId:(NSNumber *)commentId
                           remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;
//// 优惠券调查问卷列表
//#define k_API_L_COUPON_JUDGE_QUERY      @"question/getdetail"
//// 优惠券调查问卷添加
//#define k_API_L_COUPON_JUDGE_ADD        @"question/add"
- (void)asyncCouponJudgeAddWithArray:(NSArray *)judgeArray
                         remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;
//// 优惠券调查问卷结果
//#define k_API_L_COUPON_JUDGE_RESULT     @"question/couponstatcount"
- (void)asyncCouponJudgeResultWithCouponId:(NSNumber *)couponId
                               remoteBlock:(void(^)(NSArray *list, NSError *error))remote;
//// 优惠券调查问卷提交
//#define k_API_L_COUPON_JUDGE_SUBMIT     @"question/log/add"
- (void)asyncCouponJudgeSubmitWithArray:(NSArray *)judgePointsArray
                               couponId:(NSNumber *)couponId
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (BOOL)hasCouponJudgedWithUserId:(NSNumber *)userId couponId:(NSNumber *)couponId;

#pragma mark - 服务
- (LifeServerInfo*)localLifeServerWithCommunityId:(NSNumber *)communityId serverId:(NSNumber *)serverId;
- (NSArray*)localLifeServerListWithCommunityId:(NSNumber *)communityId;
- (void)asyncLifeServerListWithCommunityId:(NSNumber *)communityId
                                 pageIndex:(NSNumber *)page
                                  pageSize:(NSNumber *)pageSize
                                cacheBlock:(void(^)(NSArray *list))cache
                               remoteBlock:(void(^)(NSArray *list, NSInteger page, NSError *error))remote;

#pragma mark - 租售
- (void)asyncRentListWithCommunityId:(NSNumber *)communityId
                                type:(RentType)type
                           pageIndex:(NSNumber *)page
                            pageSize:(NSNumber *)pageSize
                          cacheBlock:(void(^)(NSArray *list))cache
                         remoteBlock:(void(^)(NSArray *list, NSInteger page, NSError *error))remote;
- (void)asyncRentHouseWithId:(NSNumber *)houseId
                  cacheBlock:(void(^)(RentHouseInfo *info, NSArray *images))cache
                 remoteBlock:(void(^)(RentHouseInfo *info, NSArray *images, NSError *error))remote;

- (void)asyncRentHouseAddWithInfo:(NSDictionary *)infoDic
                      remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;
- (void)asyncRentHouseUpdateWithInfo:(NSDictionary *)infoDic
                         remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

#pragma mark - 黄页
- (void)asyncInfoListWithCommunityId:(NSNumber *)communityId
                                page:(NSNumber *)page
                            pageSize:(NSNumber *)pageSize
                          cacheBlock:(void(^)(NSArray *infoList))cache
                         remoteBlock:(void(^)(NSArray *infoList, NSNumber *cPage, NSError *error))remote;

#pragma mark - 微社区
- (void)asyncWeiListWithCommunityId:(NSNumber *)communityId
                           parentId:(NSNumber *)parentId
                               page:(NSNumber *)page
                           pageSize:(NSNumber *)pageSize
                         cacheBlock:(void(^)(NSArray *commentList))cache
                        remoteBlock:(void(^)(NSArray *commentList, NSNumber *cPage, NSError *error))remote;

- (void)asyncMyWeiListWithCommunityId:(NSNumber *)communityId
                           parentId:(NSNumber *)parentId
                               page:(NSNumber *)page
                           pageSize:(NSNumber *)pageSize
                         cacheBlock:(void(^)(NSArray *commentList))cache
                        remoteBlock:(void(^)(NSArray *commentList, NSNumber *cPage, NSError *error))remote;

- (void)asyncWeiAddWithCommuntiyId:(NSNumber *)communityId
                          parentId:(NSNumber *)parentId
                           content:(NSString *)content
                            images:(NSString *)images
                           address:(NSString *)address
                       remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)asyncWeiUpWithCommentId:(NSNumber *)commentId
                    remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (BOOL)isWeiCommentUpWithCommentId:(NSNumber *)commentId;

- (void)asyncWeiUnlikeWithCommentId:(NSNumber *)commentId
                        remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)asyncWeiReportWithCommentId:(NSNumber *)commentId
                        remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)asyncWeiDeleteWithCommentId:(NSNumber *)commentId
                        remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;
@end
