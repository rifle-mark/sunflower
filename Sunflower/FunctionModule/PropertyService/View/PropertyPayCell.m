//
//  PropertyPayCell.m
//  Sunflower
//
//  Created by makewei on 15/6/28.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyPayCell.h"

@implementation PropertyPayCell

+ (NSString *)reuseIdentify {
    return @"PropertyPayCellIdentify";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _weak(self);
        self.iconV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconV];
        [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.contentView).with.offset(18);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@70);
            make.height.equalTo(@65);
        }];
        
        self.payBtn = [[UIButton alloc] init];
        self.payBtn.layer.cornerRadius = 4;
        [self.payBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [self.payBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        self.payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:self.payBtn];
        [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(29);
            make.right.equalTo(self.contentView).with.offset(-14);
            make.width.equalTo(@66);
            make.height.equalTo(@36);
        }];
        [self.payBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if ([self.payment.state integerValue] == 1) {
                return;
            }
            
            GCBlockInvoke(self.payBlock, self.payment);
        }];
        
        self.timeL = [[UILabel alloc] init];
        self.timeL.textColor = k_COLOR_GALLERY_F;
        self.timeL.font = [UIFont boldSystemFontOfSize:11];
        [self.contentView addSubview:self.timeL];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(23);
            make.left.equalTo(self.iconV.mas_right).with.offset(24);
            make.height.equalTo(@11);
            make.right.equalTo(self.payBtn.mas_left).with.offset(-5);
        }];
        
        self.nameL = [[UILabel alloc] init];
        self.nameL.textColor = k_COLOR_GALLERY_F;
        self.nameL.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.timeL.mas_bottom).with.offset(4);
            make.left.right.equalTo(self.timeL);
            make.height.equalTo(@15);
        }];
        
        self.priceTitleL = [[UILabel alloc] init];
        self.priceTitleL.textColor = k_COLOR_GALLERY_F;
        self.priceTitleL.font = [UIFont systemFontOfSize:10];
        self.priceTitleL.text = @"￥";
        [self.contentView addSubview:self.priceTitleL];
        [self.priceTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(12);
            make.left.equalTo(self.nameL);
            make.height.equalTo(@10);
            make.width.equalTo(@10);
        }];
        
        self.priceL = [[UILabel alloc] init];
        self.priceL.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.priceL];
        [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(9);
            make.left.equalTo(self.priceTitleL.mas_right);
            make.right.equalTo(self.nameL);
            make.height.equalTo(@15);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = k_COLOR_GALLERY;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        [self _setupObserver];
    }
    
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"payment" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        NSString *nameTime = @"";
        if ([self.payment.type integerValue] == 1) {
            nameTime = [self.payment.chargeDate dateTimeYearMonth];
        }
        if ([self.payment.type integerValue] == 2) {
            NSNumber *month = [self.payment.chargeDate dateTimeMonthNumber];
            NSString *season = @"";
            if ([month integerValue] <=3) {
                season = @"第一季";
            }
            else if ([month integerValue] <= 6) {
                season = @"第二季";
            }
            else if ([month integerValue] <= 9) {
                season = @"第三季";
            }
            else {
                season = @"第四季";
            }
            nameTime = [NSString stringWithFormat:@"%@%@", [self.payment.chargeDate dateTimeYear], season];
        }
        if ([self.payment.type integerValue] == 3) {
            nameTime = [self.payment.chargeDate dateTimeYear];
        }
        
        // ChargeProperty
        if ([self.payment.chargeType integerValue] == 1) {
            self.iconV.image = [UIImage imageNamed:@"charge_property_icon"];
            if ([self.payment.state integerValue] == 1) {
                self.payBtn.backgroundColor = RGB(178, 178, 178);
                [self.payBtn setTitle:@"已缴纳" forState:UIControlStateNormal];
                [self.payBtn setEnabled:NO];
            }
            else {
                self.payBtn.backgroundColor = k_COLOR_BLUE;
                [self.payBtn setTitle:@"缴纳" forState:UIControlStateNormal];
                [self.payBtn setEnabled:YES];
            }
            self.nameL.text = [NSString stringWithFormat:@"%@物业费", nameTime];
            self.priceL.textColor = k_COLOR_BLUE;
        }
        // ChargeWarm
        if ([self.payment.chargeType integerValue] == 2) {
            self.iconV.image = [UIImage imageNamed:@"charge_warm_icon"];
            if ([self.payment.state integerValue] == 1) {
                self.payBtn.backgroundColor = RGB(178, 178, 178);
                [self.payBtn setTitle:@"已缴纳" forState:UIControlStateNormal];
                [self.payBtn setEnabled:NO];
            }
            else {
                self.payBtn.backgroundColor = k_COLOR_RED;
                [self.payBtn setTitle:@"缴纳" forState:UIControlStateNormal];
                [self.payBtn setEnabled:YES];
            }
            self.nameL.text = [NSString stringWithFormat:@"%@取暖费", nameTime];
            self.priceL.textColor = k_COLOR_RED;
        }
        // ChargeClean
        if ([self.payment.chargeType integerValue] == 3) {
            self.iconV.image = [UIImage imageNamed:@"charge_clean_icon"];
            if ([self.payment.state integerValue] == 1) {
                self.payBtn.backgroundColor = RGB(178, 178, 178);
                [self.payBtn setTitle:@"已缴纳" forState:UIControlStateNormal];
                [self.payBtn setEnabled:NO];
            }
            else {
                self.payBtn.backgroundColor = k_COLOR_GREEN;
                [self.payBtn setTitle:@"缴纳" forState:UIControlStateNormal];
                [self.payBtn setEnabled:YES];
            }
            self.nameL.text = [NSString stringWithFormat:@"%@卫生费", nameTime];
            self.priceL.textColor = k_COLOR_GREEN;
        }
        // ChargePark
        if ([self.payment.chargeType integerValue] == 4) {
            self.iconV.image = [UIImage imageNamed:@"charge_park_icon"];
            if ([self.payment.state integerValue] == 1) {
                self.payBtn.backgroundColor = RGB(178, 178, 178);
                [self.payBtn setTitle:@"已缴纳" forState:UIControlStateNormal];
                [self.payBtn setEnabled:NO];
            }
            else {
                self.payBtn.backgroundColor = k_COLOR_YELLOW;
                [self.payBtn setTitle:@"缴纳" forState:UIControlStateNormal];
                [self.payBtn setEnabled:YES];
            }
            self.nameL.text = [NSString stringWithFormat:@"%@停车费", nameTime];
            self.priceL.textColor = k_COLOR_YELLOW;
        }
        
        self.timeL.text = [self.payment.createDate dateSplitBySplash];
        self.priceL.text = [NSString stringWithFormat:@"%@元", self.payment.chargePrice];
    }];
}

@end
