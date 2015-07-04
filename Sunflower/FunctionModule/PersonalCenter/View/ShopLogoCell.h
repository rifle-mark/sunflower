//
//  ShopLogoCell.h
//  Sunflower
//
//  Created by mark on 15/5/12.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopLogoCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView   *logoV;

+ (NSString *)reuseIdentify;

@end
