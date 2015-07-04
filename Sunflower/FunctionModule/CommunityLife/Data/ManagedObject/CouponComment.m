//
//  CouponComment.m
//  Sunflower
//
//  Created by makewei on 15/6/20.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CouponComment.h"

#import "MKWModelHandler.h"

@implementation CouponComment

@dynamic avatar;
@dynamic content;
@dynamic couponCommentId;
@dynamic couponId;
@dynamic createDate;
@dynamic isCommentDeleted;
@dynamic nickName;
@dynamic userId;

@end


@implementation CouponCommentInfo

- (NSDictionary *)mappingKeys {
    return @{@"Avatar":@"avatar",
             @"Content":@"content",
             @"CouponCommentId":@"couponCommentId",
             @"CouponId":@"couponId",
             @"CreateDate":@"createDate",
             @"IsDeleted":@"isCommentDeleted",
             @"NickName":@"nickName",
             @"UserId":@"userId",};
}

- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}

- (NSManagedObject *)getOrInsertManagedObject {
    CouponComment *obj = (CouponComment*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COUPONCOMMENT predicate:[NSPredicate predicateWithFormat:@"couponCommentId = %@", self.couponCommentId]] firstObject];
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_COUPONCOMMENT];
    }
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        CouponCommentInfo * tmp = [[CouponCommentInfo alloc] init];
        [retVal addObject:[tmp infoWithJSONDic:dic]];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    CouponCommentInfo *info = [[CouponCommentInfo alloc] init];
    return [info infoFromManagedObject:obj];
}

@end