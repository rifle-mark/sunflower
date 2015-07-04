//
//  WeiComment.m
//  Sunflower
//
//  Created by makewei on 15/6/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "WeiComment.h"
#import "MKWModelHandler.h"


@implementation WeiComment

@dynamic actionCount;
@dynamic address;
@dynamic adminId;
@dynamic avatar;
@dynamic commentId;
@dynamic communityId;
@dynamic content;
@dynamic createDate;
@dynamic images;
@dynamic nickName;
@dynamic parentId;
@dynamic userId;
@dynamic subCommentCount;

@end

@implementation WeiCommentInfo

- (NSDictionary *)mappingKeys {
    return @{@"ActionCount":@"actionCount",
             @"Address":@"address",
             @"AdminId":@"adminId",
             @"Avatar":@"avatar",
             @"CommentId":@"commentId",
             @"CommunityId":@"communityId",
             @"Content":@"content",
             @"CreateDate":@"createDate",
             @"Images":@"images",
             @"NickName":@"nickName",
             @"ParentId":@"parentId",
             @"UserId":@"userId",
             @"SubCommentCount":@"subCommentCount",};
}

- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}

- (NSManagedObject *)getOrInsertManagedObject {
    WeiComment *obj = (WeiComment*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_WEICOMMENT predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND parentId=%@ AND commentId=%@", self.communityId, self.parentId, self.commentId]] firstObject];
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_WEICOMMENT];
    }
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        WeiCommentInfo * tmp = [[WeiCommentInfo alloc] init];
        [retVal addObject:[tmp infoWithJSONDic:dic]];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    WeiCommentInfo *info = [[WeiCommentInfo alloc] init];
    return [info infoFromManagedObject:obj];
}
@end