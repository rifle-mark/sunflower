//
//  ContractVC.m
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ContractVC.h"

@interface ContractVC () <UIWebViewDelegate>
@property(nonatomic,weak)IBOutlet UIView        *contentV;
@property(nonatomic,strong)UIWebView              *webV;
@end

@implementation ContractVC

- (NSString *)umengPageName {
    return @"用户协议";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_Contract";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webV loadRequest:[NSURLRequest requestWithURL:self.url]];
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
    if (!self.webV) {
        self.webV = [[UIWebView alloc] init];
    }
}

- (void)_layoutCodingViews {
    if (![self.webV superview]) {
        [self.contentV addSubview:self.webV];
        _weak(self);
        [self.webV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentV);
        }];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end
