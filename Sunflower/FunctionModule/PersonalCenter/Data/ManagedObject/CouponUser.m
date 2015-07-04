//
//  CouponUser.m
//  Sunflower
//
//  Created by makewei on 15/5/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CouponUser.h"
#import "MKWModelHandler.h"


@implementation CouponUser

@dynamic avatar;
@dynamic couponId;
@dynamic couponName;
@dynamic couponNum;
@dynamic endDate;
@dynamic orderId;
@dynamic beDeleted;
@dynamic beUsed;
@dynamic nickName;
@dynamic userId;
@dynamic userName;

@end

@implementation CouponUserInfo

-(NSDictionary *)mappingKeys {
    return @{@"Avatar":@"avatar",
             @"CouponId":@"couponId",
             @"CouponName":@"couponName",
             @"EndDate":@"endDate",
             @"Id":@"orderId",
             @"IsDeleted":@"beDeleted",
             @"IsUse":@"beUsed",
             @"NickName":@"nickName",
             @"UserId":@"userId",
             @"UserName":@"userName",
             @"CouponNum":@"couponNum",};
}

-(NSManagedObject *)getOrInsertManagedObject {
    CouponUser *cuser = (CouponUser*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COUPONUSER predicate:[NSPredicate predicateWithFormat:@"couponId=%@ AND orderId=%@",self.couponId, self.orderId]] lastObject];
    if (!cuser) {
        cuser = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_COUPONUSER];
    }
    
    return cuser;
}

-(NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}

+(NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        CouponUserInfo *info = [[CouponUserInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    CouponUserInfo *user = [[CouponUserInfo alloc] init];
    return [user infoFromManagedObject:obj];
}
@end