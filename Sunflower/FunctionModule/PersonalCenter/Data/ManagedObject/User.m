//
//  User.m
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "User.h"
#import "MKWModelHandler.h"

#import "NSDictionary+MKWJson.h"


@implementation User

@dynamic avatar;
@dynamic auditPhoneNum;
@dynamic couponCount;
@dynamic createDate;
@dynamic email;
@dynamic isVip;
@dynamic nickName;
@dynamic password;
@dynamic sex;
@dynamic udid;
@dynamic userId;
@dynamic userName;
@dynamic vipEndDate;
@dynamic token;
@dynamic loginDate;
@dynamic validDays;
@dynamic auditDate;
@dynamic building;
@dynamic communityId;
@dynamic communityName;
@dynamic infoExtent;
@dynamic isAudit;
@dynamic points;
@dynamic room;
@dynamic trueName;
@dynamic type;
@dynamic unit;
@dynamic invitationNum;
@dynamic roomProperty;
@dynamic roleName;

@end


@implementation UserInfo

-(NSDictionary *)mappingKeys {
    return @{
             @"Avatar":@"avatar",
             @"AuditPhoneNum":@"auditPhoneNum",
             @"CouponCount":@"couponCount",
             @"CreateDate":@"createDate",
             @"Email":@"email",
             @"IsVip":@"isVip",
             @"NickName":@"nickName",
             @"Password":@"password",
             @"Sex":@"sex",
             @"UDID":@"udid",
             @"UserId":@"userId",
             @"UserName":@"userName",
             @"VipEndDate":@"vipEndDate",
             @"Token":@"token",
             @"LoginDate":@"loginDate",
             @"ValidDays":@"validDays",
             @"AuditDate":@"auditDate",
             @"Building":@"building",
             @"CommunityId":@"communityId",
             @"CommunityName":@"communityName",
             @"InfoExtent":@"infoExtent",
             @"IsAudit":@"isAudit",
             @"Points":@"points",
             @"Room":@"room",
             @"TrueName":@"trueName",
             @"Type":@"type",
             @"Unit":@"unit",
             @"InvitationNum":@"invitationNum",
             @"RoomProperty":@"roomProperty",
             @"RoleName":@"roleName",
             };
}

-(NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return [dic validModelDictionary];
}

-(NSManagedObject *)getOrInsertManagedObject {
    User *user = (User*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_USER predicate:[NSPredicate predicateWithFormat:@"userId=%@",self.userId]] firstObject];
    if (!user) {
        user = (User*)[[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_USER];
    }
    return user;
}

+(instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    UserInfo *user = [[UserInfo alloc] init];
    return [user infoFromManagedObject:obj];
}

@end
