//
//  FixSuggest.h
//  Sunflower
//
//  Created by makewei on 15/6/15.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_FIXSUGGEST     @"FixSuggest"

@interface FixSuggest : NSManagedObject

@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSString * banner;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSString * suggestDesc;
@property (nonatomic, retain) NSNumber * suggestId;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userId;

@end

@interface FixSuggestInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * adminId;
@property (nonatomic, strong) NSString * banner;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSString * suggestDesc;
@property (nonatomic, strong) NSNumber * suggestId;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * subTitle;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * userId;
@end