//
//  LifeServer.h
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_LIFESERVER         @"LifeServer"
@interface LifeServer : NSManagedObject

@property (nonatomic, retain) NSString * banner;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSString * serverDesc;
@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * userId;

@end

@interface LifeServerInfo : MKWInfoObject

@property (nonatomic, strong) NSString * banner;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSString * serverDesc;
@property (nonatomic, strong) NSNumber * serverId;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * subTitle;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSNumber * userId;

@end
