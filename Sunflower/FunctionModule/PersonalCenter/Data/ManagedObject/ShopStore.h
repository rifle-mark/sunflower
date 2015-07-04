//
//  ShopStore.h
//  Sunflower
//
//  Created by makewei on 15/5/20.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_SHOPSTORE          @"ShopStore"


@interface ShopStore : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * shopId;
@property (nonatomic, retain) NSString * tel;

@end


@interface ShopStoreInfo : MKWInfoObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSNumber * adminId;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * shopId;
@property (nonatomic, strong) NSString * tel;

@end