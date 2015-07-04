//
//  CouponJudge.m
//  Sunflower
//
//  Created by makewei on 15/6/20.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CouponJudge.h"
#import "MKWModelHandler.h"

@implementation CouponJudge

@dynamic couponId;
@dynamic questionId;
@dynamic title;
@dynamic five;
@dynamic four;
@dynamic three;
@dynamic two;
@dynamic one;
@dynamic zero;

@end

@implementation CouponJudgeInfo

- (NSDictionary *)mappingKeys {
    return @{@"CouponId":@"couponId",
             @"QuestionId":@"questionId",
             @"Title":@"title",
             @"Five":@"five",
             @"Four":@"four",
             @"Three":@"three",
             @"Two":@"two",
             @"One":@"one",
             @"Zero":@"zero"};
}

- (NSManagedObject *)getOrInsertManagedObject {
    CouponJudge *obj = (CouponJudge*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COUPONJUDGE predicate:[NSPredicate predicateWithFormat:@"questionId=%@", self.questionId]] firstObject];
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_COUPONJUDGE];
    }
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        CouponJudgeInfo * tmp = [[CouponJudgeInfo alloc] init];
        [retVal addObject:[tmp infoWithJSONDic:dic]];
    }
    return retVal;
}
+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    CouponJudgeInfo *info = [[CouponJudgeInfo alloc] init];
    return [info infoFromManagedObject:obj];
}
@end