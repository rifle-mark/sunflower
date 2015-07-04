//
//  AdminUser.h
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_ADMINUSER          @"AdminUser"

typedef NS_ENUM(NSInteger, AdminUserType) {
    Business = 1,
    Property
};


@interface AdminUser : NSManagedObject

@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSString * adminToken;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSNumber * adminType;

@end


@interface AdminUserInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * adminId;
@property (nonatomic, strong) NSString * adminToken;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSNumber * adminType;

@end
