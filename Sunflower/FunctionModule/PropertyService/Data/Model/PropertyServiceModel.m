//
//  PropertyServiceModel.m
//  Sunflower
//
//  Created by mark on 15/5/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyServiceModel.h"
#import "MKWModelHandler.h"
#import "GCExtension.h"
#import "ServerProxy.h"

@implementation PropertyServiceModel

+ (instancetype)sharedModel {
    static PropertyServiceModel *retVal = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        retVal = [[PropertyServiceModel alloc] init];
    });
    return retVal;
}

#pragma mark - OpendCommunityInfo
- (OpendCommunityInfo *)localCommunityWithId:(NSNumber *)communityId {
    return [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_OPENDCOMMUNITY predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]] firstObject];
}
- (void)asyncCommunityWithId:(NSNumber *)communityId cacheBlock:(void(^)(OpendCommunityInfo *community))cache remoteBlock:(void(^)(OpendCommunityInfo *community, NSError *error))remote {
    GCBlockInvoke(cache, [self localCommunityWithId:communityId]);
    
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@", k_API_COMMUNITY_QUERY_BY_ID, communityId] params:nil success:^(NSDictionary *responseJSON) {
        GCBlockInvoke(remote, [OpendCommunityInfo opendCommunityWithJSONDic:[responseJSON objectForKey:@"result"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

#pragma mark - CommunityNoteInfo
- (CommunityNoteInfo *)localCommunityNoteWithCommunityId:(NSNumber *)communityId noticeId:(NSNumber *)noticeId {
    CommunityNote *note = (CommunityNote*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYNOTE predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND noticeId=%@", communityId, noticeId]] firstObject];
    
    CommunityNoteInfo *retVal = [[CommunityNoteInfo alloc] init];
    return [retVal infoFromManagedObject:note];
}

- (NSArray *)localCommunityNoteListWithCommunityId:(NSNumber *)communityId {
    NSArray *dbList = [[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYNOTE predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]];
    NSMutableArray *retArray = [[NSMutableArray alloc] initWithCapacity:[dbList count]];
    for (CommunityNote *note in dbList) {
        CommunityNoteInfo *retVal = [[CommunityNoteInfo alloc] init];
        [retArray addObject:[retVal infoFromManagedObject:note]];
    }
    return retArray;
}

- (void)asyncCommunityNoteListWithCommunityId:(NSNumber *)communityId
                                    pageIndex:(NSNumber *)page
                                     pageSize:(NSNumber *)pageSize
                                   cacheBlock:(void (^)(NSArray *))cache
                                  remoteBlock:(void (^)(NSArray *, NSNumber *cPage, NSError *))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@/%@", k_API_C_NOTE_QUERY_BY_ID, page, pageSize, communityId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [CommunityNoteInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

#pragma mark - GuanjiaInfo
- (GuanjiaInfo *)localGuanjiaWithCommunityId:(NSNumber *)communityId guanjiaId:(NSNumber *)guanjiaId {
    Guanjia *guanjia = (Guanjia*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_GUANJIA predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND guanjiaId=%@", communityId, guanjiaId]] firstObject];
    if (guanjiaId) {
        return [GuanjiaInfo infoWithManagedObj:guanjia];
    }
    return nil;
}
- (NSArray *)localGuanjiaListWithCommunityId:(NSNumber *)communityId {
    NSArray *dbList = [[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_GUANJIA predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]];
    NSMutableArray *retArray = [[NSMutableArray alloc] initWithCapacity:[dbList count]];
    for (Guanjia *guanjia in dbList) {
        [retArray addObject:[GuanjiaInfo infoWithManagedObj:guanjia]];
    }
    return retArray;
}
- (void)asyncGuanjiaListWithCommunityId:(NSNumber *)communityId
                              pageIndex:(NSNumber *)page
                               pageSize:(NSNumber *)pageSize
                             cacheBlock:(void(^)(NSArray *list, NSNumber *page))cache
                            remoteBlock:(void(^)(NSArray *list, NSNumber *page, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@/%@/%@", k_API_C_GUANJIA_QUERY_BY_ID, page, pageSize, communityId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [GuanjiaInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}
- (void)asyncUpGuanJiaWithGuanjiaId:(NSNumber *)guanjiaId
                        remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@",k_API_C_GUANJIA_UP_BY_ID, guanjiaId] params:nil success:^(NSDictionary *responseJSON) {
        GCBlockInvoke(remote, [[responseJSON objectForKey:@"isSuc"] boolValue], [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, @"操作失败", error);
    }];
}

- (void)asyncDeleteGuanJiaWithGuanJiaId:(NSNumber *)guanjiaId
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@", k_API_C_GUANJIA_DELETE, guanjiaId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}
- (void)asyncUpdateGuanJiaWithGuanJiaId:(NSNumber *)guanjiaId
                            communityId:(NSNumber *)communityId
                               userName:(NSString *)name
                                    job:(NSString *)job
                                    tel:(NSString *)tel
                                  image:(NSString *)image
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_GUANJIA_UPDATE parameters:@{@"houseKeeper":@{@"Id":guanjiaId,@"CommunityId":communityId,@"UserName":name,@"Job":job,@"Tel":tel,@"Image":image}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}
- (void)asyncAddGuanJiaWithCommunityId:(NSNumber *)communityId
                              userName:(NSString *)name
                                   job:(NSString *)job
                                   tel:(NSString *)tel
                                 image:(NSString *)image
                           remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_GUANJIA_ADD parameters:@{@"houseKeeper":@{@"CommunityId":communityId,@"UserName":name,@"Job":job,@"Tel":tel,@"Image":image}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}


- (void)asyncUpdateCommunityInfoWithCommunityID:(NSNumber *)communityId
                                           name:(NSString *)name
                                         detail:(NSString *)desc
                                          image:(NSString *)imgurl
                                            tel:(NSString *)tel
                                    remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_COMMUNITY_INFO_UPDATE parameters:@{@"community":@{@"CommunityId":communityId, @"Images":imgurl, @"Description":desc, @"Tel":tel, @"Name":name}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [[NSError alloc] initWithDomain:[responseJSON objectForKey:@"message"] code:1008030 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}


- (void)asyncUpdateNoteInfoWithNoteId:(NSNumber *)noteId
                          communityId:(NSNumber *)communityId
                                title:(NSString *)title
                               detail:(NSString *)detail
                                image:(NSString *)imgurl
                          remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_NOTE_UPDATE parameters:@{@"notice":@{@"NoticeId":noteId,@"CommunityId":communityId, @"Image":imgurl, @"Content":detail, @"Title":title}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [[NSError alloc] initWithDomain:[responseJSON objectForKey:@"message"] code:1008030 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncAddNoteInfoWithCommunityId:(NSNumber *)communityId
                                  title:(NSString *)title
                                 detail:(NSString *)detail
                                  image:(NSString *)imgurl
                            remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_NOTE_ADD parameters:@{@"notice":@{@"CommunityId":communityId, @"Image":imgurl, @"Content":detail, @"Title":title}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [[NSError alloc] initWithDomain:[responseJSON objectForKey:@"message"] code:1008030 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncDeleteNoteInfoWithNoteId:(NSNumber *)noteId
                          remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@",k_API_C_NOTE_DELETE,noteId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [responseJSON objectForKey:@"message"], [[NSError alloc] initWithDomain:[responseJSON objectForKey:@"message"] code:1008030 userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, [responseJSON objectForKey:@"message"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error.domain, error);
    }];
}

- (void)asyncPropertyChargeListWithType:(PropertyChargeType)type
                                 isPayd:(BOOL)isPayd
                            remoteBlock:(void(^)(NSArray *chargeList, NSError *error))remote {
    NSString *url = nil;
    switch (type) {
        case ChargePark:
            url = isPayd?k_API_C_CHARGE_PARK_HASPAY_QUERY:k_API_C_CHARGE_PARK_NOTPAY_QUERY;
            break;
        case ChargeClean:
            url = isPayd?k_API_C_CHARGE_CLEAN_HASPAY_QUERY:k_API_C_CHARGE_CLEAN_NOTPAY_QUERY;
            break;
        case ChargeWarm:
            url = isPayd?k_API_C_CHARGE_WARM_HASPAY_QUERY:k_API_C_CHARGE_WARM_NOTPAY_QUERY;
            break;
        case ChargeProperty:
            url = isPayd?k_API_C_CHARGE_PROPERTY_HASPAY_QUERY:k_API_C_CHARGE_PROPERTY_NOTPAY_QUERY;
            break;
        default:
            break;
    }
    if (!url) {
        GCBlockInvoke(remote, nil, [NSError errorWithDomain:@"参数不正确" code:-1 userInfo:nil]);
        return;
    }
    
    [JSONServerProxy getWithUrl:url params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [[NSError alloc] initWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [PaymentInfo infoArrayWithJSONArray:[responseJSON objectForKey:@"result"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)asyncAddFixIssueWithCommunityId:(NSNumber *)communityId
                                   type:(NSNumber *)type
                                   name:(NSString *)name
                                    tel:(NSString *)tel
                                    add:(NSString *)add
                                content:(NSString *)content
                                 images:(NSString *)images
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_FIX_ISSUE_ADD parameters:@{@"feedback":@{@"UserName":name, @"UserPhone":tel,@"Content":content,@"Images":images,@"CommunityId":communityId,@"Type":type,@"Address":add}} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}

- (void)asyncFixIssueQueryWithCommunityId:(NSNumber *)communityId
                                isDeleted:(NSNumber *)isdeleted
                                     page:(NSNumber *)page
                                 pageSize:(NSNumber *)pageSize
                               cacheBlock:(void(^)(NSArray *issueList, NSNumber *page))cache
                              remoteBlock:(void(^)(NSArray *issueList, NSNumber *page, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_FIX_ISSUE_QUERY parameters:@{@"pageindex":page, @"pagesize":pageSize,@"communityid":communityId, @"isdeleted":isdeleted} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [FixIssueInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (void)asyncFixSuggestQueryWithCommunityId:(NSNumber *)communityId
                                       page:(NSNumber *)page
                                   pageSize:(NSNumber *)pageSize
                                 cacheBlock:(void(^)(NSArray *seggestList, NSNumber *page))cache
                                remoteBlock:(void(^)(NSArray *seggestList, NSNumber *page, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_FIX_SUGGEST_QUERY parameters:@{@"pageindex":page, @"pagesize":pageSize, @"communityid":communityId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, page, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, [FixSuggestInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"Items"]], page, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, page, error);
    }];
}

- (BOOL)isNoteReadWithId:(NSNumber *)noteId {
    CommunityNote *obj = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYNOTE predicate:[NSPredicate predicateWithFormat:@"noticeId=%@", noteId]] firstObject];
    if (!obj) {
        return NO;
    }
    return [obj.isRead boolValue];
}

- (void)asyncPaymentOrderNumberWithInfo:(NSArray *)payInfo
                            remoteBlock:(void(^)(NSString *orderNum, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_CHARGE_ORDER_CREATE parameters:@{@"orderDetail":payInfo} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, (NSString*)[responseJSON objectForKey:@"result"], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}

- (void)asyncFixIssueDoneWithIssueId:(NSNumber *)issueId
                         remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote {
    [JSONServerProxy postJSONWithUrl:k_API_C_FIX_ISSUE_DONE parameters:@{@"id":issueId} success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, NO, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        GCBlockInvoke(remote, YES, nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, NO, error);
    }];
}


- (void)asyncNoteDetailWithNoteId:(NSNumber *)noteId
                      remoteblock:(void(^)(CommunityNoteInfo *note, NSError *error))remote {
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@", k_API_C_NOTE_DETAIL, noteId] params:nil success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            return;
        }
        CommunityNoteInfo *info = [[CommunityNoteInfo alloc] init];
        GCBlockInvoke(remote, [info infoWithJSONDic:[responseJSON objectForKey:@"result"]], nil);
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, error);
    }];
}
@end
