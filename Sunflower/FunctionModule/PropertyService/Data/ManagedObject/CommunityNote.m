//
//  CommunityNote.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CommunityNote.h"
#import "MKWModelHandler.h"
#import "NSDictionary+MKWJson.h"


@implementation CommunityNote

@dynamic communityId;
@dynamic noticeId;
@dynamic title;
@dynamic createDate;
@dynamic image;
@dynamic content;
@dynamic isRead;

@end


@implementation CommunityNoteInfo

- (NSDictionary *)mappingKeys {
    return @{
             @"CommunityId":@"communityId",
             @"NoticedId":@"noticeId",
             @"Title":@"title",
             @"Image":@"image",
             @"CreateDate":@"createDate",
             @"Content":@"content",
             };
}
- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}
- (NSManagedObject *)getOrInsertManagedObject {
    CommunityNote *obj = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYNOTE predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND noticeId=%@", self.communityId, self.noticeId]] firstObject];
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_COMMUNITYNOTE];
    }
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        CommunityNoteInfo *info = [[CommunityNoteInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        CommunityNote *obj = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYNOTE predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND noticeId=%@", info.communityId, info.noticeId]] firstObject];
        if (obj) {
            info.isRead = obj.isRead;
        }
        else {
            info.isRead = @NO;
        }
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject*)obj {
    CommunityNoteInfo *retVal = [[CommunityNoteInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}


- (void)readNote {
    self.isRead = @YES;
    [self saveToDb];
}

@end