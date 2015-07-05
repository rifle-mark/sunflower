//
//  StartUpVC.m
//  Sunflower
//
//  Created by makewei on 15/7/1.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "StartUpVC.h"

@interface StartUpVC ()<UIWebViewDelegate, UIScrollViewDelegate>

@property(nonatomic,strong)UIWebView        *webV;

@end

@implementation StartUpVC

- (NSString *)unwindSegueIdentify {
    return @"";
}

- (NSString *)umengPageName {
    return @"启动页";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [self.webV performSelectorInBackground:@selector(loadRequest:) withObject:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
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
    if (self.webV) {
        return;
    }
    
    self.webV = [[UIWebView alloc] init];
    self.webV.backgroundColor = k_COLOR_WHITE;
    self.webV.scalesPageToFit = YES;
    self.webV.scrollView.scrollEnabled = NO;
    self.webV.scrollView.showsVerticalScrollIndicator = NO;
    self.webV.scrollView.showsHorizontalScrollIndicator = NO;
    self.webV.delegate = self;
    self.webV.scrollView.delegate = self;
}

- (void)_layoutCodingViews {
    if ([self.webV superview]) {
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
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(self.bottomLayoutGuide.length));
    }];
    
    _weak(topTmp);
    _weak(botTmp);
    [self.view addSubview:self.webV];
    [self.webV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(topTmp);
        _strong(botTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.lastPathComponent isEqualToString:@"gotomain"]) {
        [self performSegueWithIdentifier:@"Segue_Startup_Main" sender:nil];
    }
    return YES;
}

@end
