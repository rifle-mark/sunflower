//
//  AroundChipInfoVC.m
//  Sunflower
//
//  Created by mark on 15/5/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "AroundChipInfoVC.h"
#import "AroundChipAddressListVC.h"
#import "ShopCouponEditVC.h"
#import "ShopCouponJudgeEditVC.h"
#import "CouponCommentView.h"

#import "CommunityLifeModel.h"
#import "UserModel.h"
#import <UIImageView+WebCache.h>

#pragma mark - CouponInfoCell

@interface CouponInfoCell : UITableViewCell

@property(nonatomic,strong)UIImageView      *imageV;
@property(nonatomic,strong)UILabel          *nameL;
@property(nonatomic,strong)UILabel          *gotL;
@property(nonatomic,strong)UILabel          *endDateL;
@property(nonatomic,strong)UILabel          *detailL;

@property(nonatomic,strong)CouponInfo       *coupon;
@property(nonatomic,copy)void(^shopAddBlock)(CouponInfo *coupon);
@property(nonatomic,copy)void(^getCouponBlock)(CouponInfo *coupon);

+ (NSAttributedString *)detailAttributeStringWithCoupon:(CouponInfo *)coupon;
+ (CGFloat)heightOfCellWithCoupon:(CouponInfo *)coupon;
+ (NSString *)reuseIdentify;
@end

@implementation CouponInfoCell

+ (NSString *)reuseIdentify {
    return @"CouponInfoCellIdentify";
}

+ (NSAttributedString *)detailAttributeStringWithCoupon:(CouponInfo *)coupon {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = NSTextAlignmentLeft;
    ps.lineSpacing = 4;
    NSDictionary *titleattributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                 NSParagraphStyleAttributeName:ps,
                                 NSForegroundColorAttributeName:k_COLOR_BLUE,
                                 NSBaselineOffsetAttributeName: @0};
    
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] init];
    [ret appendAttributedString:[[NSAttributedString alloc] initWithString:@"优惠细则:\n" attributes:titleattributes]];
    
    NSDictionary *contentattributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                        NSParagraphStyleAttributeName:ps,
                                        NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                                        NSBaselineOffsetAttributeName: @0};
    [ret appendAttributedString:[[NSAttributedString alloc] initWithString:coupon.couponDesc attributes:contentattributes]];
    
    return ret;
}
+ (CGFloat)heightOfCellWithCoupon:(CouponInfo *)coupon {
    if (!coupon) {
        return 0;
    }
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat contentH = [[CouponInfoCell detailAttributeStringWithCoupon:coupon] boundingRectWithSize:ccs(screenW - 36, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    return screenW/2/*图片*/ + 65/*标题*/ + contentH/*内容*/ + 20/*内容上下间距*/ + 97/*底部控制*/;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _weak(self);
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.equalTo(self.contentView);
            make.height.equalTo(@([UIScreen mainScreen].bounds.size.width/2));
        }];
        
        UIView *titleV = [[UIView alloc] init];
        titleV.backgroundColor = k_COLOR_CLEAR;
        [self.contentView addSubview:titleV];
        [titleV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.imageV.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@65);
        }];
        
        self.nameL = [[UILabel alloc] init];
        self.nameL.textColor = k_COLOR_BLUE;
        self.nameL.font = [UIFont boldSystemFontOfSize:23];
        [titleV addSubview:self.nameL];
        _weak(titleV);
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(titleV);
            make.top.equalTo(titleV).with.offset(15);
            make.left.equalTo(titleV).with.offset(18);
            make.right.equalTo(titleV).with.offset(-18);
            make.height.equalTo(@23);
        }];
        
        self.endDateL = [[UILabel alloc] init];
        self.endDateL.textColor = k_COLOR_GALLERY_F;
        self.endDateL.font = [UIFont boldSystemFontOfSize:12];
        self.endDateL.textAlignment = NSTextAlignmentRight;
        [titleV addSubview:self.endDateL];
        [self.endDateL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(8);
            make.right.equalTo(self.nameL);
            make.height.equalTo(@12);
            make.width.equalTo(@145);
        }];
        
        self.gotL = [[UILabel alloc] init];
        self.gotL.textColor = k_COLOR_GALLERY_F;
        self.gotL.font = [UIFont boldSystemFontOfSize:12];
        [titleV addSubview:self.gotL];
        [self.gotL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.height.equalTo(self.endDateL);
            make.left.equalTo(self.nameL);
            make.right.equalTo(self.endDateL.mas_left).with.offset(-8);
        }];
        
        UIButton *getBtn = [[UIButton alloc] init];
        getBtn.layer.cornerRadius = 4;
        getBtn.backgroundColor = k_COLOR_BLUE;
        getBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [getBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        [getBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.getCouponBlock, self.coupon);
        }];
        [self.contentView addSubview:getBtn];
        [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.equalTo(self.contentView).with.offset(-8);
            make.left.right.equalTo(self.nameL);
            make.height.equalTo(@43);
        }];
        
        UIButton *addressBtn = [[UIButton alloc] init];
        addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
        addressBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [addressBtn setTitleColor:k_COLOR_BLUE forState:UIControlStateNormal];
        [addressBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        [addressBtn setTitle:@"查看适用门店 >" forState:UIControlStateNormal];
        [addressBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.shopAddBlock, self.coupon);
        }];
        [self.contentView addSubview:addressBtn];
        _weak(getBtn);
        [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(getBtn);
            make.bottom.equalTo(getBtn.mas_top).with.offset(-8);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@38);
        }];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = k_COLOR_GALLERY;
        [self.contentView addSubview:lineV];
        _weak(addressBtn);
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(addressBtn);
            _strong(self);
            make.bottom.equalTo(addressBtn.mas_top);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        self.detailL = [[UILabel alloc] init];
        self.detailL.numberOfLines = 0;
        [self.contentView addSubview:self.detailL];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"coupon" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (!self.coupon) {
            return;
        }
        [self.imageV sd_setImageWithURL:[APIGenerator urlOfPictureWith:[UIScreen mainScreen].bounds.size.width height:[UIScreen mainScreen].bounds.size.width/2 urlString:self.coupon.image] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
        self.nameL.text = self.coupon.subTitle;
        self.gotL.text = [NSString stringWithFormat:@"已有%@人领取", self.coupon.useCount];
        self.endDateL.text = [NSString stringWithFormat:@"有效期：%@", [self.coupon.endDate dateSplitByChinese]];
        self.detailL.attributedText = [[self class] detailAttributeStringWithCoupon:self.coupon];
        [self.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.imageV.mas_bottom).with.offset(70);
            make.left.right.equalTo(self.nameL);
            CGFloat contentH = [[CouponInfoCell detailAttributeStringWithCoupon:self.coupon] boundingRectWithSize:ccs(V_W_(self)- 36, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
            make.height.equalTo(@(contentH+10));
        }];
    }];
}

@end

#pragma mark - CouponJudgeOptionCell
@interface CouponJudgeOptionCell : UITableViewCell

