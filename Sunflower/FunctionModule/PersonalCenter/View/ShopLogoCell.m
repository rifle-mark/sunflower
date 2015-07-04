//
//  ShopLogoCell.m
//  Sunflower
//
//  Created by mark on 15/5/12.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopLogoCell.h"

@implementation ShopLogoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentify {
    return @"pc_shop_logo_cell";
}

@end
