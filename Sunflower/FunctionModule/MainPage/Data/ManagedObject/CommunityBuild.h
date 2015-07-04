//
//  CommunityBuild.h
//  Sunflower
//
//  Created by makewei on 15/5/31.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"


#define k_ENTITY_COMMUNITYBUILD     @"CommunityBuild"

@interface CommunityBuild : NSManagedObject

@property (nonatomic, retain) NSNumber * build;
@property (nonatomic, retain) NSNumber * buildingId;
@property (nonatomic, retain) NSString * communityId;
@property (nonatomic, retain) NSNumber * floors;
@property (nonatomic, retain) NSNumber * houses;
@property (nonatomic, retain) NSNumber * units;

@end


@interface CommunityBuildInfo : MKWInfoObject


@property (nonatomic, strong) NSNumber * build;
@property (nonatomic, strong) NSNumber * buildingId;
@property (nonatomic, strong) NSString * communityId;
@property (nonatomic, strong) NSNumber * floors;
@property (nonatomic, strong) NSNumber * houses;
@property (nonatomic, strong) NSNumber * units;
@end