//
//  FixIssue.m
//  Sunflower
//
//  Created by makewei on 15/6/15.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "FixIssue.h"
#import "MKWModelHandler.h"

@implementation FixIssue

@dynamic address;
@dynamic communityId;
@dynamic content;
@dynamic createDate;
@dynamic issueId;
@dynamic images;
@dynamic hasDeleted;
@dynamic type;
@dynamic userId;
@dynamic userName;
@dynamic userPhone;

@end

@implementation FixIssueInfo

- (NSDictionary *)mappingKeys {
    return @{@"Address":@"address",
             @"CommunityId":@"communityId",
             @"Content":@"content",
             @"CreateDate":@"createDate",
             @"Id":@"issueId",
             @"Images":@"images",
             @"IsDeleted":@"hasDeleted",
             @"Type":@"type",
             @"UserId":@"userId",
             @"UserName":@"userName",
             @"UserPhone":@"userPhone",};
}

- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}

- (NSManagedObject *)getOrInsertManagedObject {
    FixIssue *obj = (FixIssue*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_FIXISSUE predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND issueId=%@",self.communityId, self.issueId]] firstObject];
    if (!obj) {
        obj = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_FIXISSUE];
    }
    
    return obj;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        FixIssueInfo *info = [[FixIssueInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    FixIssueInfo *info = [[FixIssueInfo alloc] init];
    return [info infoFromManagedObject:obj];
}

@end