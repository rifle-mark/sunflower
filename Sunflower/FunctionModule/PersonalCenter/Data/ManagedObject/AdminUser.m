//
//  AdminUser.m
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "AdminUser.h"

#import "MKWModelHandler.h"



@implementation AdminUser

@dynamic adminId;
@dynamic adminToken;
@dynamic communityId;
@dynamic realName;
@dynamic userName;
@dynamic avatar;
@dynamic adminType;

@end


@implementation AdminUserInfo

-(NSDictionary *)mappingKeys {
    return @{
             @"AdminId":@"adminId",
             @"AdminToken":@"adminToken",
             @"CommunityId":@"communityId",
             @"RealName":@"realName",
             @"UserName":@"userName",
             @"Avatar":@"avatar",
             };
}

-(NSManagedObject *)getOrInsertManagedObject {
    AdminUser *user = (AdminUser*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_ADMINUSER predicate:[NSPredicate predicateWithFormat:@"adminId=%@", self.adminId]] firstObject];
    if (!user) {
        user = (AdminUser*)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_ADMINUSER];
    }
    return user;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    AdminUserInfo *retVal = [[AdminUserInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}

@end

