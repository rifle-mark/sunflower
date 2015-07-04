//
//  RentInTableCell.h
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentInTableCell : UITableViewCell

+ (NSString *)reuseIdentify;

@property(nonatomic,weak)IBOutlet UILabel       *titleL;
@property(nonatomic,weak)IBOutlet UILabel       *timeL;

@property(nonatomic,strong)NSNumber                 *houseId;

@end
