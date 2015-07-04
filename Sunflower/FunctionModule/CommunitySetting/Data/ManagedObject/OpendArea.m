//
//  OpendArea.m
//  Sunflower
//
//  Created by mark on 15/4/28.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "OpendArea.h"
#import "MKWModelHandler.h"


@implementation OpendArea

@dynamic orderId;
@dynamic area;
@dynamic areaId;
@dynamic cityId;

@end


@implementation OpendAreaInfo

-(NSDictionary *)mappingKeys {
    return @{@"area":@"area",
             @"areaid":@"areaId",
             @"cityid":@"cityId",
             @"id":@"orderId",};
}

-(NSManagedObject *)getOrInsertManagedObject {
    OpendArea *area = (OpendArea*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_OPENDAREA predicate:[NSPredicate predicateWithFormat:@"areaId=%@", self.areaId]] firstObject];
    if (!area) {
        area = (OpendArea*)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_OPENDAREA];
    }
    return area;
}

+(NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        OpendAreaInfo *info = [[OpendAreaInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    OpendAreaInfo *retVal = [[OpendAreaInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}

@end