//
//  ShopCouponJudgeEditVC.m
//  Sunflower
//
//  Created by makewei on 15/6/21.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopCouponJudgeEditVC.h"

#import "CommunityLifeModel.h"

@interface ShopCouponJudgeEditVC ()

@property(nonatomic,strong)UIScrollView     *editScrolV;
@property(nonatomic,strong)UIView           *contentV;

@property(nonatomic,strong)MKWTextField     *quest1T;
@property(nonatomic,strong)MKWTextField     *quest2T;
@property(nonatomic,strong)MKWTextField     *quest3T;
@property(nonatomic,strong)MKWTextField     *quest4T;
@property(nonatomic,strong)MKWTextField     *quest5T;

@property(nonatomic,weak)UIView             *focusedT;

@end

@implementation ShopCouponJudgeEditVC

- (NSString *)umengPageName {
    return @"优惠券满意度调查创建";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_ShopCouponJudgeEdit";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _setupTapGesture];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (self.editScrolV) {
        return;
    }
    
    self.editScrolV = ({
        UIScrollView *v = [[UIScrollView alloc] init];
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        v.delaysContentTouches = NO;
        v.backgroundColor = RGB(225, 225, 225);
        
        _weak(self);
        self.contentV = [[UIView alloc] init];
        [v addSubview:self.contentV];
        
        UILabel *(^titleLabelBlock)(NSString *txt) = ^(NSString *txt){
            UILabel *l = [[UILabel alloc] init];
            l.textColor = k_COLOR_GALLERY_F;
            l.font = [UIFont boldSystemFontOfSize:15];
            l.text = txt;
            return l;
        };
        MKWTextField *(^textFieldBlock)(NSString *txt) = ^(NSString *txt){
            MKWTextField *t = [[MKWTextField alloc] init];
            t.layer.cornerRadius = 3;
            t.clipsToBounds = YES;
            t.textEdgeInset = UIEdgeInsetsMake(15, 14, 15, 14);
            t.backgroundColor = k_COLOR_WHITE;
            t.placeholder = txt;
            t.textColor = k_COLOR_GALLERY_F;
            t.font = [UIFont boldSystemFontOfSize:14];
            [t withBlockForDidBeginEditing:^(UITextField *view) {
                _strong(self);
                self.focusedT = view;
            }];
            [t withBlockForShouldReturn:^BOOL(UITextField *view) {
                [view resignFirstResponder];
                self.focusedT = nil;
                return YES;
            }];
            t.autocapitalizationType = UITextAutocapitalizationTypeWords;
            t.autocorrectionType = UITextAutocorrectionTypeNo;
            return t;
        };
        
        UILabel *quest1L = titleLabelBlock(@"调查问卷1:");
        [self.contentV addSubview:quest1L];
        [quest1L mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentV).with.offset(15);
            make.left.equalTo(self.contentV).with.offset(14);
            make.right.equalTo(self.contentV).with.offset(-14);
            make.height.equalTo(@15);
        }];
        _weak(quest1L);
        self.quest1T = textFieldBlock(@"您对本店的环境是否满意");
        [self.contentV addSubview:self.quest1T];
        [self.quest1T mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(quest1L);
            make.top.equalTo(quest1L.mas_bottom).with.offset(10);
            make.left.right.equalTo(quest1L);
            make.height.equalTo(@44);
        }];
        UILabel *quest2L = titleLabelBlock(@"调查问卷2:");
        [self.contentV addSubview:quest2L];
        [quest2L mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(quest1L);
            _strong(self);
            make.top.equalTo(self.quest1T.mas_bottom).with.offset(20);
            make.left.right.height.equalTo(quest1L);
        }];
        self.quest2T = textFieldBlock(@"您对本店的服务是否满意");
        _weak(quest2L);
        [self.contentV addSubview:self.quest2T];
        [self.quest2T mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(quest2L);
            _strong(self);
            make.top.equalTo(quest2L.mas_bottom).with.offset(10);
            make.left.right.height.equalTo(self.quest1T);
        }];
        UILabel *quest3L = titleLabelBlock(@"调查问卷3:");
        [self.contentV addSubview:quest3L];
        [quest3L mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(quest1L);
            _strong(self);
            make.top.equalTo(self.quest2T.mas_bottom).with.offset(20);
            make.left.right.height.equalTo(quest1L);
        }];
        self.quest3T = textFieldBlock(@"您对本店的产品是否满意");
        [self. contentV addSubview:self.quest3T];
        _weak(quest3L);
        [self.quest3T mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(quest3L);
            make.top.equalTo(quest3L.mas_bottom).with.offset(10);
            make.left.right.height.equalTo(self.quest1T);
        }];
        UILabel *quest4L = titleLabelBlock(@"调查问卷4:");
        [self.contentV addSubview:quest4L];
        [quest4L mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(quest1L);
            make.top.equalTo(self.quest3T.mas_bottom).with.offset(20);
            make.left.right.height.equalTo(quest1L);
        }];
        self.quest4T = textFieldBlock(@"");
        [self.contentV addSubview:self.quest4T];
        _weak(quest4L);
        [self.quest4T mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(quest4L);
            make.top.equalTo(quest4L.mas_bottom).with.offset(10);
            make.left.right.height.equalTo(self.quest1T);
        }];
        UILabel *quest5L = titleLabelBlock(@"调查问卷5:");
        [self.contentV addSubview:quest5L];
        [quest5L mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(quest1L);
            make.top.equalTo(self.quest4T.mas_bottom).with.offset(20);
            make.left.right.height.equalTo(quest1L);
        }];
        self.quest5T = textFieldBlock(@"");
        [self.contentV addSubview:self.quest5T];
        _weak(quest5L);
        [self.quest5T mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(quest5L);
            make.top.equalTo(quest5L.mas_bottom).with.offset(10);
            make.left.right.height.equalTo(self.quest1T);
        }];
        
        UIButton *submitBtn = [[UIButton alloc] init];
        submitBtn.backgroundColor = k_COLOR_BLUE;
        submitBtn.layer.cornerRadius = 4;
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [submitBtn setTitle:@"创建调查问卷" forState:UIControlStateNormal];
        [submitBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [submitBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            NSString *title1 = [MKWStringHelper trimWithStr:self.quest1T.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:title1]) {
                title1 = @"您对本店的环境是否满意";
            }
            NSString *title2 = [MKWStringHelper trimWithStr:self.quest2T.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:title2]) {
                title2 = @"您对本店的服务是否满意";
            }
            NSString *title3 = [MKWStringHelper trimWithStr:self.quest3T.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:title3]) {
                title3 = @"您对本店的产品是否满意";
            }
            NSString *title4 = [MKWStringHelper trimWithStr:self.quest4T.text];
            NSString *title5 = [MKWStringHelper trimWithStr:self.quest5T.text];
            NSMutableArray *questArray = [[NSMutableArray alloc] init];
            [questArray addObject:@{@"Title":title1, @"CouponId":self.couponId}];
            [questArray addObject:@{@"Title":title2, @"CouponId":self.couponId}];
            [questArray addObject:@{@"Title":title3, @"CouponId":self.couponId}];
            if (![MKWStringHelper isNilEmptyOrBlankString:title4]) {
                [questArray addObject:@{@"Title":title4, @"CouponId":self.couponId}];
            }
            if (![MKWStringHelper isNilEmptyOrBlankString:title5]) {
                [questArray addObject:@{@"Title":title5, @"CouponId":self.couponId}];
            }
            
            [[CommunityLifeModel sharedModel] asyncCouponJudgeAddWithArray:questArray remoteBlock:^(BOOL isSuccess, NSError *error) {
                _strong(self);
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:@"创建成功"];
                    [self performSegueWithIdentifier:@"UnSegue_ShopCouponJudgeEdit" sender:nil];
                }
            }];
        }];
        
        [self.contentV addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.quest5T.mas_bottom).with.offset(20);
            make.left.right.height.equalTo(self.quest1T);
        }];
        v;
    });
}

- (void)_layoutCodingViews {
    if ([self.editScrolV superview]) {
        return;
    }
    
    _weak(self);
    UIView *topTmp = [[UIView alloc] init];
    topTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:topTmp];
    [topTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.top.equalTo(self.view);
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
    [self.view addSubview:self.editScrolV];
    [self.editScrolV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(topTmp);
        _strong(botTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];
    
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.bottom.equalTo(self.editScrolV);
        make.width.equalTo(self.view);
        make.height.equalTo(@525);
    }];
}

- (void)_setupTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        if (self.focusedT) {
            [self.focusedT resignFirstResponder];
        }
        
        return NO;
    }];
    
    [self.contentV addGestureRecognizer:tap];
}

@end
