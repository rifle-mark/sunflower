//
//  Shop.m
//  Sunflower
//
//  Created by makewei on 15/5/20.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "Shop.h"

#import "MKWModelHandler.h"


@implementation Shop

@dynamic address;
@dynamic adminId;
@dynamic logo;
@dynamic name;
@dynamic sellerId;
@dynamic tel;
@dynamic shopDesc;

@end


@implementation ShopInfo

-(NSDictionary *)mappingKeys {
    return @{@"Address":@"address",
             @"AdminId":@"adminId",
             @"Logo":@"logo",
             @"Name":@"name",
             @"SellerId":@"sellerId",
             @"Tel":@"tel",
             @"Description":@"shopDesc",};
}

-(NSManagedObject *)getOrInsertManagedObject {
    Shop *shop = (Shop *)[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_SHOP predicate:[NSPredicate predicateWithFormat:@"sellerId=%@", self.sellerId]];
    if (!shop) {
        shop = (Shop *)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_SHOP];
    }
    return shop;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    ShopInfo *shop = [[ShopInfo alloc] init];
    return [shop infoFromManagedObject:obj];
}
@end
