//
//  OpendCommunity.m
//  Sunflower
//
//  Created by mark on 15/4/29.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "OpendCommunity.h"
#import "MKWModelHandler.h"


@implementation OpendCommunity

@dynamic province;
@dynamic city;
@dynamic area;
@dynamic communityId;
@dynamic name;
@dynamic communityDesc;
@dynamic images;
@dynamic checkInUserCount;


- (OpendCommunityInfo*)infoObject {
    return [OpendCommunityInfo infoObjFromManagedObj:self];
}

@end


@implementation OpendCommunityInfo

+ (instancetype)infoObjFromManagedObj:(NSManagedObject *)obj {
    OpendCommunityInfo *retVal = [[OpendCommunityInfo alloc] init];
    retVal.communityId = ((OpendCommunity*)obj).communityId;
    retVal.name = ((OpendCommunity*)obj).name;
    retVal.province = ((OpendCommunity*)obj).province;
    retVal.city = ((OpendCommunity*)obj).city;
    retVal.area = ((OpendCommunity*)obj).area;
    retVal.communityDesc = ((OpendCommunity*)obj).communityDesc;
    retVal.images = ((OpendCommunity*)obj).images;
    retVal.checkInUserCount = ((OpendCommunity*)obj).checkInUserCount;
    
    return retVal;
}

+ (instancetype)opendCommunityWithJSONDic:(NSDictionary *)dic {
    if (!dic || [dic count] <= 0) {
        return nil;
    }
    
    return [OpendCommunityInfo _parserOpendCommunityFromJSONDic:dic];
    
}

+ (NSArray *)opendCommunityArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        [retVal addObject:[OpendCommunityInfo _parserOpendCommunityFromJSONDic:dic]];
    }
    return retVal;
}

+ (instancetype)_parserOpendCommunityFromJSONDic:(NSDictionary *)dic {
    OpendCommunityInfo *community = [[OpendCommunityInfo alloc] init];
    community.communityId = [dic objectForKey:@"CommunityId"];
    community.name = [dic objectForKey:@"Name"];
    community.province = [dic objectForKey:@"Province"];
    community.city = [dic objectForKey:@"City"];
    community.area = [dic objectForKey:@"Area"];
    community.communityDesc = [dic objectForKey:@"Description"];
    community.images = [dic objectForKey:@"Images"];
    community.checkInUserCount = [dic objectForKey:@"CheckInUserCount"];
    
    return community;
}


- (void)saveToDb {
    OpendCommunity *community = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_OPENDCOMMUNITY predicate:[NSPredicate predicateWithFormat:@"communityId=%@", self.communityId]] firstObject];
    if (!community) {
        community = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_OPENDCOMMUNITY];
    }
    
    community.communityId = self.communityId;
    community.name = self.name;
    community.province = self.province;
    community.city = self.city;
    community.area = self.area;
    community.communityDesc = self.communityDesc;
    community.images = self.images;
    community.checkInUserCount = self.checkInUserCount;
}

@end