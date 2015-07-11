//
//  CommunityLifeModel.m
//  Sunflower
//
//  Created by mark on 15/5/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CommunityLifeModel.h"
#import "MKWModelHandler.h"
#import "ServerProxy.h"

#import "GCExtension.h"
#import "WeiCommentAction.h"
#import "UserModel.h"
#import "UserCouponJudge.h"

@implementation CommunityLifeModel

+ (instancetype)sharedModel {
    static CommunityLifeModel *retVal = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        retVal = [[CommunityLifeModel alloc] init];
    });
    return retVal;
}


#pragma mark - 优惠券
- (NSArray*)localCouponListWithCommunityId:(NSNumber*)communityId {
//    return [[MKWModelHandler defaultHandler]queryObjectsForEntity:k_ENTITY_COUPONLIST predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]];
    NSArray *dbArray = [[MKWModelHandler defaultHandler]queryObjectsForEntity:k_ENTITY_COUPONLIST];
    if (dbArray && [dbArray count] > 0) {
        NSMutableArray *retArray = [[NSMutableArray alloc] init];
        for (CouponList *db in dbArray) {
            [retArray addObject:[CouponListInfo infoWithManagedObj:db]];
        }
        return retArray;
    }
    return nil;
}
- (void)asyncCouponListWithCommunityId:(NSNumber*)communityId
                             pageIndex:(NSNumber*)page
                              pageSize:(NSNumber*)pageSize
                                  type:(CouponType)type
                            cacheBlock:(void(^)(NSArray *list))cache
                           remoteBlock:(void(^)(NSArray *list, NSError *error))remote {
    GCBlockInvoke(cache, [self localCouponListWithCommunityId:communityId]);
    [JSONServerProxy postJSONWithUrl:k_API_L_COUPON_LIST_QUERY parameters:@{@"queryCoupon":@{@"PageIndex":page, @"PageSize":pageSize, @"CommunityId":communityId, @"Type":@(type)}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CouponListInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}


- (CouponInfo*)localCouponWithCouponId:(NSNumber*)couponId {
    Coupon *db = (Coupon*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COUPON predicate:[NSPredicate predicateWithFormat:@"couponId=%@", couponId]] firstObject];
    if (db) {
        return [CouponInfo infoWithManagedObj:db];
    }
    return nil;
}
- (void)asyncCouponWithCouponId:(NSNumber*)couponId
                     cacheBlock:(void(^)(CouponInfo *info, NSArray *shopList))cache
                    remoteBlock:(void(^)(CouponInfo *info, NSArray *shopList, NSError *error))remote {
    GCBlockInvoke(cache, [self localCouponWithCouponId:couponId], [self localShopListWithCouponId:couponId]);
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@", k_API_L_COUPON_DETAIL_QUERY,couponId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        
        CouponInfo *retVal = [[CouponInfo alloc] init];
        retVal = [retVal infoWithJSONDic:[responseJSON objectForKey:@"result"]];
        GCBlockInvoke(remote, retVal, [ShopPictureInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"shopPictures"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, nil, error);
    }];
}


- (NSArray*)localShopListWithCouponId:(NSNumber*)couponId {
    NSArray *dbArray = [[MKWModelHandler defaultHandler]queryObjectsForEntity:k_ENTITY_SHOPPICTURE predicate:[NSPredicate predicateWithFormat:@"couponId=%@", couponId]];
    if (dbArray && [dbArray count] > 0) {
        NSMutableArray *retArray = [[NSMutableArray alloc] init];
        for (ShopPicture *db in dbArray) {
            [retArray addObject:[ShopPictureInfo infoWithManagedObj:db]];
        }
        return retArray;
    }
    return nil;
}

