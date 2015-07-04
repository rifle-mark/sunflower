//
//  LifeServerTableCell.m
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "LifeServerTableCell.h"

@implementation LifeServerTableCell

+ (NSString *)reuseIdentify {
    return @"LLifeServerTableCell";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