@property(nonatomic,strong)UILabel      *titleL;
@property(nonatomic,strong)UIButton     *oneBtn;
@property(nonatomic,strong)UIButton     *twoBtn;
@property(nonatomic,strong)UIButton     *threeBtn;
@property(nonatomic,strong)UIButton     *fourBtn;
@property(nonatomic,strong)UIButton     *fiveBtn;
@property(nonatomic,strong)UILabel      *infoL;

@property(nonatomic,strong)CouponJudgeInfo  *judge;
@property(nonatomic,copy)void(^chooseBlock)(CouponJudgeInfo *judge, NSNumber *points);

+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelf;
@end

@implementation CouponJudgeOptionCell

+ (NSString *)reuseIdentify {
    return @"CouponJudgeOptionCellIdentify";
}

+ (CGFloat)heightOfSelf {
    return 80;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB(243, 243, 243);
        
        _weak(self);
        self.titleL = [[UILabel alloc] init];
        self.titleL.textColor = k_COLOR_GALLERY_F;
        self.titleL.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(12);
            make.left.equalTo(self.contentView).with.offset(18);
            make.right.equalTo(self.contentView).with.offset(-18);
            make.height.equalTo(@15);
        }];
        
        self.infoL = [[UILabel alloc] init];
        self.infoL.textColor = k_COLOR_GALLERY_F;
        self.infoL.font = [UIFont boldSystemFontOfSize:12];
        self.infoL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.infoL];
        [self.infoL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(37);
            make.right.equalTo(self.contentView).with.offset(-16);
            make.height.equalTo(@12);
            make.width.equalTo(@48);
        }];
        
        UIButton *(^starBtnBlock)() = ^(){
            UIButton *b = [[UIButton alloc] init];
            [b setBackgroundImage:[UIImage imageNamed:@"coupon_judge_start_n"] forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:@"coupon_judge_start_s"] forState:UIControlStateHighlighted];
            [b setBackgroundImage:[UIImage imageNamed:@"coupon_judge_start_s"] forState:UIControlStateSelected];
            return b;
        };
        self.oneBtn = starBtnBlock();
        [self.contentView addSubview:self.oneBtn];
        [self.oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.titleL.mas_bottom);
            make.left.equalTo(self.titleL);
            make.width.equalTo(@48);
            make.height.equalTo(@53);
        }];
        self.twoBtn = starBtnBlock();
        [self.contentView addSubview:self.twoBtn];
        [self.twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.width.height.equalTo(self.oneBtn);
            make.left.equalTo(self.oneBtn.mas_right);
        }];
        self.threeBtn = starBtnBlock();
        [self.contentView addSubview:self.threeBtn];
        [self.threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.width.height.equalTo(self.oneBtn);
            make.left.equalTo(self.twoBtn.mas_right);
        }];
        self.fourBtn = starBtnBlock();
        [self.contentView addSubview:self.fourBtn];
        [self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.width.height.equalTo(self.oneBtn);
            make.left.equalTo(self.threeBtn.mas_right);
        }];
        self.fiveBtn = starBtnBlock();
        [self.contentView addSubview:self.fiveBtn];
        [self.fiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.width.height.equalTo(self.oneBtn);
            make.left.equalTo(self.fourBtn.mas_right);
        }];
        
        [self.oneBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.oneBtn setSelected:YES];
            [self.twoBtn setSelected:NO];
            [self.threeBtn setSelected:NO];
            [self.fourBtn setSelected:NO];
            [self.fiveBtn setSelected:NO];
            self.infoL.text = @"不是很好";
            GCBlockInvoke(self.chooseBlock, self.judge, @1);
        }];
        [self.twoBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.oneBtn setSelected:YES];
            [self.twoBtn setSelected:YES];
            [self.threeBtn setSelected:NO];
            [self.fourBtn setSelected:NO];
            [self.fiveBtn setSelected:NO];
            self.infoL.text = @"还可以";
            GCBlockInvoke(self.chooseBlock, self.judge, @2);
        }];
        [self.threeBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.oneBtn setSelected:YES];
            [self.twoBtn setSelected:YES];
            [self.threeBtn setSelected:YES];
            [self.fourBtn setSelected:NO];
            [self.fiveBtn setSelected:NO];
            self.infoL.text = @"一般";
            GCBlockInvoke(self.chooseBlock, self.judge, @3);
        }];
        [self.fourBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.oneBtn setSelected:YES];
            [self.twoBtn setSelected:YES];
            [self.threeBtn setSelected:YES];
            [self.fourBtn setSelected:YES];
            [self.fiveBtn setSelected:NO];
            self.infoL.text = @"满意";
            GCBlockInvoke(self.chooseBlock, self.judge, @4);
        }];
        [self.fiveBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.oneBtn setSelected:YES];
            [self.twoBtn setSelected:YES];
            [self.threeBtn setSelected:YES];
            [self.fourBtn setSelected:YES];
            [self.fiveBtn setSelected:YES];
            self.infoL.text = @"非常满意";
            GCBlockInvoke(self.chooseBlock, self.judge, @5);
        }];
    }
    return self;
}

@end

#pragma mark - CouponJudgeResultCell
@interface CouponJudgeResultCell : UITableViewCell

@property(nonatomic,strong)UILabel      *titleL;
@property(nonatomic,strong)UIView       *fiveV;
@property(nonatomic,strong)UILabel      *fiveCountL;
@property(nonatomic,strong)UIView       *fiveColumV;
@property(nonatomic,strong)UIView       *fourV;
@property(nonatomic,strong)UILabel      *fourCountL;
@property(nonatomic,strong)UIView       *fourColumV;
@property(nonatomic,strong)UIView       *threeV;
@property(nonatomic,strong)UILabel      *threeCountL;
@property(nonatomic,strong)UIView       *threeColumV;
@property(nonatomic,strong)UIView       *twoV;
@property(nonatomic,strong)UILabel      *twoCountL;
@property(nonatomic,strong)UIView       *twoColumV;
@property(nonatomic,strong)UIView       *oneV;
@property(nonatomic,strong)UILabel      *oneCountL;
@property(nonatomic,strong)UIView       *oneColumV;
@property(nonatomic,strong)UIView       *zeroV;
@property(nonatomic,strong)UILabel      *zeroCountL;
@property(nonatomic,strong)UIView       *zeroColumV;

@property(nonatomic,strong)CouponJudgeInfo  *judge;

+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelf;
@end

@implementation CouponJudgeResultCell

+ (NSString *)reuseIdentify {
    return @"CouponJudgeResultCellIdentify";
}

