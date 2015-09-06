//
//  PropertyPayVC.m
//  Sunflower
//
//  Created by makewei on 15/6/28.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyPayVC.h"
#import "Payment.h"
#import "MKWWeiPayHandler.h"
#import "MKWAlipayHandler.h"
#import "MKWWebVC.h"

@interface PaymentTableCell : UITableViewCell

@property(nonatomic,strong)UIImageView  *iconV;
@property(nonatomic,strong)UILabel      *nameL;
@property(nonatomic,strong)UILabel      *priceTitleL;
@property(nonatomic,strong)UILabel      *priceL;

@property(nonatomic,strong)PaymentInfo  *payment;

+ (NSString *)reuseIdentify;

@end

@implementation PaymentTableCell

+ (NSString *)reuseIdentify {
    return @"PaymentTableCellIdentify";
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
        
        self.nameL = [[UILabel alloc] init];
        self.nameL.textColor = k_COLOR_GALLERY_F;
        self.nameL.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(28);
            make.left.equalTo(self.iconV.mas_right).with.offset(22);
            make.right.equalTo(self.contentView).with.offset(-18);
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
            self.nameL.text = [NSString stringWithFormat:@"%@物业费", nameTime];
            self.priceL.textColor = k_COLOR_BLUE;
        }
        // ChargeWarm
        if ([self.payment.chargeType integerValue] == 2) {
            self.iconV.image = [UIImage imageNamed:@"charge_warm_icon"];
            self.nameL.text = [NSString stringWithFormat:@"%@取暖费", nameTime];
            self.priceL.textColor = k_COLOR_RED;
        }
        // ChargeClean
        if ([self.payment.chargeType integerValue] == 3) {
            self.iconV.image = [UIImage imageNamed:@"charge_clean_icon"];
            self.nameL.text = [NSString stringWithFormat:@"%@卫生费", nameTime];
            self.priceL.textColor = k_COLOR_GREEN;
        }
        // ChargePark
        if ([self.payment.chargeType integerValue] == 4) {
            self.iconV.image = [UIImage imageNamed:@"charge_park_icon"];
            self.nameL.text = [NSString stringWithFormat:@"%@停车费", nameTime];
            self.priceL.textColor = k_COLOR_YELLOW;
        }
        self.priceL.text = [NSString stringWithFormat:@"%@元", self.payment.chargePrice];
    }];
}

@end

@interface PayActionTableCell : UITableViewCell

@property(nonatomic,strong)UILabel      *priceL;
@property(nonatomic,strong)UILabel      *countL;

@property(nonatomic,strong)NSString     *orderNum;
@property(nonatomic,strong)NSArray      *paymentList;
@property(nonatomic,copy)void(^PayAction)(NSNumber *type, NSNumber *price);


+ (NSString *)reuseIdentify;
@end

@implementation PayActionTableCell

