//
//  Community.h
//  Sunflower
//
//  Created by makewei on 15/5/31.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_COMMUNITY      @"Community"

@interface Community : NSManagedObject

@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSNumber * checkInUserCount;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSNumber * companyId;
@property (nonatomic, retain) NSString * communityDesc;
@property (nonatomic, retain) NSString * images;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * tel;

@end

@interface CommunityInfo : MKWInfoObject

@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSNumber * checkInUserCount;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSNumber * companyId;
@property (nonatomic, strong) NSString * communityDesc;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * tel;

@end