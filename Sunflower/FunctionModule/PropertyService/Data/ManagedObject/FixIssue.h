//
//  FixIssue.h
//  Sunflower
//
//  Created by makewei on 15/6/15.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_FIXISSUE       @"FixIssue"

@interface FixIssue : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSNumber * issueId;
@property (nonatomic, retain) NSString * images;
@property (nonatomic, retain) NSNumber * hasDeleted;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPhone;

@end

@interface FixIssueInfo : MKWInfoObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSNumber * issueId;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSNumber * hasDeleted;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userPhone;
@end
