//
//  CommunityBuild.m
//  Sunflower
//
//  Created by makewei on 15/5/31.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CommunityBuild.h"
#import "MKWModelHandler.h"


@implementation CommunityBuild

@dynamic build;
@dynamic buildingId;
@dynamic communityId;
@dynamic floors;
@dynamic houses;
@dynamic units;

@end


@implementation CommunityBuildInfo

- (NSDictionary *)mappingKeys {
    return @{@"":@"build",
             @"":@"buildingId",
             @"":@"communityId",
             @"":@"floors",
             @"":@"houses",
             @"":@"units"};
}

- (NSManagedObject *)getOrInsertManagedObject {
    CommunityBuild *build = (CommunityBuild*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYBUILD predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND buildingId=%@", self.communityId, self.buildingId]] firstObject];
    
    if (!build) {
        build = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_COMMUNITYBUILD];
    }
    
    return build;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        CommunityBuildInfo *info = [[CommunityBuildInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    CommunityBuildInfo *info = [[CommunityBuildInfo alloc] init];
    return [info infoFromManagedObject:obj];
}
@end