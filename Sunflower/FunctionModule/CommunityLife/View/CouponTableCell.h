//
//  CouponTableCell.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableCell : UITableViewCell

@property(nonatomic,weak)NSNumber       *couponId;

@property(nonatomic,weak)IBOutlet UIImageView       *logoV;
@property(nonatomic,weak)IBOutlet UILabel           *titleL;
@property(nonatomic,weak)IBOutlet UILabel           *subTitleL;
@property(nonatomic,weak)IBOutlet UILabel           *hasUsedL;
@property(nonatomic,weak)IBOutlet UILabel           *endTimeL;
@property(nonatomic,weak)IBOutlet UIButton          *getBtn;

@end