+ (NSString *)reuseIdentify {
    return @"PayActionTableCellIdentify";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _weak(self);
        self.countL = [[UILabel alloc] init];
        self.priceL = [[UILabel alloc] init];
        self.priceL.textAlignment = NSTextAlignmentRight;
        
        UIButton *(^paybtnBlock)(UIColor *bgColor, NSString *title, NSString *img) = ^(UIColor *bgColor, NSString *title, NSString *img) {
            UIButton *b = [[UIButton alloc] init];
            b.backgroundColor = bgColor;
            b.layer.cornerRadius = 4;
            [b setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
            [b setTitle:title forState:UIControlStateNormal];
            b.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [b setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
            return b;
        };
        
        UIButton *WXPayBtn = paybtnBlock(RGB(60, 177, 88), @"微信支付", @"wxpay_icon");
        UIButton *ALPayBtn = paybtnBlock(RGB(242, 148, 40), @"支付宝支付", @"alpay_icon");
        UIButton *YBPayBtn = paybtnBlock(RGB(3, 95, 137), @"银行卡支付", @"ybpay_icon");
        
        [self.contentView addSubview:self.countL];
        [self.countL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(19);
            make.left.equalTo(self.contentView).with.offset(22);
            make.height.equalTo(@12);
            make.right.equalTo(self.contentView.mas_centerX);
        }];
        
        [self.contentView addSubview:self.priceL];
        [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.equalTo(self.countL);
            make.right.equalTo(self.contentView).with.offset(-22);
            make.left.equalTo(self.contentView.mas_centerX);
            make.height.equalTo(@16);
        }];
        
        [self.contentView addSubview:WXPayBtn];
        [WXPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.countL.mas_bottom).with.offset(27);
            make.left.equalTo(self.contentView).with.offset(15);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.equalTo(@43);
        }];
        [WXPayBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self _payWithType:@1];
        }];
        
        _weak(WXPayBtn);
        [self.contentView addSubview:ALPayBtn];
        [ALPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(WXPayBtn);
            make.top.equalTo(WXPayBtn.mas_bottom).with.offset(10);
            make.left.right.height.equalTo(WXPayBtn);
        }];
        [ALPayBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self _payWithType:@2];
        }];
        
        _weak(ALPayBtn);
        [self.contentView addSubview:YBPayBtn];
        [YBPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(ALPayBtn);
            make.top.equalTo(ALPayBtn.mas_bottom).with.offset(10);
            make.left.right.height.equalTo(ALPayBtn);
        }];
        [YBPayBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self _payWithType:@3];
        }];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"paymentList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        
        if ([self.paymentList count] <= 0) {
            return;
        }
        UIColor *priceColor = k_COLOR_BLUE;
        PaymentInfo *pay = [self.paymentList objectAtIndex:0];
        if ([pay.chargeType integerValue] == 1) {
            priceColor = k_COLOR_BLUE;
        }
        // ChargeWarm
        if ([pay.chargeType integerValue] == 2) {
            priceColor = k_COLOR_RED;
        }
        // ChargeClean
        if ([pay.chargeType integerValue] == 3) {
            priceColor = k_COLOR_GREEN;
        }
        // ChargePark
        if ([pay.chargeType integerValue] == 4) {
            priceColor = k_COLOR_YELLOW;
        }
        
        NSNumber *totalPrice = @0.0;
        for (PaymentInfo *payment in self.paymentList) {
            totalPrice = @([totalPrice floatValue] + [payment.chargePrice floatValue]);
        }
        
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        ps.alignment = NSTextAlignmentLeft;
        ps.lineSpacing = 1;
        NSDictionary *normalattributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                          NSParagraphStyleAttributeName:ps,
                                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                                          NSBaselineOffsetAttributeName: @0};
        
        NSDictionary *countattributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                            NSParagraphStyleAttributeName:ps,
                                            NSForegroundColorAttributeName:priceColor,
                                            NSBaselineOffsetAttributeName: @0};
        NSMutableAttributedString *countStr= [[NSMutableAttributedString alloc] initWithString:@"共" attributes:normalattributes];
        [countStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)self.paymentList.count] attributes:countattributes]];
        [countStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"笔缴费" attributes:normalattributes]];
        
        self.countL.attributedText = countStr;
        
        NSMutableParagraphStyle *ps1 = [[NSMutableParagraphStyle alloc] init];
        ps1.lineSpacing = 1;
        ps1.alignment = NSTextAlignmentRight;
        NSDictionary *npriceattributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                           NSParagraphStyleAttributeName:ps1,
                                           NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                                           NSBaselineOffsetAttributeName: @0};
        NSDictionary *priceattributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                          NSParagraphStyleAttributeName:ps1,
                                          NSForegroundColorAttributeName:priceColor,
                                          NSBaselineOffsetAttributeName: @0};
        NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:@"总计：" attributes:npriceattributes];
        [priceStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", totalPrice] attributes:priceattributes]];
        
        self.priceL.attributedText = priceStr;
    }];
}

- (void)_payWithType:(NSNumber *)type {
    if ([self.paymentList count] <= 0) {
        [SVProgressHUD showErrorWithStatus:@"无缴费项目"];
        return;
    }
    
    NSNumber *totalPrice = @0.0;
    for (PaymentInfo *payment in self.paymentList) {
        totalPrice = @([totalPrice floatValue] + [payment.chargePrice floatValue]);
    }
    
    GCBlockInvoke(self.PayAction, type, totalPrice);
}

@end

@interface PropertyPayVC()

@property(nonatomic,strong)UITableView      *payTableV;

@end

@implementation PropertyPayVC

