//
//  MKWWebVC.m
//  Sunflower
//
//  Created by makewei on 15/5/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWWebVC.h"

@interface MKWWebVC () <UIWebViewDelegate>

@property (nonatomic, weak)IBOutlet UIView              *contentV;
@property (nonatomic, weak)IBOutlet UIBarButtonItem     *backItem;
@property (nonatomic, strong) UIBarButtonItem           *closeItem;
@property (nonatomic, strong) UIBarButtonItem           *refreshItem;
@property (nonatomic, strong) UIBarButtonItem           *stopItem;
@property (nonatomic, strong) UIWebView                 *webView;

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

#pragma mark - property
- (void)setShowControl:(BOOL)showControl {
    _showControl = showControl;
    if (showControl) {
        [self _showRefashOrStopControlButton];
    }
    else {
        [self _hideControlButton];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)_loadCodingViews {
    
    self.closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                      style:UIBarButtonItemStyleDone
                                                     target:self
                                                     action:@selector(_closeAction:)];
    self.refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                     target:self
                                                                     action:@selector(_refreshAction:)];
    self.stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                  target:self
                                                                  action:@selector(_stopAction:)];
    self.closeItem.tintColor = k_COLOR_WHITE;
    self.refreshItem.tintColor = k_COLOR_WHITE;
    self.stopItem.tintColor = k_COLOR_WHITE;
    
    _webView = [[UIWebView alloc] init];
    [_webView setBackgroundColor:k_COLOR_TUATARA];
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    [_webView setDelegate:self];
}

- (void)_layoutCodingViews {
    _weak(self);
    if (![self.webView superview]) {
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

- (void)_showCloseControlButton {
    [self.navigationItem setLeftBarButtonItems:@[self.backItem, self.closeItem] animated:YES];
}

- (void)_showRefashOrStopControlButton {
    UIBarButtonItem *item = [_webView isLoading] ? self.stopItem : self.refreshItem;
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}

- (void)_hideControlButton {
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)backAction:(id)sender {
    if (self.showControl && [_webView canGoBack]) {
        [self _showCloseControlButton];
        [_webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)_closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_refreshAction:(id)sender {
    [_webView reload];
}

- (void)_stopAction:(id)sender {
    [_webView stopLoading];
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
    if (self.showControl) [self _showRefashOrStopControlButton];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.showControl) [self _showRefashOrStopControlButton];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.showControl) [self _showRefashOrStopControlButton];
}

@end

