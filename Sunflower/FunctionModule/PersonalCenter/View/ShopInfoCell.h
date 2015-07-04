//
//  ShopInfoCell.h
//  Sunflower
//
//  Created by mark on 15/5/12.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopInfoCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel       *titleL;
@property(nonatomic,weak)IBOutlet UILabel       *infoL;

+ (NSString*)reuseIdentify;

+ (NSAttributedString *)shopDescAttributeStringWithDesc:(NSString *)desc;
+ (CGFloat)shopDescCellHeighWithDescStr:(NSString *)desc  width:(CGFloat)width;

+ (NSAttributedString *)shopStoreAttributeStringWithStores:(NSArray *)stores;
+ (CGFloat)shopStorHeightWithStores:(NSArray *)stores  width:(CGFloat)width;
@end
