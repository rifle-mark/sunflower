//
//  ShopInfoEditVC.h
//  Sunflower
//
//  Created by makewei on 15/5/21.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shop.h"
#import "ShopStore.h"

typedef NS_ENUM(NSUInteger, ShopEditInfoType) {
    ShopName,
    ShopTel,
    ShopAddress,
    ShopDesc,
    ShopSubStore
};

@interface ShopInfoEditVC : MKWViewController

@property(nonatomic,assign)ShopEditInfoType     editType;
@property(nonatomic,strong)ShopInfo             *shop;
@property(nonatomic,strong)NSArray              *shopStores;

@end
