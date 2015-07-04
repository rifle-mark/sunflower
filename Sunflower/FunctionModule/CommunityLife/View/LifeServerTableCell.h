//
//  LifeServerTableCell.h
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LifeServerInfo;
@interface LifeServerTableCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView           *logoV;
@property(nonatomic,weak)IBOutlet UILabel               *nameL;
@property(nonatomic,weak)IBOutlet UILabel               *subTitleL;
@property(nonatomic,weak)IBOutlet UILabel               *telL;

@property(nonatomic,strong)LifeServerInfo               *info;

+ (NSString *)reuseIdentify;

@end
