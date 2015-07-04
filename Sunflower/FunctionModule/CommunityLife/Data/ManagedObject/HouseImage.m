//
//  HouseImage.m
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "HouseImage.h"
#import "MKWModelHandler.h"


@implementation HouseImage

@dynamic houseId;
@dynamic imageId;
@dynamic image;
@dynamic remark;

@end

@implementation HouseImageInfo

-(NSDictionary *)mappingKeys {
    return @{
             @"HouseSaleId":@"houseId",
             @"Id":@"imageId",
             @"Image":@"image",
             @"Remark":@"remark",
             };
}

-(NSManagedObject *)getOrInsertManagedObject {
    HouseImage *retVal = (HouseImage*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_HOUSEIMAGE predicate:[NSPredicate predicateWithFormat:@"houseId=%@ AND imageId=%@", self.houseId, self.imageId]] firstObject];
    if (!retVal) {
        retVal = (HouseImage*)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_HOUSEIMAGE];
    }
    return retVal;
}

+(NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        HouseImageInfo *tmp = [[HouseImageInfo alloc] init];
        [retArray addObject:[tmp infoWithJSONDic:dic]];
    }
    return retArray;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    HouseImageInfo *retVal = [[HouseImageInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}
@end
