//
//  UserPoint.m
//  Sunflower
//
//  Created by makewei on 15/6/18.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "UserPoint.h"

#import "MKWModelHandler.h"


@implementation UserPoint

@dynamic createDate;
@dynamic experience;
@dynamic pointId;
@dynamic type;
@dynamic points;
@dynamic userId;

@end

@implementation UserPointInfo

- (NSDictionary *)mappingKeys {
    return @{@"CreateDate":@"createDate",
             @"Experience":@"experience",
             @"Id":@"pointId",
             @"Points":@"points",
             @"Type":@"type",
             @"UserId":@"userId",
             };
}

- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}

- (NSManagedObject *)getOrInsertManagedObject {
    UserPoint *obj = (UserPoint*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_USERPOINT predicate:[NSPredicate predicateWithFormat:@"pointId=%@", self.pointId]] firstObject];
    
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_USERPOINT];
    }
    
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        UserPointInfo *info = [[UserPointInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    UserPointInfo *info = [[UserPointInfo alloc] init];
    
    return [info infoFromManagedObject:obj];
}

@end
