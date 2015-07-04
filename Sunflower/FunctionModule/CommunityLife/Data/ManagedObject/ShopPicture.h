//
//  ShopPicture.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"

#define k_ENTITY_SHOPPICTURE            @"ShopPicture"


@interface ShopPicture : NSManagedObject

@property (nonatomic, retain) NSNumber * shopId;
@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * image;

@end

@interface ShopPictureInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * shopId;
@property (nonatomic, strong) NSNumber * adminId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * image;

@end