+ (CGFloat)heightOfSelf {
    return 155;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB(243, 243, 243);
        
        _weak(self);
        UILabel *(^labelBlock)(UIColor *txtColor, CGFloat font, NSString *txt, NSTextAlignment alig) = ^(UIColor *txtColor, CGFloat font, NSString *txt, NSTextAlignment alig){
            UILabel *l = [[UILabel alloc] init];
            l.font = [UIFont boldSystemFontOfSize:font];
            l.textColor = txtColor;
            l.textAlignment = alig;
            l.text = txt;
            return l;
        };
        self.titleL = labelBlock(k_COLOR_GALLERY_F, 15, @"", NSTextAlignmentLeft);
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.contentView).with.offset(15);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.top.equalTo(self.contentView).with.offset(12);
            make.height.equalTo(@15);
        }];
        // 五星
        self.fiveV = [[UIView alloc] init];
        self.fiveV.backgroundColor = k_COLOR_CLEAR;
        [self.contentView addSubview:self.fiveV];
        [self.fiveV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.titleL.mas_bottom).with.offset(11);
            make.bottom.equalTo(self.contentView).with.offset(-11);
            make.left.equalTo(self.contentView).with.offset(25);
            make.width.equalTo(@(([UIScreen mainScreen].bounds.size.width - 58)/6));
        }];
        self.fiveCountL = labelBlock(k_COLOR_BLUE, 10, @"", NSTextAlignmentCenter);
        [self.fiveV addSubview:self.fiveCountL];
        [self.fiveCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerX.equalTo(self.fiveV);
            make.height.equalTo(@10);
            make.width.equalTo(self.fiveV);
            make.top.equalTo(self.fiveV);
        }];
        UILabel *fiveTL = labelBlock(k_COLOR_GALLERY_F, 10, @"5星", NSTextAlignmentCenter);
        [self.fiveV addSubview:fiveTL];
        [fiveTL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.equalTo(self.fiveV);
            make.centerX.equalTo(self.fiveV);
            make.width.equalTo(self.fiveV);
            make.height.equalTo(@10);
        }];
        self.fiveColumV = [[UIView alloc] init];
        self.fiveColumV.backgroundColor = k_COLOR_BLUE;
        [self.fiveV addSubview:self.fiveColumV];
        
        UIView *l1 = [[UIView alloc] init];
        l1.backgroundColor = RGB(197, 197, 197);
        [self.contentView addSubview:l1];
        [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.equalTo(self.fiveV);
            make.left.equalTo(self.fiveV.mas_right);
            make.width.equalTo(@1);
        }];
        // 四星
        self.fourV = [[UIView alloc] init];
        self.fourV.backgroundColor = k_COLOR_CLEAR;
        [self.contentView addSubview:self.fourV];
        [self.fourV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.width.equalTo(self.fiveV);
            make.left.equalTo(self.fiveV.mas_right).with.offset(1);
        }];
        self.fourCountL = labelBlock(k_COLOR_BLUE, 10, @"", NSTextAlignmentCenter);
        [self.fourV addSubview:self.fourCountL];
        [self.fourCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.height.equalTo(@10);
            make.top.centerX.width.equalTo(self.fourV);
        }];
        UILabel *fourTL = labelBlock(k_COLOR_GALLERY_F, 10, @"4星", NSTextAlignmentCenter);
        [self.fourV addSubview:fourTL];
        [fourTL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.centerX.width.equalTo(self.fourV);
            make.height.equalTo(@10);
        }];
        self.fourColumV = [[UIView alloc] init];
        self.fourColumV.backgroundColor = k_COLOR_BLUE;
        [self.fourV addSubview:self.fourColumV];
        
        UIView *l2 = [[UIView alloc] init];
        l2.backgroundColor = RGB(197, 197, 197);
        [self.contentView addSubview:l2];
        [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.equalTo(self.fourV);
            make.left.equalTo(self.fourV.mas_right);
            make.width.equalTo(@1);
        }];
        // 三星
        self.threeV = [[UIView alloc] init];
        self.threeV.backgroundColor = k_COLOR_CLEAR;
        [self.contentView addSubview:self.threeV];
        [self.threeV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.width.equalTo(self.fiveV);
            make.left.equalTo(self.fourV.mas_right).with.offset(1);
        }];
        self.threeCountL = labelBlock(k_COLOR_BLUE, 10, @"", NSTextAlignmentCenter);
        [self.threeV addSubview:self.threeCountL];
        [self.threeCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerX.width.top.equalTo(self.threeV);
            make.height.equalTo(@10);
        }];
        UILabel *threeTL = labelBlock(k_COLOR_GALLERY_F, 10, @"3星", NSTextAlignmentCenter);
        [self.threeV addSubview:threeTL];
        [threeTL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.centerX.width.equalTo(self.threeV);
            make.height.equalTo(@10);
        }];
        self.threeColumV = [[UIView alloc] init];
        self.threeColumV.backgroundColor = k_COLOR_BLUE;
        [self.threeV addSubview:self.threeColumV];
        
        UIView *l3 = [[UIView alloc] init];
        l3.backgroundColor = RGB(197, 197, 197);
        [self.contentView addSubview:l3];
        [l3 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.equalTo(self.threeV);
            make.left.equalTo(self.threeV.mas_right);
            make.width.equalTo(@1);
        }];
        // 二星
        self.twoV = [[UIView alloc] init];
        self.twoV.backgroundColor = k_COLOR_CLEAR;
        [self.contentView addSubview:self.twoV];
        [self.twoV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.width.equalTo(self.fiveV);
            make.left.equalTo(self.threeV.mas_right).with.offset(1);
        }];
        self.twoCountL = labelBlock(k_COLOR_BLUE, 10, @"", NSTextAlignmentCenter);
        [self.twoV addSubview:self.twoCountL];
        [self.twoCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerX.width.top.equalTo(self.twoV);
            make.height.equalTo(@10);
        }];
        UILabel *twoTL = labelBlock(k_COLOR_GALLERY_F, 10, @"2星", NSTextAlignmentCenter);
        [self.twoV addSubview:twoTL];
        [twoTL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.centerX.width.equalTo(self.twoV);
            make.height.equalTo(@10);
        }];
        self.twoColumV = [[UIView alloc] init];
        self.twoColumV.backgroundColor = k_COLOR_BLUE;
        [self.twoV addSubview:self.twoColumV];
        
        UIView *l4 = [[UIView alloc] init];
        l4.backgroundColor = RGB(197, 197, 197);
        [self.contentView addSubview:l4];
        [l4 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.equalTo(self.twoV);
            make.left.equalTo(self.twoV.mas_right);
            make.width.equalTo(@1);
        }];
        // 一星
        self.oneV = [[UIView alloc] init];
        self.oneV.backgroundColor = k_COLOR_CLEAR;
        [self.contentView addSubview:self.oneV];
        [self.oneV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.width.equalTo(self.fiveV);
            make.left.equalTo(self.twoV.mas_right).with.offset(1);
        }];
        self.oneCountL = labelBlock(k_COLOR_BLUE, 10, @"", NSTextAlignmentCenter);
        [self.oneV addSubview:self.oneCountL];
        [self.oneCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerX.width.top.equalTo(self.oneV);
            make.height.equalTo(@10);
        }];
        UILabel *oneTL = labelBlock(k_COLOR_GALLERY_F, 10, @"1星", NSTextAlignmentCenter);
        [self.oneV addSubview:oneTL];
        [oneTL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.centerX.width.equalTo(self.oneV);
            make.height.equalTo(@10);
        }];
        self.oneColumV = [[UIView alloc] init];
        self.oneColumV.backgroundColor = k_COLOR_BLUE;
        [self.oneV addSubview:self.oneColumV];
        
        UIView *l5 = [[UIView alloc] init];
        l5.backgroundColor = RGB(197, 197, 197);
        [self.contentView addSubview:l5];
        [l5 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.equalTo(self.oneV);
            make.left.equalTo(self.oneV.mas_right);
            make.width.equalTo(@1);
        }];
        // 零星
        self.zeroV = [[UIView alloc] init];
        self.zeroV.backgroundColor = k_COLOR_CLEAR;
        [self.contentView addSubview:self.zeroV];
        [self.zeroV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.width.equalTo(self.fiveV);
            make.left.equalTo(self.oneV.mas_right).with.offset(1);
        }];
        self.zeroCountL = labelBlock(k_COLOR_BLUE, 10, @"", NSTextAlignmentCenter);
        [self.zeroV addSubview:self.zeroCountL];
        [self.zeroCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerX.width.top.equalTo(self.zeroV);
            make.height.equalTo(@10);
        }];
        UILabel *zeroTL = labelBlock(k_COLOR_GALLERY_F, 10, @"0星", NSTextAlignmentCenter);
        [self.zeroV addSubview:zeroTL];
        [zeroTL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.centerX.width.equalTo(self.zeroV);
            make.height.equalTo(@10);
        }];
        self.zeroColumV = [[UIView alloc] init];
        self.zeroColumV.backgroundColor = k_COLOR_BLUE;
        [self.zeroV addSubview:self.zeroColumV];
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"judge" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        NSNumber *large = [self.judge.five integerValue] > [self.judge.four integerValue]?self.judge.five:self.judge.four;
        large = [large integerValue] > [self.judge.three integerValue]?large:self.judge.three;
        large = [large integerValue] > [self.judge.two integerValue]?large:self.judge.two;
        large = [large integerValue] > [self.judge.one integerValue]?large:self.judge.one;
        
        _weak(large);
        [self.fiveColumV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(large);
            _strong(self);
            make.bottom.equalTo(self.fiveV).with.offset(-16);
            make.centerX.equalTo(self.fiveV);
            make.width.equalTo(@10);
            NSInteger h = 0;
            if ([large integerValue] > 0) {
                h = [self.judge.five integerValue]/[large integerValue]*70;
            }
            make.height.equalTo(@(h>0?h:1));
        }];
        
        [self.fourColumV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(large);
            _strong(self);
            make.bottom.equalTo(self.fourV).with.offset(-16);
            make.centerX.equalTo(self.fourV);
            make.width.equalTo(@10);
            NSInteger h = 0;
            if ([large integerValue] > 0) {
                h = [self.judge.four integerValue]/[large integerValue]*70;
            }
            make.height.equalTo(@(h>0?h:1));
        }];
        
        
        [self.threeColumV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(large);
            _strong(self);
            make.bottom.equalTo(self.threeV).with.offset(-16);
            make.centerX.equalTo(self.threeV);
            make.width.equalTo(@10);
            NSInteger h = 0;
            if ([large integerValue] > 0) {
                h = [self.judge.three integerValue]/[large integerValue]*70;
            }
            make.height.equalTo(@(h>0?h:1));
        }];
        
        [self.twoColumV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(large);
            _strong(self);
            make.bottom.equalTo(self.twoV).with.offset(-16);
            make.centerX.equalTo(self.twoV);
            make.width.equalTo(@10);
            NSInteger h = 0;
            if ([large integerValue] > 0) {
                h = [self.judge.two integerValue]/[large integerValue]*70;
            }
            make.height.equalTo(@(h>0?h:1));
        }];
        
        [self.oneColumV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(large);
            _strong(self);
            make.bottom.equalTo(self.oneV).with.offset(-16);
            make.centerX.equalTo(self.oneV);
            make.width.equalTo(@10);
            NSInteger h = 0;
            if ([large integerValue] > 0) {
                h = [self.judge.one integerValue]/[large integerValue]*70;
            }
            make.height.equalTo(@(h>0?h:1));
        }];
        
        [self.zeroColumV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(large);
            _strong(self);
            make.bottom.equalTo(self.zeroV).with.offset(-16);
            make.centerX.equalTo(self.zeroV);
            make.width.equalTo(@10);
            NSInteger h = 0;
            if ([large integerValue] > 0) {
                h = [self.judge.zero integerValue]/[large integerValue]*70;
            }
            make.height.equalTo(@(h>0?h:1));
        }];
        
        self.fiveCountL.text = [self.judge.five stringValue];
        self.fourCountL.text = [self.judge.four stringValue];
        self.threeCountL.text = [self.judge.three stringValue];
        self.twoCountL.text = [self.judge.two stringValue];
        self.oneCountL.text = [self.judge.one stringValue];
        self.zeroCountL.text = [self.judge.zero stringValue];
        [self layoutIfNeeded];
    }];
}
@end

