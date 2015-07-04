//
//  LifeServer.m
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "LifeServer.h"
#import "MKWModelHandler.h"


@implementation LifeServer

@dynamic banner;
@dynamic communityId;
@dynamic serverDesc;
@dynamic serverId;
@dynamic image;
@dynamic subTitle;
@dynamic tel;
@dynamic title;
@dynamic url;
@dynamic userId;

@end

@implementation LifeServerInfo

-(NSDictionary *)mappingKeys {
    return @{
             @"Banner":@"banner",
             @"CommunityId":@"communityId",
             @"Description":@"serverDesc",
             @"Id":@"serverId",
             @"Image":@"image",
             @"SubTitle":@"subTitle",
             @"Tel":@"tel",
             @"Title":@"title",
             @"Url":@"url",
             @"UserId":@"userId",
             };
}

- (NSManagedObject *)getOrInsertManagedObject {
    LifeServer *retVal = (LifeServer*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_LIFESERVER predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND serverId=%@", self.communityId, self.serverId]] firstObject];
    if (!retVal) {
        retVal = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_LIFESERVER];
    }
    return retVal;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        LifeServerInfo *info = [[LifeServerInfo alloc] init];
        [retVal addObject:[info infoWithJSONDic:dic]];
    }
    return retVal;
}
+ (instancetype)infoWithManagedObj:(NSManagedObject*)obj {
    LifeServerInfo *info = [[LifeServerInfo alloc] init];
    return [info infoFromManagedObject:obj];
}

@end
