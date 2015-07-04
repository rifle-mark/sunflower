//
//  ShopStore.m
//  Sunflower
//
//  Created by makewei on 15/5/20.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopStore.h"
#import "MKWModelHandler.h"

@implementation ShopStore

@dynamic address;
@dynamic adminId;
@dynamic image;
@dynamic name;
@dynamic shopId;
@dynamic tel;

@end


@implementation ShopStoreInfo

-(NSDictionary *)mappingKeys {
    return @{@"Address":@"address",
             @"AdminId":@"adminId",
             @"Image":@"image",
             @"Name":@"name",
             @"ShopId":@"shopId",
             @"Tel":@"tel",};
}

-(NSManagedObject *)getOrInsertManagedObject {
    ShopStore *shopStore = (ShopStore *)[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_SHOPSTORE predicate:[NSPredicate predicateWithFormat:@"ShopId=%@", self.shopId]];
    if (!shopStore) {
        shopStore = (ShopStore *)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_SHOPSTORE];
    }
    return shopStore;
}

+(NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        ShopStoreInfo *info = [[ShopStoreInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    ShopStoreInfo *shop = [[ShopStoreInfo alloc] init];
    return [shop infoFromManagedObject:obj];
}

@end