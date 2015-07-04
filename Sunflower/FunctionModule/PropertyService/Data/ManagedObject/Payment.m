//
//  Payment.m
//  Sunflower
//
//  Created by makewei on 15/6/11.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "Payment.h"

#import "MKWModelHandler.h"

@implementation Payment

@dynamic chargeId;
@dynamic chargeDate;
@dynamic chargePrice;
@dynamic createDate;
@dynamic phoneNum;
@dynamic state;
@dynamic chargeType;
@dynamic type;

@end

@implementation PaymentInfo

- (NSDictionary *)mappingKeys {
    return @{@"ChargeId":@"chargeId",
             @"ChargeDate":@"chargeDate",
             @"ChargePrice":@"chargePrice",
             @"CreateDate":@"createDate",
             @"PhoneNum":@"phoneNum",
             @"State":@"state",
             @"ChargeType":@"chargeType",
             @"Type":@"type",};
}

- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}

- (NSManagedObject *)getOrInsertManagedObject {
    Payment *obj = (Payment*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_PAYMENT predicate:[NSPredicate predicateWithFormat:@"chargeId=%@", self.chargeId]] firstObject];
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_PAYMENT];
    }
    
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        PaymentInfo *info = [[PaymentInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    PaymentInfo *info = [[PaymentInfo alloc] init];
    return [info infoFromManagedObject:obj];
}
@end