#pragma mark - CouponCommentCell
@interface CouponCommentCell : UITableViewCell

@property(nonatomic,strong)UIImageView      *avatarV;
@property(nonatomic,strong)UILabel          *nickNameL;
@property(nonatomic,strong)UILabel          *contentL;
@property(nonatomic,strong)UILabel          *timeL;
@property(nonatomic,strong)UIButton         *showHideBtn;

@property(nonatomic,strong)CouponCommentInfo    *comment;
@property(nonatomic,assign)BOOL             isManager;
@property(nonatomic,copy)void(^showHideBlock)(CouponCommentInfo *comment);
@property(nonatomic,copy)void(^longTapBlock)(CouponCommentInfo *comment);
+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelfWithComment:(CouponCommentInfo *)comment isManager:(BOOL)ismanager;
@end

@implementation CouponCommentCell

+ (NSString *)reuseIdentify {
    return @"CouponCommentCellIdentify";
}

+ (CGFloat)heightOfSelfWithComment:(CouponCommentInfo *)comment isManager:(BOOL)ismanager {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat textW = (ismanager?screenW-147:screenW-86);
    return 65 + [[CouponCommentCell _attributeStringOfContentWithComment:comment] boundingRectWithSize:ccs(textW, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

+ (NSAttributedString *)_attributeStringOfContentWithComment:(CouponCommentInfo *)comment {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = NSTextAlignmentLeft;
    ps.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                      NSParagraphStyleAttributeName:ps,
                                      NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                                      NSBaselineOffsetAttributeName: @0};
    NSAttributedString *ret = [[NSAttributedString alloc] initWithString:comment.content attributes:attributes];
    return ret;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB(243, 243, 243);
        
        _weak(self);
        self.avatarV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.avatarV];
        self.avatarV.layer.cornerRadius = 22;
        self.avatarV.clipsToBounds = YES;
        [self.avatarV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(15);
            make.left.equalTo(self.contentView).with.offset(18);
            make.width.height.equalTo(@44);
        }];
        
        self.nickNameL = [[UILabel alloc] init];
        self.nickNameL.textColor = k_COLOR_BLUE;
        self.nickNameL.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:self.nickNameL];
        [self.nickNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.avatarV);
            make.left.equalTo(self.avatarV.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-16);
            make.height.equalTo(@16);
        }];
        
        self.timeL = [[UILabel alloc] init];
        self.timeL.textColor = RGB(181, 181, 181);
        self.timeL.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.timeL];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.equalTo(self.contentView).with.offset(-6);
            make.left.equalTo(self.nickNameL);
            make.height.equalTo(@12);
            make.width.equalTo(@150);
        }];
        
        self.showHideBtn = [[UIButton alloc] init];
        self.showHideBtn.layer.cornerRadius = 4;
        self.showHideBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.showHideBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.showHideBlock, self.comment);
        }];
        [self.contentView addSubview:self.showHideBtn];
        
        self.contentL = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentL];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            _strong(self);
            GCBlockInvoke(self.longTapBlock, self.comment);
        }];
        [self addGestureRecognizer:longTap];
        
        [self _setupObserver];
    }
    
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"comment" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (!self.comment) {
            return;
        }
        self.nickNameL.text = self.comment.nickName;
        self.contentL.attributedText = [[self class] _attributeStringOfContentWithComment:self.comment];
        [self.avatarV sd_setImageWithURL:[APIGenerator urlOfPictureWith:44 height:44 urlString:self.comment.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.timeL.text = [self.comment.createDate dateTimeByNow];
        if ([self.comment.isCommentDeleted boolValue]) {
            self.showHideBtn.backgroundColor = k_COLOR_BLUE;
            [self.showHideBtn setTitle:@"显示" forState:UIControlStateNormal];
            [self.showHideBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        }
        else {
            self.showHideBtn.backgroundColor = RGB(97, 97, 97);
            [self.showHideBtn setTitle:@"隐藏" forState:UIControlStateNormal];
            [self.showHideBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        }
    }];
    
    [self startObserveObject:self forKeyPath:@"isManager" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.isManager) {
            if (![self.showHideBtn superview]) {
                [self.contentView addSubview:self.showHideBtn];
            }
            [self.showHideBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.top.equalTo(self.nickNameL.mas_bottom).with.offset(6);
                make.right.equalTo(self.contentView).with.offset(-17);
                make.width.equalTo(@50);
                make.height.equalTo(@26);
            }];
            [self.contentL mas_remakeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.top.equalTo(self.nickNameL.mas_bottom).with.offset(8);
                make.bottom.equalTo(self.timeL.mas_top).with.offset(-8);
                make.left.equalTo(self.nickNameL);
                make.right.equalTo(self.showHideBtn.mas_left).with.offset(-19);
            }];
        }
        else {
            [self.showHideBtn removeFromSuperview];
            [self.contentL mas_remakeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.top.equalTo(self.nickNameL.mas_bottom).with.offset(8);
                make.right.equalTo(self.contentView).with.offset(-16);
                make.left.equalTo(self.nickNameL);
                make.bottom.equalTo(self.timeL.mas_top).with.offset(-8);
            }];
        }
        
        [self layoutIfNeeded];
    }];
}

