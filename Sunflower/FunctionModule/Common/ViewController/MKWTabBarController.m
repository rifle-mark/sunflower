//
//  MKWTabBarController.m
//  Sunflower
//
//  Created by makewei on 15/5/31.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWTabBarController.h"

@interface MKWTabBarController ()

@end

@implementation MKWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarItem *mainItem = [self.tabBar.items objectAtIndex:0];
    mainItem.image = [[UIImage imageNamed:@"tab_main_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainItem.selectedImage = [[UIImage imageNamed:@"tab_main_icon_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *propertyItem = [self.tabBar.items objectAtIndex:1];
    propertyItem.image = [[UIImage imageNamed:@"tab_property_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    propertyItem.selectedImage = [[UIImage imageNamed:@"tab_property_icon_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *communityItem = [self.tabBar.items objectAtIndex:2];
    communityItem.image = [[UIImage imageNamed:@"tab_community_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    communityItem.selectedImage = [[UIImage imageNamed:@"tab_community_icon_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *personalItem = [self.tabBar.items objectAtIndex:3];
    personalItem.image = [[UIImage imageNamed:@"tab_personal_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalItem.selectedImage = [[UIImage imageNamed:@"tab_personal_icon_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
