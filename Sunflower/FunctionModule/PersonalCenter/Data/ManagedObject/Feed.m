//
//  Feed.m
//  Sunflower
//
//  Created by kelei on 15/7/25.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "Feed.h"
#import "MKWModelHandler.h"


@implementation Feed

@dynamic askId;
@dynamic content;
@dynamic createDate;
@dynamic orderNum;
@dynamic title;

@end


@implementation FeedInfo

-(NSDictionary *)mappingKeys {
    return @{@"AskId":@"askId",
             @"Content":@"content",
             @"CreateDate":@"createDate",
             @"OrderNum":@"orderNum",
             @"Title":@"title",
             };
}

-(NSManagedObject *)getOrInsertManagedObject {
    Feed *feed = (Feed *)[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_POINTRULER predicate:[NSPredicate predicateWithFormat:@"askId=%@", self.askId]];
    if (!feed) {
        feed = (Feed *)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_POINTRULER];
    }
    return feed;
}

+(NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        FeedInfo *info = [[FeedInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    FeedInfo *info = [[FeedInfo alloc] init];
    return [info infoFromManagedObject:obj];
}

@end