@end

@interface AroundChipInfoVC ()

@property(nonatomic,strong)UITableView      *couponTableV;
@property(nonatomic,strong)CouponCommentView    *commentV;

@property(nonatomic,strong)CouponInfo       *coupon;
@property(nonatomic,strong)NSArray          *shopArray;
@property(nonatomic,strong)NSArray          *judgeArray;
@property(nonatomic,strong)NSArray          *commentArray;
@property(nonatomic,strong)NSNumber         *currentPage;
@property(nonatomic,strong)NSNumber         *pageSize;

@property(nonatomic,strong)NSMutableArray   *judgePoints;

@end

@implementation AroundChipInfoVC

- (NSString *)umengPageName {
    return @"优惠券详情";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_AroundChipInfo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = @1;
    self.pageSize = @20;
    
    [self _setupTapGestureRecognizer];
    [self _setupObserver];
    
    if (self.isManager) {
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(_openCouponEditer:)];
        editItem.tintColor = k_COLOR_WHITE;
        self.navigationItem.rightBarButtonItem = editItem;
    }
    
    self.judgePoints = [@[] mutableCopy];
    
    [self _refreshCoupon];
    [self _refreshJudge];
    [self _refreshComment];
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self _layoutCodingViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Coding Views

- (void)_refreshJudge {
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncCouponJudgeResultWithCouponId:self.couponId remoteBlock:^(NSArray *list, NSError *error) {
        _strong(self);
        if (!error) {
            self.judgeArray = list;
        }
    }];
}
- (void)_refreshCoupon {
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncCouponWithCouponId:self.couponId cacheBlock:nil remoteBlock:^(CouponInfo *info, NSArray *shopList, NSError *error) {
        _strong(self);
        if (!error) {
            self.coupon = info;
            self.shopArray = shopList;
        }
    }];
}
- (void)_refreshComment {
    [self _loadCouponCommentAtPage:@1 pageSize:self.pageSize];
}

