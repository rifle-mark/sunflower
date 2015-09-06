//
//  PropertyPayListVC.m
//  Sunflower
//
//  Created by makewei on 15/6/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyPayListVC.h"
#import "PropertyPayVC.h"
#import "PropertyPayCell.h"

#import "PropertyServiceModel.h"

#import "MKWWeiPayHandler.h"
#import "MKWAlipayHandler.h"

@interface PropertyPayTotalCell : UITableViewCell

@property(nonatomic,strong)UILabel      *infoL;
@property(nonatomic,strong)UIButton     *payBtn;
@property(nonatomic,strong)NSArray      *paymentList;

@property(nonatomic,copy)void(^payBlock)();

+ (NSString *)reuseIdentify;

@end

@implementation PropertyPayTotalCell

+ (NSString *)reuseIdentify {
    return @"PropertyPayTotalCellIdentify";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _weak(self);
        self.infoL = [[UILabel alloc] init];
        self.payBtn = [[UIButton alloc] init];
        self.payBtn.layer.cornerRadius = 4;
        [self.payBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [self.payBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        self.payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.payBtn setTitle:@"全部缴纳" forState:UIControlStateNormal];
        [self.payBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.payBlock);
        }];
        
        [self.contentView addSubview:self.payBtn];
        [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(6);
            make.right.equalTo(self.contentView).with.offset(-14);
            make.width.equalTo(@116);
            make.height.equalTo(@36);
        }];
        
        [self.contentView addSubview:self.infoL];
        [self.infoL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.payBtn);
            make.right.equalTo(self.payBtn.mas_left).with.offset(-5);
            make.left.equalTo(@18);
            make.height.equalTo(@17);
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
            [self setHidden:YES];
            return;
        }
        UIColor *priceColor = k_COLOR_BLUE;
        if ([((PaymentInfo*)self.paymentList[0]).chargeType integerValue] == 1) {
            priceColor = k_COLOR_BLUE;
            self.payBtn.backgroundColor = k_COLOR_BLUE;
        }
        if ([((PaymentInfo*)self.paymentList[0]).chargeType integerValue] == 2) {
            priceColor = k_COLOR_RED;
            self.payBtn.backgroundColor = k_COLOR_RED;
        }
        if ([((PaymentInfo*)self.paymentList[0]).chargeType integerValue] == 3) {
            priceColor = k_COLOR_GREEN;
            self.payBtn.backgroundColor = k_COLOR_GREEN;
        }
        if ([((PaymentInfo*)self.paymentList[0]).chargeType integerValue] == 4) {
            priceColor = k_COLOR_YELLOW;
            self.payBtn.backgroundColor = k_COLOR_YELLOW;
        }
        
        double totalPrice = 0;
        for (PaymentInfo *pay in self.paymentList) {
            totalPrice += [pay.chargePrice doubleValue];
        }
        NSNumber *price = @(totalPrice);
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        NSMutableAttributedString *infoStr = [[NSMutableAttributedString alloc] init];
        [infoStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"共" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:k_COLOR_GALLERY_F, NSParagraphStyleAttributeName:ps}]];
        [infoStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)[self.paymentList count]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:priceColor, NSParagraphStyleAttributeName:ps}]];
        [infoStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"次未缴记录  总计：" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:k_COLOR_GALLERY_F, NSParagraphStyleAttributeName:ps}]];
        [infoStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", price] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:priceColor, NSParagraphStyleAttributeName:ps}]];
        
        self.infoL.attributedText = infoStr;
    }];
}

@end

@interface PropertyPayListVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;
@property(nonatomic,strong)UIView           *typeSelectV;
@property(nonatomic,strong)UIButton         *parkBtn;
@property(nonatomic,strong)UIButton         *cleanBtn;
@property(nonatomic,strong)UIButton         *warmBtn;
@property(nonatomic,strong)UIButton         *propertyBtn;
@property(nonatomic,strong)UIView           *paySelectV;
@property(nonatomic,strong)UIButton         *notPayBtn;
@property(nonatomic,strong)UIButton         *hasPayBtn;
@property(nonatomic,strong)UITableView      *paymentTableV;

@property(nonatomic,strong)NSArray          *paymentList;
@end

