//
//  RentHouse.m
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "RentHouse.h"
#import "NSDictionary+MKWJson.h"
#import "MKWModelHandler.h"

@implementation RentHouse

@dynamic adminAvatar;
@dynamic adminId;
@dynamic area;
@dynamic checkIn;
@dynamic city;
@dynamic communityId;
@dynamic crateDate;
@dynamic district;
@dynamic endPrice;
@dynamic fix;
@dynamic floor;
@dynamic hall;
@dynamic houseId;
@dynamic image;
@dynamic orientation;
@dynamic price;
@dynamic privince;
@dynamic rentDesc;
@dynamic room;
@dynamic title;
@dynamic toilet;
@dynamic type;
@dynamic userAvatar;
@dynamic userId;
@dynamic userName;
@dynamic userPhone;

@end

@implementation RentHouseInfo

- (NSDictionary *)mappingKeys {
    return @{
             @"AdminId":@"adminId",
             @"Area":@"area",
             @"CheckIn":@"checkIn",
             @"City":@"city",
             @"CommunityId":@"communityId",
             @"CreateDate":@"crateDate",
             @"District":@"district",
             @"EndPrice":@"endPrice",
             @"Fix":@"fix",
             @"Floor":@"floor",
             @"Hall":@"hall",
             @"HouseId":@"houseId",
             @"Image":@"image",
             @"Orientation":@"orientation",
             @"Price":@"price",
             @"Province":@"privince",
             @"Description":@"rentDesc",
             @"Room":@"room",
             @"Title":@"title",
             @"Toilet":@"toilet",
             @"Type":@"type",
             @"UserId":@"userId",
             @"UserName":@"userName",
             @"UserPhone":@"userPhone",
             @"AdminAvatar":@"adminAvatar",
             @"UserAvatar":@"userAvatar",
             };
}

-(NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}

- (NSManagedObject *)getOrInsertManagedObject {
    RentHouse *retVal = (RentHouse*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_RENTHOUSE predicate:[NSPredicate predicateWithFormat:@"houseId=%@", self.houseId]] firstObject];
    if (!retVal) {
        retVal = (RentHouse*)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_RENTHOUSE];
    }
    return retVal;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        RentHouseInfo * tmp = [[RentHouseInfo alloc] init];
        [retVal addObject:[tmp infoWithJSONDic:dic]];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject*)obj {
    if (obj) {
        RentHouseInfo *retVal = [[RentHouseInfo alloc] init];
        return [retVal infoFromManagedObject:obj];
    }
    return nil;
}

@end