- (void)_loadMoreComment {
    [self _loadCouponCommentAtPage:@([self.currentPage integerValue]+1) pageSize:self.pageSize];
}
- (void)_loadCouponCommentAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncCouponCommentListWithType:CommentToShow couponId:self.couponId page:page pageSize:pageSize remoteBlock:^(NSArray *list, NSNumber *page, NSError *error) {
        _strong(self);
        if ([self.couponTableV.footer isRefreshing]) {
            [self.couponTableV.footer endRefreshing];
        }
        
        if (!error) {
            if ([page integerValue] == 1) {
                self.currentPage = page;
                self.commentArray = list;
            }
            else {
                if ([list count] > 0) {
                    self.currentPage = page;
                    NSMutableArray *tmp = [self.commentArray mutableCopy];
                    [tmp addObjectsFromArray:list];
                    self.commentArray = tmp;
                }
            }
        }
    }];
}
- (void)_loadCodingViews {
    if (self.couponTableV) {
        return;
    }
    
    self.couponTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [v registerClass:[CouponInfoCell class] forCellReuseIdentifier:[CouponInfoCell reuseIdentify]];
        [v registerClass:[CouponJudgeOptionCell class] forCellReuseIdentifier:[CouponJudgeOptionCell reuseIdentify]];
        [v registerClass:[CouponJudgeResultCell class] forCellReuseIdentifier:[CouponJudgeResultCell reuseIdentify]];
        [v registerClass:[CouponCommentCell class] forCellReuseIdentifier:[CouponCommentCell reuseIdentify]];
        
        _weak(self);
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMoreComment];
        }];
        
        [v withBlockForSectionNumber:^NSInteger(UITableView *view) {
            _strong(self);
            if ([self.judgeArray count]>0) {
                return 3;
            }
            else if (self.isManager) {
                return 3;
            }
            return 2;
        }];
        
        [v withBlockForHeaderHeight:^CGFloat(UITableView *view, NSInteger section) {
            if (section == 0) {
                return 0;
            }
            else {
                return 70;
            }
        }];
        
        [v withBlockForHeaderView:^UIView *(UITableView *view, NSInteger section) {
            _strong(self);
            if (section == 0) {
                return nil;
            }
            
            UIView *ret = [[UIView alloc] init];
            ret.backgroundColor = RGB(243, 243, 243);
            _weak(ret);
            if (section == 1 && ([self.judgeArray count] > 0||self.isManager)) {
                // 满意度调查
                UILabel *l = [[UILabel alloc] init];
                l.text = @"满意度调查";
                l.textAlignment = NSTextAlignmentCenter;
                l.textColor = k_COLOR_BLUE;
                l.font = [UIFont boldSystemFontOfSize:16];
                [ret addSubview:l];
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(ret);
                    make.centerX.equalTo(ret);
                    make.top.equalTo(ret).with.offset(22);
                    make.height.equalTo(@16);
                    make.width.equalTo(@92);
                }];
                UIView *lineLeft = [[UIView alloc] init];
                lineLeft.backgroundColor = RGB(97, 97, 97);
                [ret addSubview:lineLeft];
                _weak(l);
                [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(ret);
                    _strong(l);
                    make.centerY.equalTo(l);
                    make.left.equalTo(ret).with.offset(18);
                    make.right.equalTo(l.mas_left).with.offset(-4);
                    make.height.equalTo(@1);
                }];
                UIView *lineRight = [[UIView alloc] init];
                lineRight.backgroundColor = RGB(97, 97, 97);
                [ret addSubview:lineRight];
                [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(ret);
                    _strong(l);
                    make.centerY.equalTo(l);
                    make.height.equalTo(@1);
                    make.left.equalTo(l.mas_right).with.offset(4);
                    make.right.equalTo(ret).with.offset(-18);
                }];
                UILabel *subL = [[UILabel alloc] init];
                subL.textColor = k_COLOR_GALLERY_F;
                subL.font = [UIFont boldSystemFontOfSize:12];
                subL.textAlignment = NSTextAlignmentCenter;
                subL.text = @"参与满意度调查获得300积分";
                [ret addSubview:subL];
                [subL mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(ret);
                    _strong(l);
                    make.top.equalTo(l.mas_bottom).with.offset(4);
                    make.height.equalTo(@12);
                    make.left.equalTo(ret).with.offset(18);
                    make.right.equalTo(ret).with.offset(-18);
                }];
            }
            else if ([self.judgeArray count] <= 0 || section == 2) {
                // 精选评论
                UILabel *l = [[UILabel alloc] init];
                l.text = @"精选评论";
                l.textAlignment = NSTextAlignmentCenter;
                l.textColor = k_COLOR_BLUE;
                l.font = [UIFont boldSystemFontOfSize:16];
                [ret addSubview:l];
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(ret);
                    make.centerX.equalTo(ret);
                    make.top.equalTo(ret).with.offset(22);
                    make.height.equalTo(@16);
                    make.width.equalTo(@92);
                }];
                UIView *lineLeft = [[UIView alloc] init];
                lineLeft.backgroundColor = RGB(97, 97, 97);
                [ret addSubview:lineLeft];
                _weak(l);
                [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(ret);
                    _strong(l);
                    make.centerY.equalTo(l);
                    make.left.equalTo(ret).with.offset(18);
                    make.right.equalTo(l.mas_left).with.offset(-4);
                    make.height.equalTo(@1);
                }];
                UIView *lineRight = [[UIView alloc] init];
                lineRight.backgroundColor = RGB(97, 97, 97);
                [ret addSubview:lineRight];
                [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(ret);
                    _strong(l);
                    make.centerY.equalTo(l);
                    make.height.equalTo(@1);
                    make.left.equalTo(l.mas_right).with.offset(4);
                    make.right.equalTo(ret).with.offset(-18);
                }];
                UIButton *addCmtBtn = [[UIButton alloc] init];
                addCmtBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [addCmtBtn setImage:[UIImage imageNamed:@"coupon_cmt_btn"] forState:UIControlStateNormal];
                addCmtBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                [addCmtBtn setTitle:@"写评论" forState:UIControlStateNormal];
                [addCmtBtn setTitleColor:k_COLOR_BLUE forState:UIControlStateNormal];
                addCmtBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                [addCmtBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                    _strong(self);
                    if (![UserModel sharedModel].isNormalLogined) {
                        [SVProgressHUD showErrorWithStatus:@"请先登录"];
                        return;
                    }
                    [self _showCommentView];
                }];
                [ret addSubview:addCmtBtn];
                [addCmtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(ret);
                    _strong(l);
                    make.top.equalTo(l.mas_bottom).with.offset(4);
                    make.right.equalTo(ret).with.offset(-18);
                    make.width.equalTo(@75);
                    make.height.equalTo(@23);
                }];
            }
            
            return ret;
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            if (section == 0) {
                return 1;
            }
            if (section == 1) {
                if ([self.judgeArray count] > 0) {
                    if (self.isManager) {
                        return [self.judgeArray count] + 1;
                    }
                    else if ([UserModel sharedModel].isNormalLogined && ![[CommunityLifeModel sharedModel] hasCouponJudgedWithUserId:[UserModel sharedModel].currentNormalUser.userId couponId:self.coupon.couponId]) {
                        return [self.judgeArray count] + 1;
                    }
                    else {
                        return [self.judgeArray count];
                    }
                }
                else if (self.isManager) {
                    return 1;
                }
                else {
                    return [self.commentArray count];
                }
            }
            else if (section == 2) {
                return [self.commentArray count];
            }
            
            return 0;
        }];
        
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if (path.section == 0) {
                return [CouponInfoCell heightOfCellWithCoupon:self.coupon];
            }
            if (path.section == 1) {
                if ([self.judgeArray count]>0) {
                    if ([UserModel sharedModel].isNormalLogined && ![[CommunityLifeModel sharedModel] hasCouponJudgedWithUserId:[UserModel sharedModel].currentNormalUser.userId couponId:self.coupon.couponId] && !self.isManager) {
                        if (path.row < [self.judgeArray count]) {
                            return [CouponJudgeOptionCell heightOfSelf];
                        }
                        return 65;
                    }
                    else {
                        if (path.row < [self.judgeArray count]) {
                            return [CouponJudgeResultCell heightOfSelf];
                        }
                        return 65;
                    }
                }
                else if (self.isManager) {
                    return 65;
                }
                else {
                    CouponCommentInfo *comment = self.commentArray[path.row];
                    return [CouponCommentCell heightOfSelfWithComment:comment isManager:self.isManager];
                }
            }
            if (path.section == 2) {
                CouponCommentInfo *comment = self.commentArray[path.row];
                return [CouponCommentCell heightOfSelfWithComment:comment isManager:self.isManager];
            }
            
            return 0;
        }];
        
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            CouponCommentCell *(^commentCellBlock)() = ^(){
                CouponCommentCell *cell = [view dequeueReusableCellWithIdentifier:[CouponCommentCell reuseIdentify] forIndexPath:path];
                if (!cell) {
                    cell = [[CouponCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CouponCommentCell reuseIdentify]];
                }
                
                cell.comment = self.commentArray[path.row];
                cell.isManager = self.isManager;
                _weak(cell);
                if (self.isManager) {
                    cell.showHideBlock = ^(CouponCommentInfo *comment) {
                        if ([comment.isCommentDeleted boolValue]) {
                            [[CommunityLifeModel sharedModel] asyncCouponCommentShowWithCommentId:comment.couponCommentId remoteBlock:^(BOOL isSuccess, NSError *error) {
                                if (isSuccess) {
                                    _strong(cell);
                                    comment.isCommentDeleted = @(![comment.isCommentDeleted boolValue]);
                                    cell.comment = comment;
                                }
                            }];
                        }
                        else {
                            [[CommunityLifeModel sharedModel] asyncCouponCommentHideWithCommentId:comment.couponCommentId remoteBlock:^(BOOL isSuccess, NSError *error) {
                                if (isSuccess) {
                                    _strong(cell);
                                    comment.isCommentDeleted = @(![comment.isCommentDeleted boolValue]);
                                    cell.comment = comment;
                                }
                            }];
                        }
                    };
                }
                
                cell.longTapBlock = ^(CouponCommentInfo *comment) {
                    _strong(self);
                    _strong(cell);
                    UIMenuController *menu = (UIMenuController*)[UIMenuController sharedMenuController];
                    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyComment:)];
                    UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteComment:)];
                    if ([comment.userId integerValue] == [[UserModel sharedModel].currentNormalUser.userId integerValue]) {
                        [menu setMenuItems:@[copy, delete]];
                    }
                    else {
                        [menu setMenuItems:@[copy]];
                    }
                    menu.userInfo = @{@"Comment":comment};
                    
                    [menu setTargetRect:[cell convertRect:cell.bounds toView:self.view] inView:self.view];
                    [menu setMenuVisible:YES animated:YES];
                };
                return cell;
            };
            
            
            if (path.section == 0) {
                CouponInfoCell *cell = [view dequeueReusableCellWithIdentifier:[CouponInfoCell reuseIdentify] forIndexPath:path];
                if (!cell) {
                    cell = [[CouponInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CouponInfoCell reuseIdentify]];
                }
                
                cell.coupon = self.coupon;
                cell.getCouponBlock = ^(CouponInfo *coupon){
                    [[UserModel sharedModel] asyncAddUserCouponWithId:coupon.couponId remoteBlock:^(BOOL isSuccess, NSString *couponCode, NSString *msg, NSError *error) {
                        [SVProgressHUD showInfoWithStatus:msg];
                    }];
                };
                cell.shopAddBlock = ^(CouponInfo *coupon) {
                    _strong(self);
                    [self performSegueWithIdentifier:@"Segue_L_Coupon_Address" sender:nil];
                };
                return cell;
            }
            
            if (path.section == 1) {
                
                UITableViewCell *(^judgeAddCellBlock)() = ^(){
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.backgroundColor = RGB(243, 243, 243);
                    UIButton *submitBtn = [[UIButton alloc] init];
                    submitBtn.backgroundColor = k_COLOR_BLUE;
                    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                    submitBtn.layer.cornerRadius = 4;
                    [submitBtn setTitle:@"创建满意度调查" forState:UIControlStateNormal];
                    [submitBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
                    [submitBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                        _strong(self);
                        if (self.isManager && [UserModel sharedModel].isBusinessAdminLogined) {
                            [self performSegueWithIdentifier:@"Segue_CouponInfo_CouponJudgeEdit" sender:nil];
                        }
                    }];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell addSubview:submitBtn];
                    _weak(cell);
                    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        _strong(cell);
                        _strong(self);
                        make.left.equalTo(cell.contentView).with.offset(18);
                        make.top.equalTo(cell.contentView).with.offset(11);
                        make.width.equalTo(@(V_W_(self.view)-36));
                        make.height.equalTo(@43);
                    }];
                    return cell;
                };
                
                if ([self.judgeArray count] > 0) {
                    if (path.row < [self.judgeArray count]) {
                        if ([UserModel sharedModel].isNormalLogined && ![[CommunityLifeModel sharedModel] hasCouponJudgedWithUserId:[UserModel sharedModel].currentNormalUser.userId couponId:self.coupon.couponId] && !self.isManager) {
                            CouponJudgeOptionCell *cell = [view dequeueReusableCellWithIdentifier:[CouponJudgeOptionCell reuseIdentify] forIndexPath:path];
                            if (!cell) {
                                cell = [[CouponJudgeOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CouponJudgeOptionCell reuseIdentify]];
                            }
                            cell.judge = self.judgeArray[path.row];
                            cell.titleL.text = [NSString stringWithFormat:@"%ld.%@",(long)(path.row+1), cell.judge.title];
                            cell.chooseBlock = ^(CouponJudgeInfo *judge, NSNumber *points){
                                _strong(self);
                                if (![UserModel sharedModel].isNormalLogined) {
                                    [SVProgressHUD showErrorWithStatus:@"请先登录"];
                                    return;
                                }
                                for (NSInteger i = 0; i < [self.judgePoints count]; i++) {
                                    if ([[self.judgePoints[i] objectForKey:@"QuestionId"] integerValue] == [judge.questionId integerValue]) {
                                        [self.judgePoints[i] setObject:points forKey:@"Points"];
                                    }
                                }
                            };
                            return cell;
                        }
                        else {
                            CouponJudgeResultCell *cell = [view dequeueReusableCellWithIdentifier:[CouponJudgeResultCell reuseIdentify] forIndexPath:path];
                            if (!cell) {
                                cell = [[CouponJudgeResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CouponJudgeResultCell reuseIdentify]];
                            }
                            cell.judge = self.judgeArray[path.row];
                            cell.titleL.text = [NSString stringWithFormat:@"%ld.%@",(long)(path.row+1), cell.judge.title];
                            return cell;
                        }
                    }
                    else {
                        if (self.isManager) {
                            return judgeAddCellBlock();
                        }
                        else {
                            if ([UserModel sharedModel].isNormalLogined && ![[CommunityLifeModel sharedModel] hasCouponJudgedWithUserId:[UserModel sharedModel].currentNormalUser.userId couponId:self.coupon.couponId]) {
                                UITableViewCell *cell = [[UITableViewCell alloc] init];
                                cell.backgroundColor = RGB(243, 243, 243);
                                UIButton *submitBtn = [[UIButton alloc] init];
                                submitBtn.backgroundColor = k_COLOR_BLUE;
                                submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                                submitBtn.layer.cornerRadius = 4;
                                [submitBtn setTitle:@"提交调查赢积分" forState:UIControlStateNormal];
                                [submitBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
                                [submitBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                                    _strong(self);
                                    if (![UserModel sharedModel].isNormalLogined) {
                                        [SVProgressHUD showErrorWithStatus:@"请先登录"];
                                        return;
                                    }
                                    BOOL has = NO;
                                    for (NSDictionary *dic in self.judgePoints) {
                                        if ([[dic objectForKey:@"Points"] integerValue] != 0) {
                                            has = YES;
                                            break;
                                        }
                                    }
                                    if (!has) {
                                        return;
                                    }
                                    
                                    [[CommunityLifeModel sharedModel] asyncCouponJudgeSubmitWithArray:self.judgePoints couponId:self.couponId remoteBlock:^(BOOL isSuccess, NSError *error) {
                                        _strong(self);
                                        if (!error) {
                                            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                                            [self _refreshJudge];
                                            [UserPointHandler addUserPointWithType:CouponJudgeAdd showInfo:NO];
                                        }
                                        else {
                                            [SVProgressHUD showErrorWithStatus:error.domain];
                                        }
                                    }];
                                }];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                [cell.contentView addSubview:submitBtn];
                                _weak(cell);
                                [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    _strong(self);
                                    _strong(cell);
                                    make.left.equalTo(cell.contentView).with.offset(18);
                                    make.top.equalTo(cell.contentView).with.offset(11);
                                    make.width.equalTo(@(V_W_(self.view)-36));
                                    make.height.equalTo(@43);
                                }];
                                
                                return cell;
                            }
                            return nil;
                        }
                    }
                }
                else if (self.isManager){
                    return judgeAddCellBlock();
                }
                else {
                    return commentCellBlock();
                }
            }
            if (path.section == 2) {
                return commentCellBlock();
            }
            
            return nil;
        }];
        v;
    });
    
    _weak(self);
    if (!self.commentV) {
        self.commentV = ({
            CouponCommentView* view = [[CouponCommentView alloc] init];
            [view withSubmitAction:^(NSString *commentContent, NSNumber *couponId) {
                _strong(self);
                [self.commentV resignFirstResponder];
                [self.commentV clearContent];
                [[CommunityLifeModel sharedModel] asyncCouponCommentAddWithCouponId:couponId content:commentContent remoteBlock:^(BOOL isSucces, CouponCommentInfo *info, NSError *error) {
                    _strong(self);
                    if (isSucces) {
                        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                        [UserPointHandler addUserPointWithType:CouponCommentAdd showInfo:NO];
                        [self _refreshComment];
                        return;
                    }
                    [SVProgressHUD showErrorWithStatus:error.domain];
                }];
            }];
            view;
        });
        self.commentV.hidden = YES;
    }
    
}