@implementation PropertyPayListVC

- (NSString *)umengPageName {
    return @"物业缴费列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_PropertyPayList";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupObserver];
    
    [self.paymentTableV.header beginRefreshing];
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
    if ([segue.identifier isEqualToString:@"Segue_PaymentList_Pay"]) {
        PropertyPayVC *vc = (PropertyPayVC*)segue.destinationViewController;
        NSDictionary *info = (NSDictionary*)sender;
        vc.paymentList = [info objectForKey:@"paymentList"];
        vc.orderNum = [info objectForKey:@"orderNum"];
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    _weak(self);
    if (!self.typeSelectV) {
        self.typeSelectV = [[UIView alloc] init];
        self.typeSelectV.backgroundColor = RGB(243, 243, 243);
    }
    
    UIButton *(^typeSelectBtnBlock)(NSString *bg, NSString *hbg, NSString *sbg, NSString *title, PropertyChargeType type) = ^(NSString *bg, NSString *hbg, NSString *sbg, NSString *title,PropertyChargeType type){
        UIButton *b = [[UIButton alloc] init];
        
        [b setImage:[UIImage imageNamed:bg] forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:(hbg?hbg:bg)] forState:UIControlStateHighlighted];
        [b setImage:[UIImage imageNamed:(sbg?sbg:bg)] forState:UIControlStateSelected];
        b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        b.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [b setTitle:title forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [b setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [b startObserveObject:b forKeyPath:@"selected" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
            NSLog(@"type btn selected changed");
        }];
        
        _weak(b);
        [b addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(b);
            _strong(self);
            if ([b isSelected]) {
                return;
            }
            [b setSelected:YES];
            if (![b isEqual:self.propertyBtn]) {
                [self.propertyBtn setSelected:NO];
            }
            if (![b isEqual:self.warmBtn]) {
                [self.warmBtn setSelected:NO];
            }
            if (![b isEqual:self.cleanBtn]) {
                [self.cleanBtn setSelected:NO];
            }
            if (![b isEqual:self.parkBtn]) {
                [self.parkBtn setSelected:NO];
            }
            
            [self.notPayBtn setSelected:YES];
            [self.hasPayBtn setSelected:NO];
            self.type = type;
            
            self.paymentList = @[];
            [self.paymentTableV.header beginRefreshing];
        }];
        return b;
    };
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    __block NSNumber *margin = @(screenWidth==320?4:(screenWidth-312)/5);
    __block NSNumber *sperate = @(screenWidth==320?0:(screenWidth-312)/5);
    if (!self.propertyBtn) {
        self.propertyBtn = typeSelectBtnBlock(@"charge_property_btn_n", @"charge_property_btn_s", @"charge_property_btn_s", @"物业费", ChargeProperty);
        [self.typeSelectV addSubview:self.propertyBtn];
        [self.propertyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.typeSelectV).with.offset(18);
            make.left.equalTo(self.typeSelectV).with.offset([margin floatValue]);
            make.width.equalTo(@78);
            make.height.equalTo(@33);
        }];
    }
    if (!self.warmBtn) {
        self.warmBtn = typeSelectBtnBlock(@"charge_warm_btn_n", @"charge_warm_btn_s", @"charge_warm_btn_s", @"采暖费", ChargeWarm);
        [self.typeSelectV addSubview:self.warmBtn];
        [self.warmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.propertyBtn);
            make.left.equalTo(self.propertyBtn.mas_right).with.offset([sperate floatValue]);
            make.width.height.equalTo(self.propertyBtn);
        }];
    }
    if (!self.cleanBtn) {
        self.cleanBtn = typeSelectBtnBlock(@"charge_clean_btn_n", @"charge_clean_btn_s", @"charge_clean_btn_s", @"卫生费", ChargeClean);
        [self.typeSelectV addSubview:self.cleanBtn];
        [self.cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.propertyBtn);
            make.left.equalTo(self.warmBtn.mas_right).with.offset([sperate floatValue]);
            make.width.height.equalTo(self.propertyBtn);
        }];
    }
    if (!self.parkBtn) {
        self.parkBtn = typeSelectBtnBlock(@"charge_park_btn_n", @"charge_park_btn_s", @"charge_park_btn_s", @"停车费", ChargePark);
        [self.typeSelectV addSubview:self.parkBtn];
        [self.parkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.propertyBtn);
            make.left.equalTo(self.cleanBtn.mas_right).with.offset([sperate floatValue]);
            make.width.height.equalTo(self.propertyBtn);
        }];
    }
    
    if (!self.paySelectV) {
        self.paySelectV = [[UIView alloc] init];
        self.paySelectV.backgroundColor = k_COLOR_CLEAR;
    }
    if (!self.notPayBtn) {
        self.notPayBtn = [[UIButton alloc] init];
        [self.notPayBtn setBackgroundImage:[UIImage imageNamed:@"charge_nopay_btn"] forState:UIControlStateNormal];
        [self.notPayBtn setBackgroundImage:[UIImage imageNamed:@"charge_nopay_btn_s"] forState:UIControlStateSelected];
        self.notPayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.notPayBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateSelected];
        [self.notPayBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [self.notPayBtn setTitle:@"未缴纳" forState:UIControlStateNormal];
        [self.notPayBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if (self.notPayBtn.isSelected) {
                return;
            }
            
            [self.notPayBtn setSelected:YES];
            [self.hasPayBtn setSelected:NO];
            
            self.paymentList = @[];
            [self.paymentTableV.header beginRefreshing];
        }];
        [self.paySelectV addSubview:self.notPayBtn];
        [self.notPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.paySelectV).with.offset(14);
            make.right.equalTo(self.paySelectV.mas_centerX);
            make.top.equalTo(self.paySelectV).with.offset(10);
            make.height.equalTo(@32);
        }];

    }
    if (!self.hasPayBtn) {
        self.hasPayBtn = [[UIButton alloc] init];
        [self.hasPayBtn setBackgroundImage:[UIImage imageNamed:@"charge_haspay_btn"] forState:UIControlStateNormal];
        [self.hasPayBtn setBackgroundImage:[UIImage imageNamed:@"charge_haspay_btn_s"] forState:UIControlStateSelected];
        self.hasPayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.hasPayBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateSelected];
        [self.hasPayBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [self.hasPayBtn setTitle:@"已缴纳" forState:UIControlStateNormal];
        [self.hasPayBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if (self.hasPayBtn.isSelected) {
                return;
            }
            
            [self.notPayBtn setSelected:NO];
            [self.hasPayBtn setSelected:YES];
            
            self.paymentList = @[];
            [self.paymentTableV.header beginRefreshing];
        }];
        [self.paySelectV addSubview:self.hasPayBtn];
        [self.hasPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.paySelectV).with.offset(-14);
            make.left.equalTo(self.paySelectV.mas_centerX);
            make.top.equalTo(self.paySelectV).with.offset(10);
            make.height.equalTo(@32);
        }];
    }
    
    if (!self.paymentTableV) {
        self.paymentTableV = ({
            UITableView *v = [[UITableView alloc] init];
            v.showsHorizontalScrollIndicator = NO;
            v.showsVerticalScrollIndicator = NO;
            v.separatorStyle = UITableViewCellSeparatorStyleNone;
            [v registerClass:[PropertyPayCell class] forCellReuseIdentifier:[PropertyPayCell reuseIdentify]];
            [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
                _strong(self);
                if (self.notPayBtn.isSelected) {
                    return [self.paymentList count]+1;
                }
                return [self.paymentList count];
            }];
            
            [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
                _strong(self);
                if (path.row < [self.paymentList count]) {
                    PropertyPayCell *cell = [view dequeueReusableCellWithIdentifier:[PropertyPayCell reuseIdentify]];
                    if (!cell) {
                        cell = [[PropertyPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PropertyPayCell reuseIdentify]];
                    }
                    
                    PaymentInfo *payment = self.paymentList[path.row];
                    cell.payment = payment;
                    cell.payBlock = ^(PaymentInfo *payment) {
                        [SVProgressHUD showWithStatus:@"正在生成定单"];
                        [[PropertyServiceModel sharedModel] asyncPaymentOrderNumberWithInfo:@[@{@"SellerChargeId":payment.chargeId, @"ChargeType":payment.chargeType}] remoteBlock:^(NSString *orderNum, NSError *error) {
                            _strong(self);
                            if (error) {
                                [SVProgressHUD showErrorWithStatus:@"生成定单失败，请检查网络"];
                                return;
                            }
                            [SVProgressHUD dismiss];
                            [self performSegueWithIdentifier:@"Segue_PaymentList_Pay" sender:@{@"paymentList":@[payment],@"orderNum":orderNum}];
                        }];
                    };
                    return cell;
                }
                else {
                    PropertyPayTotalCell *cell = [view dequeueReusableCellWithIdentifier:[PropertyPayTotalCell reuseIdentify]];
                    if (!cell) {
                        cell = [[PropertyPayTotalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PropertyPayTotalCell reuseIdentify]];
                    }
                    
                    cell.paymentList = self.paymentList;
                    cell.payBlock = ^(){
                        _strong(self);
                        [SVProgressHUD showWithStatus:@"正在生成定单"];
                        NSMutableArray *array = [@[] mutableCopy];
                        float totalfee = 0.0f;
                        for (PaymentInfo *payment in self.paymentList) {
                            [array addObject:@{@"SellerChargeId":payment.chargeId, @"ChargeType":payment.chargeType}];
                            totalfee += [payment.chargePrice floatValue];
                        }
                        [[PropertyServiceModel sharedModel] asyncPaymentOrderNumberWithInfo:array remoteBlock:^(NSString *orderNum, NSError *error) {
                            _strong(self);
                            if (error) {
                                [SVProgressHUD showErrorWithStatus:@"生成定单失败，请检查网络"];
                                return;
                            }
                            
                            [SVProgressHUD dismiss];
                            [self performSegueWithIdentifier:@"Segue_PaymentList_Pay" sender:@{@"paymentList":self.paymentList,@"orderNum":orderNum}];
                            
                        }];
                    };
                    return cell;
                }
            }];
            
            [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
                return 101;
            }];
            
            v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _strong(self);
                [self _refreshCharge];
            }];
            v;
        });
    }
    
    if (self.type == ChargeProperty) {
        [self.propertyBtn setSelected:YES];
    }
    if (self.type == ChargeWarm) {
        [self.warmBtn setSelected:YES];
    }
    if (self.type == ChargeClean) {
        [self.cleanBtn setSelected:YES];
    }
    if (self.type == ChargePark) {
        [self.parkBtn setSelected:YES];
    }
    
    [self.notPayBtn setSelected:YES];
}

