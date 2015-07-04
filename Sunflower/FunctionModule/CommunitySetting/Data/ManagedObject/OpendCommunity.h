//
//  OpendCommunity.h
//  Sunflower
//
//  Created by mark on 15/4/29.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define k_ENTITY_OPENDCOMMUNITY         @"OpendCommunity"

@class OpendCommunityInfo;

@interface OpendCommunity : NSManagedObject

@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * communityDesc;
@property (nonatomic, retain) NSString * images;
@property (nonatomic, retain) NSNumber * checkInUserCount;

- (OpendCommunityInfo*)infoObject;

@end


@interface OpendCommunityInfo : NSObject

+ (instancetype)opendCommunityWithJSONDic:(NSDictionary *)dic;
+ (NSArray *)opendCommunityArrayWithJSONArray:(NSArray *)array;
+ (instancetype)infoObjFromManagedObj:(NSManagedObject *)obj;

- (void)saveToDb;

@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * communityDesc;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSNumber * checkInUserCount;

@end
