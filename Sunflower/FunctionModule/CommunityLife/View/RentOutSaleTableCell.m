//
//  RentOutSaleTableCell.m
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "RentOutSaleTableCell.h"

@implementation RentOutSaleTableCell

+(NSString *)reuseIdentify {
    return @"LRentOutSaleTableCell";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse {
    self.imageV.image = [UIImage imageNamed:@"default_placeholder"];
}

@end
