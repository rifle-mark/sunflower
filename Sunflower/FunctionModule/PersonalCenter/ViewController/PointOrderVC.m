//
//  PointOrderVC.m
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PointOrderVC.h"

@interface PointOrderVC ()
@property(nonatomic,weak)IBOutlet UIView        *contentV;
@end

@implementation PointOrderVC

- (NSString *)umengPageName {
    return @"我积分商城的定单";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_PointOrder";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
