//
//  AboutVC.m
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()
@property(nonatomic,strong)UIImageView          *iconV;
@property(nonatomic,strong)UILabel              *titleL;

@end

@implementation AboutVC

- (NSString *)umengPageName {
    return @"关于";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_About";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (!self.iconV) {
        self.iconV = [[UIImageView alloc] init];
        self.iconV.image = [UIImage imageNamed:@"about"];
    }
    
    if (!self.titleL) {
        self.titleL = [[UILabel alloc] init];
        self.titleL.textColor = k_COLOR_GALLERY_F;
        self.titleL.font = [UIFont boldSystemFontOfSize:14];
        self.titleL.text = @"北京葵花向阳科技有限公司";
        self.titleL.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)_layoutCodingViews {
    _weak(self);
    if (![self.iconV superview]) {
        [self.view addSubview:self.iconV];
        [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.width.equalTo(@167);
            make.height.equalTo(@190);
        }];
    }
    
    if (![self.titleL superview]) {
        [self.view addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.equalTo(self.view).with.offset(-(self.bottomLayoutGuide.length+10));
            make.left.right.equalTo(self.view);
            make.height.equalTo(@14);
        }];
    }
}

@end