- (NSString *)umengPageName {
    return @"确认缴费";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_PropertyPay";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
}
- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
    FixesViewDidLayoutSubviewsiOS7Error;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_Pay_Web"]) {
        MKWWebVC *vc = (MKWWebVC*)segue.destinationViewController;
        vc.url = [NSURL URLWithString:sender];
        vc.naviTitle = @"银行卡支付";
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (self.payTableV) {
        return;
    }
    
    self.payTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [v registerClass:[PaymentTableCell class] forCellReuseIdentifier:[PaymentTableCell reuseIdentify]];
        [v registerClass:[PayActionTableCell class] forCellReuseIdentifier:[PayActionTableCell reuseIdentify]];
        
        _weak(self);
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.paymentList count] + 1;
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if (path.row < self.paymentList.count) {
                return  97;
            }
            else {
                return 225;
            }
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if (path.row < self.paymentList.count) {
                PaymentTableCell *cell = [view dequeueReusableCellWithIdentifier:[PaymentTableCell reuseIdentify] forIndexPath:path];
                if (!cell) {
                    cell = [[PaymentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PaymentTableCell reuseIdentify]];
                }
                
                cell.payment = self.paymentList[path.row];
                return cell;
            }
            else {
                PayActionTableCell *cell = [view dequeueReusableCellWithIdentifier:[PayActionTableCell reuseIdentify] forIndexPath:path];
                if (!cell) {
                    cell = [[PayActionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PayActionTableCell reuseIdentify]];
                }
                
                cell.paymentList = self.paymentList;
                cell.PayAction = ^(NSNumber *type, NSNumber *price){
                    _strong(self);
                    NSString *title = @"向日葵物业缴费";
                    NSMutableString *body = [@"" mutableCopy];
                    for (PaymentInfo *payment in self.paymentList) {
                        NSString *nameTime = @"";
                        if ([payment.type integerValue] == 1) {
                            nameTime = [payment.chargeDate dateTimeYearMonth];
                        }
                        if ([payment.type integerValue] == 2) {
                            NSNumber *month = [payment.chargeDate dateTimeMonthNumber];
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
                            nameTime = [NSString stringWithFormat:@"%@%@", [payment.chargeDate dateTimeYear], season];
                        }
                        if ([payment.type integerValue] == 3) {
                            nameTime = [payment.chargeDate dateTimeYear];
                        }
                        
                        // ChargeProperty
                        if ([payment.chargeType integerValue] == 1) {
                            [body appendFormat:@"%@物业费", nameTime];
                        }
                        // ChargeWarm
                        if ([payment.chargeType integerValue] == 2) {
                            [body appendFormat:@"%@取暖费", nameTime];
                        }
                        // ChargeClean
                        if ([payment.chargeType integerValue] == 3) {
                            [body appendFormat:@"%@卫生费", nameTime];
                        }
                        // ChargePark
                        if ([payment.chargeType integerValue] == 4) {
                            [body appendFormat:@"%@停车费", nameTime];
                        }
                    }
                    
                    if ([type integerValue] == 1) {
                        //WX
                        [MKWWeiPayHandler payWithOrderNum:self.orderNum name:body price:price failed:^(NSString *msg) {
                            [SVProgressHUD showErrorWithStatus:msg];
                        }];
                    }
                    if ([type integerValue] == 2) {
                        //AL
                        AliPayProduct *product = [[AliPayProduct alloc] init];
                        product.orderId = self.orderNum;
                        product.body = body;
                        product.price = [price floatValue];
                        product.subject = title;
                        [MKWAlipayHandler payOrderWithProduct:product];
                    }
                    if ([type integerValue] == 3) {
                        //YB
                        [self performSegueWithIdentifier:@"Segue_Pay_Web" sender:[NSString stringWithFormat:@"http://210.73.220.102/ybpay/pay.aspx?ordernum=%@&amount=%@", self.orderNum, price]];
                    }
                };
                return cell;
            }
        }];
        
        [v withBlockForHeaderHeight:^CGFloat(UITableView *view, NSInteger section) {
            return 65;
        }];
        [v withBlockForHeaderView:^UIView *(UITableView *view, NSInteger section) {
            _strong(self);
            UIView *ret = [[UIView alloc] init];
            ret.backgroundColor = RGB(243, 243, 243);
            UILabel *titleL = [[UILabel alloc] init];
            titleL.textColor = k_COLOR_GALLERY_F;
            titleL.text = @"订单号：";
            titleL.font = [UIFont boldSystemFontOfSize:12];
            [ret addSubview:titleL];
            _weak(ret);
            [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(ret);
                make.top.equalTo(ret).with.offset(14);
                make.left.equalTo(ret).with.offset(20);
                make.right.equalTo(ret).with.offset(-20);
                make.height.equalTo(@12);
            }];
            
            UILabel *orderL = [[UILabel alloc] init];
            orderL.textColor = k_COLOR_GALLERY_F;
            orderL.text = self.orderNum;
            orderL.font = [UIFont boldSystemFontOfSize:15];
            [ret addSubview:orderL];
            _weak(titleL);
            [orderL mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(titleL);
                make.top.equalTo(titleL.mas_bottom).with.offset(10);
                make.left.right.equalTo(titleL);
                make.height.equalTo(@15);
            }];
            return ret;
        }];
        v;
    });
}

- (void)_layoutCodingViews {
    if ([self.payTableV superview]) {
        return;
    }
    
    _weak(self);
    UIView *topTmp = [[UIView alloc] init];
    topTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:topTmp];
    [topTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.equalTo(self.view);
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
    [self.view addSubview:self.payTableV];
    [self.payTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(botTmp);
        _strong(topTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];
}

- (void)_setupObserver {
    _weak(self);
    [self addObserverForNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_SUCCESS usingBlock:^(NSNotification *notification) {
        GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"缴费成功" andMessage:nil];
        [alert setCancelButtonWithTitle:@"好的" actionBlock:^{
            _strong(self);
            [self performSegueWithIdentifier:@"UnSegue_PropertyPay" sender:nil];
        }];
        [alert show];
        
    }];
    
    [self addObserverForNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_FAILED usingBlock:^(NSNotification *notification) {
        GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"缴费失败" andMessage:@"请检查网络"];
        [alert setCancelButtonWithTitle:@"好的" actionBlock:nil];
        [alert show];
    }];
}

@end