- (void)_layoutCodingViews {
    if ([self.couponTableV superview]) {
        return;
    }
    
    _weak(self);
    UIView *topTmp = [[UIView alloc] init];
    topTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:topTmp];
    [topTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(self.topLayoutGuide.length));
    }];
    UIView *botTmp = [[UIView alloc] init];
    botTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:botTmp];
    [botTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(self.bottomLayoutGuide.length));
    }];
    _weak(topTmp);
    _weak(botTmp);
    [self.view addSubview:self.couponTableV];
    [self.couponTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(topTmp);
        _strong(botTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];
    
    if (![self.commentV superview]) {
        [self.view addSubview:self.commentV];
        [self.commentV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@50);
            make.bottom.equalTo(self.view);
        }];
    }
}

- (void)_showCommentView {
    if (![self.commentV isHidden]) {
        return;
    }
    self.commentV.coupon = self.coupon;
    _weak(self);
    [self.commentV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view);
    }];
    self.commentV.hidden = NO;
    [self.commentV becomeFirstResponder];
}

- (void)_setupTapGestureRecognizer {
    _weak(self);
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        _strong(self);
        
        if (!CGRectContainsPoint(self.commentV.frame, [touch locationInView:self.view])) {
            [self.commentV resignFirstResponder];
        }
        return NO;
    }];
    [self.view addGestureRecognizer:tap];
}

