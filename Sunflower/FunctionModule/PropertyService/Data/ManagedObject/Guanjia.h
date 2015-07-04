//
//  Guanjia.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"


#define k_ENTITY_GUANJIA        @"Guanjia"

@class GuanjiaInfo;

@interface Guanjia : NSManagedObject

@property (nonatomic, retain) NSNumber * guanjiaId;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSNumber * actionCount;

@end

@interface GuanjiaInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * guanjiaId;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSNumber * actionCount;

@end