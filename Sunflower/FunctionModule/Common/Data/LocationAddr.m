//
//  LocationAddr.m
//  Sunflower
//
//  Created by makewei on 15/6/7.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "LocationAddr.h"
#import "MKWModelHandler.h"

@implementation LocationAddr

@dynamic addr;
@dynamic cp;
@dynamic direction;
@dynamic distance;
@dynamic name;
@dynamic poiType;
@dynamic pointX;
@dynamic pointY;
@dynamic tel;
@dynamic uid;
@dynamic zip;

@end

@implementation LocationAddrInfo

- (NSDictionary *)mappingKeys {
    return @{};
}

- (NSManagedObject *)getOrInsertManagedObject {
    LocationAddr *obj = (LocationAddr*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_LOCATIONADDR predicate:[NSPredicate predicateWithFormat:@"uid=%@", self.uid]] firstObject];
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_LOCATIONADDR];
    }
    return obj;
}

- (instancetype)infoWithJSONDic:(NSDictionary *)dic {
    [super infoWithJSONDic:dic];
    
    self.pointX = [[dic objectForKey:@"point"] objectForKey:@"x"];
    self.pointY = [[dic objectForKey:@"point"] objectForKey:@"y"];
    
    return self;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        LocationAddrInfo *info = [[LocationAddrInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    LocationAddrInfo *info = [[LocationAddrInfo alloc] init];
    return [info infoFromManagedObject:obj];
}
@end