- (void)copyComment:(id)sender {
    NSDictionary *userInfo = [sender userInfo];
    CouponCommentInfo *comment = (CouponCommentInfo*)[userInfo objectForKey:@"Comment"];
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:comment.content];
}

- (void)deleteComment:(id)sender {
    _weak(self);
    NSDictionary *userInfo = [sender userInfo];
    CouponCommentInfo *comment = (CouponCommentInfo*)[userInfo objectForKey:@"Comment"];
    if ([comment.userId integerValue] == [[UserModel sharedModel].currentNormalUser.userId integerValue]) {
        [[CommunityLifeModel sharedModel] asyncCouponCommentDeleteWithId:comment.couponCommentId remoteBlock:^(BOOL isSuccess, NSError *error) {
            _strong(self);
            if (!error) {
                [self _refreshComment];
            }
            else {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }
        }];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_L_Coupon_Address"]) {
        AroundChipAddressListVC *vc = (AroundChipAddressListVC*)segue.destinationViewController;
        vc.shopArray = self.shopArray;
        vc.logoUrlStr = self.coupon.logo;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_CouponInfo_CouponEditer"]) {
        ShopCouponEditVC *vc = (ShopCouponEditVC*)segue.destinationViewController;
        vc.couponId = self.couponId;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_CouponInfo_CouponJudgeEdit"]) {
        ((ShopCouponJudgeEditVC*)segue.destinationViewController).couponId = self.couponId;
    }
}

- (void)unwindSegue:(UIStoryboardSegue*)segue {
    if ([segue.identifier isEqualToString:@"UnSegue_ShopCouponJudgeEdit"]) {
        [self _refreshJudge];
    }
}

- (void)_openCouponEditer:(id)sender {
    [self performSegueWithIdentifier:@"Segue_CouponInfo_CouponEditer" sender:nil];
}


#pragma mark - private

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"coupon" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
//        [self.couponTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.couponTableV reloadData];
    }];
    
    [self startObserveObject:self forKeyPath:@"judgeArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.couponTableV reloadData];
        if ([self.judgeArray count] > 0 && [UserModel sharedModel].isNormalLogined) {
            [self.judgePoints removeAllObjects];
            for (CouponJudgeInfo *judge in self.judgeArray) {
                [self.judgePoints addObject:[@{@"QuestionId":judge.questionId,@"Points":@0, @"UserId":[UserModel sharedModel].currentNormalUser.userId} mutableCopy]];
            }
        }
//        [self.couponTableV reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,2)] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [self startObserveObject:self forKeyPath:@"commentArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.couponTableV reloadData];
//        [self.couponTableV reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,2)] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [self addObserverForNotificationName:UIKeyboardWillShowNotification usingBlock:^(NSNotification *noti) {
        _strong(self);
        NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView animateWithDuration:[duration doubleValue] delay:0.0f options:[curve integerValue]<<16 animations:^(){
            [self.commentV mas_remakeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                CGRect keyboardBounds = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                CGFloat keyboardHeight = keyboardBounds.size.height;
                make.left.right.equalTo(self.view);
                make.height.equalTo(@50);
                make.bottom.equalTo(self.view).with.offset(keyboardHeight<=self.bottomLayoutGuide.length?(-self.bottomLayoutGuide.length):(-keyboardHeight));
            }];
            [self.view layoutIfNeeded];
        } completion:nil];
    }];
    
    [self addObserverForNotificationName:UIKeyboardWillHideNotification usingBlock:^(NSNotification *noti) {
        _strong(self);
        NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        self.commentV.coupon = nil;
        
        [UIView animateWithDuration:[duration doubleValue] delay:0.0f options:[curve integerValue]<<16 animations:^(){
            [self.commentV mas_remakeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.left.right.equalTo(self.view);
                make.height.equalTo(@50);
                make.bottom.equalTo(self.view);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished){
            _strong(self);
            [self.commentV setHidden:YES];
        }];
    }];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}
@end
