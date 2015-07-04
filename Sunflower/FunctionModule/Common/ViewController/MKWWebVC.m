//
//  MKWWebVC.m
//  Sunflower
//
//  Created by makewei on 15/5/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWWebVC.h"

#define k_IMAGE_WEBVIEW_BACK_NORMAL         @""
#define k_IMAGE_WEBVIEW_BACK_HIGHLIGHT      @""

#define k_IMAGE_WEBVIEW_FORWARD_NORMAL      @""
#define k_IMAGE_WEBVIEW_FORWARD_HIGHLIGHT   @""

#define k_IMAGE_WEBVIEW_CLOSE_NORMAL        @""
#define k_IMAGE_WEBVIEW_CLOSE_HIGHLIGHT     @""

#define k_IMAGE_WEBVIEW_STOP_NORMAL         @""
#define k_IMAGE_WEBVIEW_STOP_HIGHLIGHT      @""

#define k_IMAGE_WEBVIEW_RELOAD_NORMAL       @""
#define k_IMAGE_WEBVIEW_RELOAD_HIGHLIGHT    @""

@interface MKWWebVC () <UIWebViewDelegate>

@property (nonatomic, weak)IBOutlet UIView      *contentV;
@property (nonatomic, strong) UIToolbar         *controlV;
@property (nonatomic, strong) UIButton          *backwardBtn;
@property (nonatomic, strong) UIButton          *fowardBtn;
@property (nonatomic, strong) UIButton          *refreshStopBtn;
@property (nonatomic, strong) UIWebView         *webView;

@end

@implementation MKWWebVC

- (NSString *)umengPageName {
    return self.naviTitle;
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_Web";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.naviTitle;

    // Do any additional setup after loading the view.
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
    
    [_backwardBtn setEnabled:[_webView canGoBack]];
    [_fowardBtn setEnabled:[_webView canGoForward]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
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
}


- (void)_loadCodingViews {
    self.controlV = [[UIToolbar alloc] init];
    _backwardBtn = [[UIButton alloc] init];
    [_backwardBtn setImage:[UIImage imageNamed:k_IMAGE_WEBVIEW_BACK_NORMAL] forState:UIControlStateNormal];
    [_backwardBtn setImage:[UIImage imageNamed:k_IMAGE_WEBVIEW_BACK_HIGHLIGHT] forState:UIControlStateHighlighted];
    
    _fowardBtn = [[UIButton alloc] init];
    [_fowardBtn setImage:[UIImage imageNamed:k_IMAGE_WEBVIEW_FORWARD_NORMAL] forState:UIControlStateNormal];
    [_fowardBtn setImage:[UIImage imageNamed:k_IMAGE_WEBVIEW_FORWARD_HIGHLIGHT] forState:UIControlStateHighlighted];
    
    _refreshStopBtn = [[UIButton alloc] init];
    [self _setStopButton];
    
    
    [_fowardBtn addTarget:self action:@selector(_fowardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backwardBtn addTarget:self action:@selector(_backwardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_refreshStopBtn addTarget:self action:@selector(_refreshStopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _weak(self);
    [self.controlV addSubview:self.backwardBtn];
    [self.backwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.bottom.equalTo(self.controlV);
        make.width.equalTo(@56);
    }];
    [self.controlV addSubview:self.fowardBtn];
    [self.fowardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.backwardBtn.mas_right);
        make.top.bottom.equalTo(self.controlV);
        make.width.equalTo(self.backwardBtn);
    }];
    [self.controlV addSubview:self.refreshStopBtn];
    [self.refreshStopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.fowardBtn.mas_right);
        make.top.bottom.equalTo(self.controlV);
        make.width.equalTo(self.backwardBtn);
    }];
    
    
    _webView = [[UIWebView alloc] init];
    [_webView setBackgroundColor:k_COLOR_TUATARA];
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    [_webView setDelegate:self];
}

- (void)_layoutCodingViews {
    _weak(self);
    if (![self.controlV superview] && self.showControl) {
        [self.contentV addSubview:self.controlV];
        [self.controlV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.left.right.equalTo(self.contentV);
            make.height.equalTo(@46);
        }];
    }
    
    if (![self.webView superview] && self.showControl) {
        [self.contentV addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.left.right.equalTo(self.contentV);
            make.bottom.equalTo(self.controlV.mas_top);
        }];
    }
    
    if (!self.showControl) {
        [self.contentV addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.left.right.bottom.equalTo(self.contentV);
        }];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Control Button click handler

- (void)_backwardBtnClick:(id)sender {
    [_webView goBack];
}

- (void)_fowardBtnClick:(id)sender {
    [_webView goForward];
}

- (void)_refreshStopBtnClick:(id)sender {
    if ([_webView isLoading]) {
        [_webView stopLoading];
    }
    else {
        [_webView reload];
    }
}


- (void)_setStopButton {
    [_refreshStopBtn setImage:[UIImage imageNamed:k_IMAGE_WEBVIEW_STOP_NORMAL] forState:UIControlStateNormal];
    [_refreshStopBtn setImage:[UIImage imageNamed:k_IMAGE_WEBVIEW_STOP_HIGHLIGHT] forState:UIControlStateHighlighted];
}

- (void)_setReloadButton {
    [_refreshStopBtn setImage:[UIImage imageNamed:k_IMAGE_WEBVIEW_RELOAD_NORMAL] forState:UIControlStateNormal];
    [_refreshStopBtn setImage:[UIImage imageNamed:k_IMAGE_WEBVIEW_RELOAD_HIGHLIGHT] forState:UIControlStateHighlighted];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"qunariphone"] || [request.URL.scheme isEqualToString:@"qunariphonepro"]) {
        return NO;
    }
    
    if ([self.naviTitle isEqualToString:@"银行卡支付"]) {
        if ([request.URL.host isEqualToString:@"ybpayok"]) {
            [self performSegueWithIdentifier:@"UnSegue_Web" sender:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_SUCCESS object:nil userInfo:nil];
        }
        if ([request.URL.host isEqualToString:@"false"]) {
            [self performSegueWithIdentifier:@"UnSegue_Web" sender:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_FAILED object:nil userInfo:nil];
        }
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self _setStopButton];
    [_backwardBtn setEnabled:[_webView canGoBack]];
    [_fowardBtn setEnabled:[_webView canGoForward]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self _setReloadButton];
    [_backwardBtn setEnabled:[_webView canGoBack]];
    [_fowardBtn setEnabled:[_webView canGoForward]];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self _setReloadButton];
    [_backwardBtn setEnabled:[_webView canGoBack]];
    [_fowardBtn setEnabled:[_webView canGoForward]];
}

@end

