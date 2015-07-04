//
//  PointRuler.m
//  Sunflower
//
//  Created by makewei on 15/7/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PointRuler.h"
#import "MKWModelHandler.h"


@implementation PointRuler

@dynamic rulerId;
@dynamic points;
@dynamic title;
@dynamic type;

@end

@implementation PointRulerInfo

-(NSDictionary *)mappingKeys {
    return @{@"Id":@"rulerId",
             @"Points":@"points",
             @"Title":@"title",
             @"Type":@"type",};
}

-(NSManagedObject *)getOrInsertManagedObject {
    PointRuler *ruler = (PointRuler *)[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_POINTRULER predicate:[NSPredicate predicateWithFormat:@"rulerId=%@", self.rulerId]];
    if (!ruler) {
        ruler = (PointRuler *)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_POINTRULER];
    }
    return ruler;
}

+(NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        PointRulerInfo *info = [[PointRulerInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    PointRulerInfo *ruler = [[PointRulerInfo alloc] init];
    return [ruler infoFromManagedObject:obj];
}
@end
