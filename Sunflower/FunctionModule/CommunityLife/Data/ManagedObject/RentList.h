//
//  RentList.h
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_RENTLIST           @"RentList"

@interface RentList : NSManagedObject

@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSNumber * area;
@property (nonatomic, retain) NSString * checkIn;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSNumber * crateDate;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSNumber * endPrice;
@property (nonatomic, retain) NSString * fix;
@property (nonatomic, retain) NSNumber * floor;
@property (nonatomic, retain) NSNumber * hall;
@property (nonatomic, retain) NSNumber * houseId;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * orientation;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * privince;
@property (nonatomic, retain) NSString * rentDesc;
@property (nonatomic, retain) NSNumber * room;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * toilet;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPhone;
@property (nonatomic, retain) NSString * adminAvatar;
@property (nonatomic, retain) NSString * userAvatar;

@end

@interface RentListInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * adminId;
@property (nonatomic, strong) NSNumber * area;
@property (nonatomic, strong) NSString * checkIn;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSNumber * crateDate;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSNumber * endPrice;
@property (nonatomic, strong) NSString * fix;
@property (nonatomic, strong) NSNumber * floor;
@property (nonatomic, strong) NSNumber * hall;
@property (nonatomic, strong) NSNumber * houseId;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * orientation;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSString * privince;
@property (nonatomic, strong) NSString * rentDesc;
@property (nonatomic, strong) NSNumber * room;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * toilet;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userPhone;
@property (nonatomic, strong) NSString * adminAvatar;
@property (nonatomic, strong) NSString * userAvatar;

@end
