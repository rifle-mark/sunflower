//
//  ShopPicture.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopPicture.h"
#import "MKWModelHandler.h"


@implementation ShopPicture

@dynamic shopId;
@dynamic adminId;
@dynamic name;
@dynamic address;
@dynamic tel;
@dynamic image;

@end


@implementation ShopPictureInfo

- (NSDictionary *)mappingKeys {
    return @{
             @"ShopId":@"shopId",
             @"Name":@"name",
             @"Address":@"address",
             @"Tel":@"tel",
             @"AdminId":@"adminId",
             @"Image":@"image",
             };
}
- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return dic;
}
- (NSManagedObject *)getOrInsertManagedObject {
    ShopPicture *obj = (ShopPicture*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_SHOPPICTURE predicate:[NSPredicate predicateWithFormat:@"shopId=%@", self.shopId]] firstObject];
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        ShopPictureInfo *info = [[ShopPictureInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject*)obj {
    ShopPictureInfo *retVal = [[ShopPictureInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}


@end