//
//  Community.m
//  Sunflower
//
//  Created by makewei on 15/5/31.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "Community.h"
#import "MKWModelHandler.h"


@implementation Community

@dynamic area;
@dynamic checkInUserCount;
@dynamic city;
@dynamic communityId;
@dynamic companyId;
@dynamic communityDesc;
@dynamic images;
@dynamic name;
@dynamic province;
@dynamic tel;

@end


@implementation CommunityInfo

- (NSDictionary *)mappingKeys {
    return @{@"Area":@"area",
             @"CheckInUserCount":@"checkInUserCount",
             @"City":@"city",
             @"CommunityId":@"communityId",
             @"CompanyId":@"companyId",
             @"Description":@"communityDesc",
             @"Images":@"images",
             @"Name":@"name",
             @"Province":@"province",
             @"Tel":@"tel"};
}

- (NSManagedObject *)getOrInsertManagedObject {
    Community *community = (Community *)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITY predicate:[NSPredicate predicateWithFormat:@"communityId=%@",self.communityId]] firstObject];
    if (!community) {
        community = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_COMMUNITY];
    }
    
    return community;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    CommunityInfo *info = [[CommunityInfo alloc] init];
    return [info infoFromManagedObject:obj];
}

@end