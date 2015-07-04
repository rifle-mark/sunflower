//
//  PropertyShop.h
//  Sunflower
//
//  Created by makewei on 15/6/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"


#define k_ENTITY_PROPERTYSHOP       @"PropertyShop"
@interface PropertyShop : NSManagedObject

@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * shopInfoId;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSNumber * userId;

@end

@interface PropertyShopInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * adminId;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * shopInfoId;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSNumber * userId;

@end