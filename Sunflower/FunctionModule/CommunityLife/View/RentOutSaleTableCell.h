//
//  RentOutSaleTableCell.h
//  Sunflower
//
//  Created by mark on 15/5/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentOutSaleTableCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView       *imageV;
@property(nonatomic,weak)IBOutlet UILabel           *titleL;
@property(nonatomic,weak)IBOutlet UILabel           *roomFixL;
@property(nonatomic,weak)IBOutlet UILabel           *priceL;

@property(nonatomic,strong)NSNumber                 *houseId;

+ (NSString *)reuseIdentify;

@end
