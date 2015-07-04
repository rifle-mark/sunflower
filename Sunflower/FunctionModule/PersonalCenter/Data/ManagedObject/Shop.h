//
//  Shop.h
//  Sunflower
//
//  Created by makewei on 15/5/20.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_SHOP           @"Shop"


@interface Shop : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sellerId;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * shopDesc;

@end



@interface ShopInfo : MKWInfoObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSNumber * adminId;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * sellerId;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * shopDesc;

@end
