//
//  MKWViewController.m
//  Sunflower
//
//  Created by makewei on 15/6/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWViewController.h"

@interface MKWViewController ()

@end

@implementation MKWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _weak(self);
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
        _strong(self);
        if (![MKWStringHelper isNilEmptyOrBlankString:[self unwindSegueIdentify]]) {
            [self performSegueWithIdentifier:[self unwindSegueIdentify] sender:nil];
        }
    }];
    
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
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
