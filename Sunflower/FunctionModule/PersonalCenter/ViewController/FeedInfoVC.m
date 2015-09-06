//
//  FeedInfoVC.m
//  Sunflower
//
//  Created by kelei on 15/7/25.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "FeedInfoVC.h"
#import "UserModel.h"

@interface FeedInfoVC ()

@property (nonatomic, strong) UIWebView *webV;

@end

@implementation FeedInfoVC

- (NSString *)umengPageName {
    return @"反馈详情";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_FeedInfo";
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
    FixesViewDidLayoutSubviewsiOS7Error;
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (!self.webV) {
        self.webV = ({
            UIWebView *v = [[UIWebView alloc] init];
            v;
        });
    }
}

- (void)_layoutCodingViews {
    _weak(self);
    if (![self.webV superview]) {
        [self.view addSubview:self.webV];
        [self.webV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0));
        }];
    }
}

- (void)_loadData {
    if (!self.feed) {
        return;
    }
    
    self.title = self.feed.title;
    
    _weak(self);
    [[UserModel sharedModel] asyncgetFeedInfoWithFeedId:self.feed.askId remoteBlock:^(FeedInfo *feed, NSError *error) {
        _strong(self);
        if (error) {
            return;
        }
        self.title = feed.title;
        NSInteger imageWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width - 20;
        NSString *imgStyle = [NSString stringWithFormat:@"<img style=\"width:%dpx\"", imageWidth];
        NSString *html = [feed.content stringByReplacingOccurrencesOfString:@"<img" withString:imgStyle];
        [self.webV loadHTMLString:html baseURL:nil];
    }];
}

@end
