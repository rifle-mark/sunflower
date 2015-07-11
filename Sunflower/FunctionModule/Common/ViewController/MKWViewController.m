//
//  MKWViewController.m
//  Sunflower
//
//  Created by makewei on 15/6/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWViewController.h"
#import "MKWPushNotificationHandler.h"

@interface MKWViewController ()

@end

@implementation MKWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _weak(self);
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
        _strong(self);
        if (gesture.state == UIGestureRecognizerStateRecognized) {
            CGPoint offsetPoint = [(UIPanGestureRecognizer*)gesture translationInView:gesture.view];
            if (offsetPoint.x > 50 && ![MKWStringHelper isNilEmptyOrBlankString:[self unwindSegueIdentify]]) {
                [self performSegueWithIdentifier:[self unwindSegueIdentify] sender:nil];
            }
        }
    }];
    
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)unwindSegueIdentify {
    return @"";
}

- (NSString *)umengPageName {
    return @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![MKWStringHelper isNilEmptyOrBlankString:[self umengPageName]]) {
        [MobClick beginLogPageView:[self umengPageName]];
    }
    
    [MKWPushNotificationHandler sharedHandler].currentvc = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![MKWStringHelper isNilEmptyOrBlankString:[self umengPageName]]) {
        [MobClick endLogPageView:[self umengPageName]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