- (void)_layoutCodingViews {
    _weak(self);
    if (![self.typeSelectV superview]) {
        [self.contentV addSubview:self.typeSelectV];
        [self.typeSelectV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.equalTo(self.contentV);
            make.height.equalTo(@68);
        }];
    }
    
    if (![self.paySelectV superview]) {
        [self.contentV addSubview:self.paySelectV];
        [self.paySelectV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.typeSelectV.mas_bottom);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@52);
        }];
    }
    
    if (![self.paymentTableV superview]) {
        UIView *tmp = [[UIView alloc] init];
        tmp.backgroundColor = k_COLOR_CLEAR;
        [self.contentV addSubview:tmp];
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.bottom.equalTo(self.contentV);
            make.height.equalTo(@1);
        }];
        
        _weak(tmp);
        [self.contentV addSubview:self.paymentTableV];
        [self.paymentTableV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(tmp);
            make.top.equalTo(self.paySelectV.mas_bottom);
            make.left.right.equalTo(self.contentV);
            make.bottom.equalTo(tmp.mas_top);
        }];
    }
}

#pragma mark - Data
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"paymentList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.paymentTableV reloadData];
    }];
}

- (void)_refreshCharge {
    _weak(self);
    [[PropertyServiceModel sharedModel] asyncPropertyChargeListWithType:self.type isPayd:self.hasPayBtn.isSelected remoteBlock:^(NSArray *chargeList, NSError *error) {
        _strong(self);
        if (self.paymentTableV.header.isRefreshing) {
            [self.paymentTableV.header endRefreshing];
        }
        
        if (!error) {
            self.paymentList = chargeList;
        }
    }];
}
@end
