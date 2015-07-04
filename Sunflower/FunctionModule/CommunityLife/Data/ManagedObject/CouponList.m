//
//  CouponList.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CouponList.h"
#import "MKWModelHandler.h"

#import "NSDictionary+MKWJson.h"


@implementation CouponList

@dynamic couponId;
@dynamic startDate;
@dynamic endDate;
@dynamic image;
@dynamic logo;
@dynamic name;
@dynamic subTitle;
@dynamic useCount;
@dynamic hasUseCount;
@dynamic state;

@end


@implementation CouponListInfo

- (NSDictionary *)mappingKeys {
    return @{
             @"Id":@"couponId",
             @"StartDate":@"startDate",
             @"EndDate":@"endDate",
             @"Image":@"image",
             @"Logo":@"logo",
             @"Name":@"name",
             @"SubTitle":@"subTitle",
             @"UseCount":@"useCount",
             @"HasUseCount":@"hasUseCount",
             @"State":@"state",
             };
}
- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}
- (NSManagedObject *)getOrInsertManagedObject {
    CouponList *obj = (CouponList*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COUPONLIST predicate:[NSPredicate predicateWithFormat:@"couponId=%@",self.couponId]] firstObject];
    if (!obj) {
        obj = (CouponList*)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_COUPONLIST];
    }
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        CouponListInfo *info = [[CouponListInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject*)obj {
    CouponListInfo *retVal = [[CouponListInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}


@end