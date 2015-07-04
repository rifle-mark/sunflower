//
//  PropertyPayCell.h
//  Sunflower
//
//  Created by makewei on 15/6/28.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"

@interface PropertyPayCell : UITableViewCell

@property(nonatomic,strong)UIImageView  *iconV;
@property(nonatomic,strong)UILabel      *timeL;
@property(nonatomic,strong)UILabel      *nameL;
@property(nonatomic,strong)UILabel      *priceTitleL;
@property(nonatomic,strong)UILabel      *priceL;
@property(nonatomic,strong)UIButton     *payBtn;

@property(nonatomic,strong)PaymentInfo  *payment;
@property(nonatomic,copy)void(^payBlock)(PaymentInfo *payment);

+ (NSString *)reuseIdentify;

@end