- (void)asyncCouponCommentListWithType:(CouponCommentType)type
                              couponId:(NSNumber *)couponId
                                  page:(NSNumber*)page
                              pageSize:(NSNumber*)pageSize
                           remoteBlock:(void(^)(NSArray *list, NSNumber *page, NSError *error))remote {
    NSString *url = @"";
    switch (type) {
        case CommentToShow:
            url = k_API_L_COUPON_COMMENT_QUERY;
            break;
        case CommentToManage:
            url = k_API_L_COUPON_COMMENT_MANAGE;
            break;
        case CommentOfMine:
            url = k_API_L_COUPON_COMMENT_MY;
            break;
        default:
            break;
    }
    if ([MKWStringHelper isNilEmptyOrBlankString:url]) {
        GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:@"类型错训犬" code:-1 userInfo:nil]);
        return;
    }
    
    [JSONServerProxy postJSONWithUrl:url parameters:@{@"pageindex":page,@"pagesize":pageSize,@"couponid":couponId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CouponCommentInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
    
}
//// 优惠券评论添加
//#define k_API_L_COUPON_COMMENT_ADD      @"couponcomment/add"
- (void)asyncCouponCommentAddWithCouponId:(NSNumber *)couponId
                                  content:(NSString *)content
                              remoteBlock:(void(^)(BOOL isSucces, CouponCommentInfo *info, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_COUPON_COMMENT_ADD parameters:@{@"comment":@{@"Content":content,@"CouponId":couponId}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        CouponCommentInfo *info = [[CouponCommentInfo alloc] init];
        GCBlockInvoke(remote, YES, [info infoWithJSONDic:[responseJSON objectForKey:@"result"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, nil, error);
    }];
}
//// 优惠券评论设置显示
//#define k_API_L_COUPON_COMMENT_SHOW     @"couponcomment/show"
- (void)asyncCouponCommentShowWithCommentId:(NSNumber *)commentId
                                remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_COUPON_COMMENT_SHOW parameters:@{@"couponcommentid":commentId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}
//// 优惠券评论设置隐藏
//#define k_API_L_COUPON_COMMENT_HIDE     @"couponcomment/hide"
- (void)asyncCouponCommentHideWithCommentId:(NSNumber *)commentId
                                remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_COUPON_COMMENT_HIDE parameters:@{@"couponcommentid":commentId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}
- (void)asyncCouponCommentDeleteWithId:(NSNumber *)commentId
                           remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_COUPON_COMMENT_DELETE parameters:@{@"couponcommentid":commentId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}
//// 优惠券调查问卷列表
//#define k_API_L_COUPON_JUDGE_QUERY      @"question/getdetail"
//// 优惠券调查问卷添加
//#define k_API_L_COUPON_JUDGE_ADD        @"question/add"
- (void)asyncCouponJudgeAddWithArray:(NSArray *)judgeArray
                         remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_COUPON_JUDGE_ADD parameters:@{@"questions":judgeArray} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}
//// 优惠券调查问卷结果
//#define k_API_L_COUPON_JUDGE_RESULT     @"question/couponstatcount"
- (void)asyncCouponJudgeResultWithCouponId:(NSNumber *)couponId
                               remoteBlock:(void(^)(NSArray *list, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_COUPON_JUDGE_RESULT parameters:@{@"couponId":couponId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CouponJudgeInfo infoArrayWithJSONArray:[responseJSON objectForKey:@"result"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)asyncCouponJudgeSubmitWithArray:(NSArray *)judgePointsArray
                               couponId:(NSNumber *)couponId
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_COUPON_JUDGE_SUBMIT parameters:@{@"logs":judgePointsArray} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
        if ([UserModel sharedModel].isNormalLogined) {
            UserInfo *cUser = [UserModel sharedModel].currentNormalUser;
            UserCouponJudge *judgePoint = (UserCouponJudge*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:@"UserCouponJudge" predicate:[NSPredicate predicateWithFormat:@"userId=%@ AND couponId=%@",cUser.userId, couponId]] firstObject];
            if (!judgePoint) {
                judgePoint = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:@"UserCouponJudge"];
            }
            judgePoint.couponId = couponId;
            judgePoint.userId = cUser.userId;
            judgePoint.hasJudged = @YES;
        }
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}

- (BOOL)hasCouponJudgedWithUserId:(NSNumber *)userId couponId:(NSNumber *)couponId {
    UserCouponJudge *judgePoint = (UserCouponJudge*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:@"UserCouponJudge" predicate:[NSPredicate predicateWithFormat:@"userId=%@ AND couponId=%@",userId, couponId]] firstObject];
    if (!judgePoint) {
        return NO;
    }
    
    return [judgePoint.hasJudged boolValue];
}


#pragma mark - 生活服务
- (LifeServerInfo*)localLifeServerWithCommunityId:(NSNumber *)communityId serverId:(NSNumber *)serverId {
    LifeServer *db = (LifeServer*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_LIFESERVER predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND serverId=%@", communityId, serverId]] firstObject];
    if (db) {
        return [LifeServerInfo infoWithManagedObj:db];
    }
    return nil;
}
- (NSArray*)localLifeServerListWithCommunityId:(NSNumber *)communityId {
    NSArray *dbArray = [[MKWModelHandler defaultHandler]queryObjectsForEntity:k_ENTITY_LIFESERVER predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]];
    if (dbArray && [dbArray count] > 0) {
        NSMutableArray *retArray = [[NSMutableArray alloc] init];
        for (LifeServer *db in dbArray) {
            [retArray addObject:[LifeServerInfo infoWithManagedObj:db]];
        }
        return retArray;
    }
    return nil;
}
- (void)asyncLifeServerListWithCommunityId:(NSNumber *)communityId
                                 pageIndex:(NSNumber *)page
                                  pageSize:(NSNumber *)pageSize
                                cacheBlock:(void(^)(NSArray *list))cache
                               remoteBlock:(void(^)(NSArray *list, NSInteger page, NSError *error))remote {
    GCBlockInvoke(cache, [self localLifeServerListWithCommunityId:communityId]);
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@/%@", k_API_L_SERVICE_LIST_QUERY,communityId,page,pageSize] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [page integerValue], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"]integerValue] userInfo:nil]);
            return;
        }
        
        GCBlockInvoke(remote, [LifeServerInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], [[[responseJSON objectForKey:@"result"] objectForKey:@"CurrentPage"] integerValue], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, -1, error);
    }];
}


