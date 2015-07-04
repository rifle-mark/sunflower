//
//  HouseImage.h
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_HOUSEIMAGE         @"HouseImage"

@interface HouseImage : NSManagedObject

@property (nonatomic, retain) NSNumber * houseId;
@property (nonatomic, retain) NSNumber * imageId;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * remark;

@end

@interface HouseImageInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * houseId;
@property (nonatomic, strong) NSNumber * imageId;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * remark;

@end
