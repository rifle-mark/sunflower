//
//  FixSuggest.m
//  Sunflower
//
//  Created by makewei on 15/6/15.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "FixSuggest.h"

#import "MKWModelHandler.h"

@implementation FixSuggest

@dynamic adminId;
@dynamic banner;
@dynamic communityId;
@dynamic suggestDesc;
@dynamic suggestId;
@dynamic image;
@dynamic subTitle;
@dynamic tel;
@dynamic title;
@dynamic userId;

@end


@implementation FixSuggestInfo

-(NSDictionary *)mappingKeys {
    return @{@"AdminId":@"adminId",
             @"Banner":@"banner",
             @"CommunityId":@"communityId",
             @"Description":@"suggestDesc",
             @"Id":@"suggestId",
             @"Image":@"image",
             @"SubTitle":@"subTitle",
             @"Tel":@"tel",
             @"Title":@"title",
             @"UserId":@"userId",};
}

- (NSManagedObject *)getOrInsertManagedObject {
    FixSuggest *obj = (FixSuggest*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_FIXSUGGEST predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND suggestId=%@", self.communityId, self.suggestId]] firstObject];
    
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_FIXSUGGEST];
    }
    
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        FixSuggestInfo *info = [[FixSuggestInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    FixSuggestInfo *info = [[FixSuggestInfo alloc] init];
    return [info infoFromManagedObject:obj];
}

@end