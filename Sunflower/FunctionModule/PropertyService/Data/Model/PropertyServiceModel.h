//
//  PropertyServiceModel.h
//  Sunflower
//
//  Created by mark on 15/5/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpendCommunity.h"
#import "CommunityNote.h"
#import "Guanjia.h"
#import "Payment.h"
#import "FixIssue.h"
#import "FixSuggest.h"

typedef NS_ENUM(NSUInteger, PropertyChargeType) {
    ChargeProperty = 1,
    ChargeWarm,
    ChargeClean,
    ChargePark
};

@interface PropertyServiceModel : NSObject

+ (instancetype)sharedModel;

- (OpendCommunityInfo *)localCommunityWithId:(NSNumber *)communityId;
- (void)asyncCommunityWithId:(NSNumber *)communityId cacheBlock:(void(^)(OpendCommunityInfo *community))cache remoteBlock:(void(^)(OpendCommunityInfo *community, NSError *error))remote;


- (CommunityNoteInfo *)localCommunityNoteWithCommunityId:(NSNumber *)communityId noticeId:(NSNumber *)noticeId;
- (NSArray *)localCommunityNoteListWithCommunityId:(NSNumber *)communityId;
- (void)asyncCommunityNoteListWithCommunityId:(NSNumber *)communityId
                                    pageIndex:(NSNumber *)page
                                     pageSize:(NSNumber *)pageSize
                                   cacheBlock:(void(^)(NSArray *list))cache
                                  remoteBlock:(void(^)(NSArray *list, NSNumber *cPage, NSError *error))remote;


- (GuanjiaInfo *)localGuanjiaWithCommunityId:(NSNumber *)communityId guanjiaId:(NSNumber *)guanjiaId;
- (NSArray *)localGuanjiaListWithCommunityId:(NSNumber *)communityId;
- (void)asyncGuanjiaListWithCommunityId:(NSNumber *)communityId
                              pageIndex:(NSNumber *)page
                               pageSize:(NSNumber *)pageSize
                             cacheBlock:(void(^)(NSArray *list, NSNumber *page))cache
                            remoteBlock:(void(^)(NSArray *list, NSNumber *page, NSError *error))remote;
- (void)asyncUpGuanJiaWithGuanjiaId:(NSNumber *)guanjiaId
                        remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncDeleteGuanJiaWithGuanJiaId:(NSNumber *)guanjiaId
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;
- (void)asyncUpdateGuanJiaWithGuanJiaId:(NSNumber *)guanjiaId
                            communityId:(NSNumber *)communityId
                               userName:(NSString *)name
                                    job:(NSString *)job
                                    tel:(NSString *)tel
                                  image:(NSString *)image
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;
- (void)asyncAddGuanJiaWithCommunityId:(NSNumber *)communityId
                              userName:(NSString *)name
                                   job:(NSString *)job
                                   tel:(NSString *)tel
                                 image:(NSString *)image
                           remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)asyncUpdateCommunityInfoWithCommunityID:(NSNumber *)communityId
                                           name:(NSString *)name
                                         detail:(NSString *)desc
                                          image:(NSString *)imgurl
                                            tel:(NSString *)tel
                                    remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncUpdateNoteInfoWithNoteId:(NSNumber *)noteId
                          communityId:(NSNumber *)communityId
                                title:(NSString *)title
                               detail:(NSString *)detail
                                image:(NSString *)imgurl
                          remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncAddNoteInfoWithCommunityId:(NSNumber *)communityId
                                  title:(NSString *)title
                                 detail:(NSString *)detail
                                  image:(NSString *)imgurl
                            remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncDeleteNoteInfoWithNoteId:(NSNumber *)noteId
                          remoteBlock:(void(^)(BOOL isSuccess, NSString *msg, NSError *error))remote;

- (void)asyncPropertyChargeListWithType:(PropertyChargeType)type
                                 isPayd:(BOOL)isPayd
                            remoteBlock:(void(^)(NSArray *chargeList, NSError *error))remote;

- (void)asyncAddFixIssueWithCommunityId:(NSNumber *)communityId
                                   type:(NSNumber *)type
                                   name:(NSString *)name
                                    tel:(NSString *)tel
                                    add:(NSString *)add
                                content:(NSString *)content
                                 images:(NSString *)images
                            remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)asyncFixIssueQueryWithCommunityId:(NSNumber *)communityId
                                isDeleted:(NSNumber *)isdeleted
                                     page:(NSNumber *)page
                                 pageSize:(NSNumber *)pageSize
                               cacheBlock:(void(^)(NSArray *issueList, NSNumber *page))cache
                              remoteBlock:(void(^)(NSArray *issueList, NSNumber *page, NSError *error))remote;

- (void)asyncFixSuggestQueryWithCommunityId:(NSNumber *)communityId
                                       page:(NSNumber *)page
                                   pageSize:(NSNumber *)pageSize
                                 cacheBlock:(void(^)(NSArray *seggestList, NSNumber *page))cache
                                remoteBlock:(void(^)(NSArray *seggestList, NSNumber *page, NSError *error))remote;

- (BOOL)isNoteReadWithId:(NSNumber *)noteId;

- (void)asyncPaymentOrderNumberWithInfo:(NSArray *)payInfo
                            remoteBlock:(void(^)(NSString *orderNum, NSError *error))remote;

- (void)asyncFixIssueDoneWithIssueId:(NSNumber *)issueId
                         remoteBlock:(void(^)(BOOL isSuccess, NSError *error))remote;

- (void)asyncNoteDetailWithNoteId:(NSNumber *)noteId
                      remoteblock:(void(^)(CommunityNoteInfo *note, NSError *error))remote;
@end
