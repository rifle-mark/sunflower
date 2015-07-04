//
//  Coupon.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "Coupon.h"
#import "MKWModelHandler.h"
#import "NSDictionary+MKWJson.h"


@implementation Coupon

@dynamic couponId;
@dynamic startDate;
@dynamic endDate;
@dynamic image;
@dynamic communityId;
@dynamic couponDesc;
@dynamic logo;
@dynamic name;
@dynamic subTitle;
@dynamic type;
@dynamic useCount;

@end

@implementation CouponInfo

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
             @"CommunityId":@"communityId",
             @"Description":@"couponDesc",
             };
}
- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}
- (NSManagedObject *)getOrInsertManagedObject {
    Coupon *obj = (Coupon*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COUPON predicate:[NSPredicate predicateWithFormat:@"couponId=%@",self.couponId]] firstObject];
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        CouponInfo *info = [[CouponInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject*)obj {
    CouponInfo *retVal = [[CouponInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}


@end