//
//  Feed.h
//  Sunflower
//
//  Created by kelei on 15/7/25.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_FEED     @"Feed"

@interface Feed : NSManagedObject

@property (nonatomic, retain) NSNumber * askId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSNumber * orderNum;
@property (nonatomic, retain) NSString * title;

@end


@interface FeedInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * askId;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSNumber * orderNum;
@property (nonatomic, strong) NSString * title;

@end