#pragma mark - 租售信息
- (void)asyncRentListWithCommunityId:(NSNumber *)communityId
                                type:(RentType)type
                           pageIndex:(NSNumber *)page
                            pageSize:(NSNumber *)pageSize
                          cacheBlock:(void(^)(NSArray *list))cache
                         remoteBlock:(void(^)(NSArray *list, NSInteger page, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@/%@/%@", k_API_L_HOUSE_LIST_QUERY_BY_TYPE, page, pageSize,communityId,@(type)] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [page integerValue], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [RentHouseInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], [[[responseJSON objectForKey:@"result"] objectForKey:@"CurrentPage"] integerValue], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, -1, error);
    }];
}
- (void)asyncRentHouseWithId:(NSNumber *)houseId
                  cacheBlock:(void(^)(RentHouseInfo *info, NSArray *images))cache
                 remoteBlock:(void(^)(RentHouseInfo *info, NSArray *images, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@", k_API_L_HOUSE_DETAIL, houseId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        RentHouseInfo *info = [[RentHouseInfo alloc] init];
        GCBlockInvoke(remote, [info infoWithJSONDic:[responseJSON objectForKey:@"result"]], [HouseImageInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"HouseSaleImages"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, nil, error);
    }];
}

- (void)asyncRentHouseAddWithInfo:(NSDictionary *)infoDic
                      remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_HOUSE_ADD parameters:infoDic success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}
- (void)asyncRentHouseUpdateWithInfo:(NSDictionary *)infoDic
                         remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_HOUSE_MODIFY parameters:@{@"houseSale":infoDic} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [[responseJSON objectForKey:@"isSuc"] boolValue], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}

- (void)asyncInfoListWithCommunityId:(NSNumber *)communityId
                                page:(NSNumber *)page
                            pageSize:(NSNumber *)pageSize
                          cacheBlock:(void(^)(NSArray *infoList))cache
                         remoteBlock:(void(^)(NSArray *infoList, NSNumber *cPage, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_INFO_LIST_QUERY parameters:@{@"pageindex":page, @"pagesize":pageSize, @"communityid":communityId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [PropertyShopInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncWeiListWithCommunityId:(NSNumber *)communityId
                           parentId:(NSNumber *)parentId
                               page:(NSNumber *)page
                           pageSize:(NSNumber *)pageSize
                         cacheBlock:(void(^)(NSArray *commentList))cache
                        remoteBlock:(void(^)(NSArray *commentList, NSNumber *cPage, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_WEI_LIST_QUERY parameters:@{@"pageindex":page, @"pagesize":pageSize, @"communityid":communityId, @"parentid":parentId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        NSArray *commentList = [WeiCommentInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]];
        GCBlockInvoke(remote, commentList, page, nil);
        
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncMyWeiListWithCommunityId:(NSNumber *)communityId
                             parentId:(NSNumber *)parentId
                                 page:(NSNumber *)page
                             pageSize:(NSNumber *)pageSize
                           cacheBlock:(void(^)(NSArray *commentList))cache
                          remoteBlock:(void(^)(NSArray *commentList, NSNumber *cPage, NSError *error))remote{
    [JSONServerProxy postJSONWithUrl:k_API_L_WEI_MY_QUERY parameters:@{@"pageindex":page, @"pagesize":pageSize, @"communityid":communityId, @"parentid":parentId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        NSArray *commentList = [WeiCommentInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]];
        GCBlockInvoke(remote, commentList, page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncWeiAddWithCommuntiyId:(NSNumber *)communityId
                          parentId:(NSNumber *)parentId
                           content:(NSString *)content
                            images:(NSString *)images
                           address:(NSString *)address
                       remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_WEI_ADD parameters:@{@"comment":@{@"Content":content, @"CommunityId":communityId, @"Images":images, @"Address":address, @"ParentId":parentId}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];

}

- (void)asyncWeiUpWithCommentId:(NSNumber *)commentId
                    remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@", k_API_L_WEI_UP, commentId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:-1 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
        WeiCommentAction *action = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_WEICOMMENTACTION predicate:[NSPredicate predicateWithFormat:@"commentId=%@", commentId]] firstObject];
        if (!action) {
            action = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_WEICOMMENTACTION];
        }
        action.isUped = @(YES);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (BOOL)isWeiCommentUpWithCommentId:(NSNumber *)commentId {
    WeiCommentAction *action = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_WEICOMMENTACTION predicate:[NSPredicate predicateWithFormat:@"commentId=%@", commentId]] firstObject];
    if (!action) {
        return NO;
    }
    return [action.isUped boolValue];
}

- (void)asyncWeiUnlikeWithCommentId:(NSNumber *)commentId
                        remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_WEI_UNLIKE parameters:@{@"commentid":commentId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:-1 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}

- (void)asyncWeiReportWithCommentId:(NSNumber *)commentId
                        remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_WEI_REPORT parameters:@{@"commentid":commentId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:-1 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}

- (void)asyncWeiDeleteWithCommentId:(NSNumber *)commentId
                        remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_L_WEI_DELETE parameters:@{@"commentid":commentId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:-1 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}
@end
