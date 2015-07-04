//
//  OpendCity.m
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "OpendCity.h"
#import "MKWModelHandler.h"

@implementation OpendCity

@dynamic city;
@dynamic cityId;
@dynamic province;

@end

@implementation OpendCityInfo

-(NSDictionary *)mappingKeys {
    return @{
             @"City":@"city",
             @"Id":@"cityId",
             @"Province":@"province",
             };
}

- (NSManagedObject *)getOrInsertManagedObject {
    OpendCity *obj = (OpendCity*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_OPENDCITY predicate:[NSPredicate predicateWithFormat:@"city=%@",self.city]] firstObject];
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        OpendCityInfo *info = [[OpendCityInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject*)obj {
    OpendCityInfo *retVal = [[OpendCityInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}
@end