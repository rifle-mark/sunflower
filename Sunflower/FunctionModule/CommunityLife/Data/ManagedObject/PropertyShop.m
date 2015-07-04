//
//  PropertyShop.m
//  Sunflower
//
//  Created by makewei on 15/6/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyShop.h"

#import "MKWModelHandler.h"


@implementation PropertyShop

@dynamic adminId;
@dynamic communityId;
@dynamic logo;
@dynamic name;
@dynamic shopInfoId;
@dynamic summary;
@dynamic tel;
@dynamic userId;

@end


@implementation PropertyShopInfo

- (NSDictionary *)mappingKeys {
    return @{@"AdminId":@"adminId",
             @"CommunityId":@"communityId",
             @"Logo":@"logo",
             @"Name":@"name",
             @"ShopInfoId":@"shopInfoId",
             @"Summary":@"summary",
             @"Tel":@"tel",
             @"UserId":@"userId",};
}

- (NSManagedObject *)getOrInsertManagedObject {
    PropertyShop *obj = (PropertyShop*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_PROPERTYSHOP predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND shopInfoId=%@", self.communityId, self.shopInfoId]] firstObject];
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_PROPERTYSHOP];
    }
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        PropertyShopInfo * tmp = [[PropertyShopInfo alloc] init];
        [retVal addObject:[tmp infoWithJSONDic:dic]];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    PropertyShopInfo *info = [[PropertyShopInfo alloc] init];
    return [info infoFromManagedObject:obj];
}
@end