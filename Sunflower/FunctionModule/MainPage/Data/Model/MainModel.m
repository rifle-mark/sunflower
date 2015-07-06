//
//  MainModel.m
//  Sunflower
//
//  Created by makewei on 15/5/31.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MainModel.h"
#import "ServerProxy.h"
#import "JSONServerProxy.h"

#import "MKWModelHandler.h"

@implementation MainModel


+ (void)asyncGetCommunityInfoWithId:(NSNumber *)communityId
                         cacheBlock:(void(^)(CommunityInfo *community, NSArray *buildList))cache
                        remoteBlock:(void(^)(CommunityInfo *community, NSArray *buildList, NSError *error))remote {
    Community *obj = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITY predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]] firstObject];
    NSArray *builds = [[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYBUILD predicate:[NSPredicate predicateWithFormat:@"communityId=%@", communityId]];
    if (obj && builds) {
        NSMutableArray *blockBuilds = [@[] mutableCopy];
        for (CommunityBuild *build in builds) {
            [blockBuilds addObject:[CommunityBuildInfo infoWithManagedObj:build]];
        }
        GCBlockInvoke(cache, [CommunityInfo infoWithManagedObj:obj], blockBuilds);
    }
    
    [JSONServerProxy getWithUrl:[NSString stringWithFormat:@"%@%@", k_API_MAIN_COMMUNITYINFO_QUERY, communityId] success:^(NSDictionary *responseJSON) {
        if (![[responseJSON objectForKey:@"isSuc"] boolValue]) {
            GCBlockInvoke(remote, nil, nil, [NSError errorWithDomain:[responseJSON objectForKey:@"message"] code:[[responseJSON objectForKey:@"code"] integerValue] userInfo:nil]);
            
            return;
        }
        CommunityInfo *community = [[CommunityInfo alloc] init];
        NSArray *buildings = [CommunityBuildInfo infoArrayWithJSONArray:[[responseJSON objectForKey:@"result"] objectForKey:@"buildings"]];
        GCBlockInvoke(remote, [community infoWithJSONDic:[responseJSON objectForKey:@"result"]], buildings, nil);
        
//        [[MKWModelHandler defaultHandler] deleteObjectsInEntity:k_ENTITY_COMMUNITY];
//        [[MKWModelHandler defaultHandler] deleteObjectsInEntity:k_ENTITY_COMMUNITYBUILD];
        [community saveToDb];
        for (CommunityBuildInfo *build in buildings) {
            [build saveToDb];
        }
    } failed:^(NSError *error) {
        GCBlockInvoke(remote, nil, nil, error);
    }];
}
@end
