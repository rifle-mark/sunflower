//
//  CSTableViewCell.h
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GSTableCellType) {
    City,
    Area,
    Community,
};

@interface CSTableViewCell : UITableViewCell

@property(nonatomic,assign)GSTableCellType       type;
@property(nonatomic,strong)NSString              *titleText;

@property(nonatomic,weak)IBOutlet UIImageView    *iconImgV;
@property(nonatomic,weak)IBOutlet UILabel        *titleL;
@property(nonatomic,weak)IBOutlet UIImageView    *selectedImgV;

@end
