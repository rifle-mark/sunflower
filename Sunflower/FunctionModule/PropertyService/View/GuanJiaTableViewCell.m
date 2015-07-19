//
//  GuanJiaTableViewCell.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "GuanJiaTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface GuanJiaTableViewCell ()

@property(nonatomic,strong) UIImageView       *imageV;
@property(nonatomic,strong) UILabel           *nameL;
@property(nonatomic,strong) UILabel           *titleL;
@property(nonatomic,strong) UILabel           *phoneL;
@property(nonatomic,strong) UIButton          *upBtn;

@end

@implementation GuanJiaTableViewCell
+ (NSString *)reuseIdentify {
    return @"GuanJiaTableViewCellIdentify";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _weak(self);
        self.imageV = [[UIImageView alloc] init];
        self.imageV.layer.borderColor = [RGB(223, 223, 223) CGColor];
        self.imageV.layer.borderWidth = 1;
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView);
            make.leading.equalTo(self.contentView).with.offset(20);
            make.width.equalTo(@64);
            make.height.equalTo(@79);
        }];
        
        self.nameL = [[UILabel alloc] init];
        self.nameL.textColor = k_COLOR_GALLERY_F;
        self.nameL.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(27);
            make.left.equalTo(self.imageV.mas_right).with.offset(17);
            make.height.equalTo(@17);
            make.right.equalTo(self.contentView).with.offset(-84);
        }];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.textColor = k_COLOR_GALLERY_F;
        self.titleL.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(5);
            make.left.equalTo(self.imageV.mas_right).with.offset(17);
            make.height.equalTo(@12);
            make.right.equalTo(self.contentView).with.offset(-84);
        }];
        
        self.phoneL = [[UILabel alloc] init];
        self.phoneL.textColor = k_COLOR_BLUE;
        self.phoneL.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:self.phoneL];
        [self.phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.titleL.mas_bottom).with.offset(5);
            make.left.equalTo(self.imageV.mas_right).with.offset(17);
            make.height.equalTo(@14);
            make.right.equalTo(self.contentView).with.offset(-84);
        }];
        
        self.upBtn = [[UIButton alloc] init];
        self.upBtn.layer.cornerRadius = 4;
        self.upBtn.layer.borderColor = [RGB(233, 233, 233) CGColor];
        self.upBtn.layer.borderWidth = 1;
        self.upBtn.imageEdgeInsets = UIEdgeInsetsMake(-30, 18, 0, 0);
        self.upBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -20, 0, 0);
        [self.upBtn setImage:[UIImage imageNamed:@"guanjia_up_btn_n"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"guanjia_up_btn_s"] forState:UIControlStateHighlighted];
        [self.upBtn setImage:[UIImage imageNamed:@"guanjia_up_btn_s"] forState:UIControlStateSelected];
        self.upBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.upBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [self.upBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if (self.isUped) {
                return;
            }
            GCBlockInvoke(self.upActionBlock);
        }];
        [self.contentView addSubview:self.upBtn];
        [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-14);
            make.width.height.equalTo(@70);
        }];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = k_COLOR_GALLERY;
        [self.contentView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        [self _setupObserver];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)_setupObserver {
    [self startObserveObject:self forKeyPath:@"guanjia" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        [self.imageV sd_setImageWithURL:[APIGenerator urlOfPictureWith:64 height:79 urlString:self.guanjia.image] placeholderImage:[UIImage imageNamed:@"default_left_height"]];
        self.nameL.text = self.guanjia.name;
        self.titleL.text = self.guanjia.title;
        self.phoneL.text = self.guanjia.phone;
        [self.upBtn setTitle:[NSString stringWithFormat:@"赞（%@）", self.guanjia.actionCount ?: @0] forState:UIControlStateNormal];
    }];
    
    [self startObserveObject:self forKeyPath:@"isUped" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        if (self.isUped) {
            [self.upBtn setSelected:YES];
        }
        else {
            [self.upBtn setSelected:NO];
        }
    }];
}

- (void)updateUpState {
    if (self.isUped) {
        [self.upBtn setTitle:[NSString stringWithFormat:@"赞（%ld）", (long)([self.guanjia.actionCount integerValue]+1)] forState:UIControlStateNormal];
    }
}
@end
