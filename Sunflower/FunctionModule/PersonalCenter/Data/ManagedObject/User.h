//
//  User.h
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_USER           @"User"

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * auditPhoneNum;
@property (nonatomic, retain) NSNumber * couponCount;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * isVip;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSString * udid;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * vipEndDate;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * loginDate;
@property (nonatomic, retain) NSNumber * validDays;
@property (nonatomic, retain) NSNumber * auditDate;
@property (nonatomic, retain) NSString * building;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSString * communityName;
@property (nonatomic, retain) NSString * infoExtent;
@property (nonatomic, retain) NSNumber * isAudit;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * trueName;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * invitationNum;
@property (nonatomic, retain) NSString * roomProperty;
@property (nonatomic, retain) NSString * roleName;

@end



@interface UserInfo : MKWInfoObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * auditPhoneNum;
@property (nonatomic, strong) NSNumber * couponCount;
@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSNumber * isVip;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, strong) NSString * udid;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSNumber * vipEndDate;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSNumber * loginDate;
@property (nonatomic, strong) NSNumber * validDays;
@property (nonatomic, strong) NSNumber * auditDate;
@property (nonatomic, strong) NSString * building;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSString * communityName;
@property (nonatomic, strong) NSString * infoExtent;
@property (nonatomic, strong) NSNumber * isAudit;
@property (nonatomic, strong) NSNumber * points;
@property (nonatomic, strong) NSString * room;
@property (nonatomic, strong) NSString * trueName;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSString * unit;
@property (nonatomic, strong) NSString * invitationNum;
@property (nonatomic, strong) NSString * roomProperty;
@property (nonatomic, strong) NSString * roleName;

@end
