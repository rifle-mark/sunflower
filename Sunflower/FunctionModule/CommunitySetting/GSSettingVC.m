//
//  GSStepOneVC.m
//  Sunflower
//
//  Created by mark on 15/4/19.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "GSSettingVC.h"
#import "GCExtension.h"
#import "MKWStringHelper.h"

#import "CityChooseVC.h"
#import "AreaChooseVC.h"
#import "CommunityChooseVC.h"
#import "CommonModel.h"
#import "MainModel.h"

@interface GSSettingVC ()

@property(nonatomic,strong)OpendCityInfo *city;
@property(nonatomic,strong)OpendAreaInfo *area;
@property(nonatomic,strong)OpendCommunityInfo *community;

@end

@implementation GSSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    if (![[CommonModel sharedModel] currentCommunityId]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    self.nextBtn.enabled = NO;
    self.areaBtn.enabled = NO;
    self.communityBtn.enabled = NO;
    
    [self _setupObserver];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"city" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (!self.city) {
            return;
        }
        [self.cityBtn setTitle:self.city.city forState:UIControlStateNormal];
        
        if (![MKWStringHelper isNilEmptyOrBlankString:self.city.city]) {
            self.areaBtn.enabled = YES;
        }
    }];
    
    [self startObserveObject:self forKeyPath:@"area" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        [self.areaBtn setTitle:self.area.area forState:UIControlStateNormal];
        
        if (![MKWStringHelper isNilEmptyOrBlankString:self.area.area]) {
            self.communityBtn.enabled = YES;
        }
    }];
    
    [self startObserveObject:self forKeyPath:@"community" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        [self.communityBtn setTitle:self.community.name forState:UIControlStateNormal];
        
        if (![MKWStringHelper isNilEmptyOrBlankString:self.community.name]) {
            self.nextBtn.enabled = YES;
        }
    }];
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
    
    if ([segue.identifier isEqualToString:@"GS_ChooseArea"]) {
        ((AreaChooseVC*)segue.destinationViewController).city = self.city;
    }
    
    if ([segue.identifier isEqualToString:@"GS_ChooseCommunity"]) {
        ((CommunityChooseVC*)segue.destinationViewController).city = self.city;
        ((CommunityChooseVC*)segue.destinationViewController).area = self.area;
    }
}

-(IBAction)unwindSegue:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"Back_ChooseCity"]) {
        OpendCityInfo *city = [(CityChooseVC*)segue.sourceViewController city];
        if (![MKWStringHelper isNilEmptyOrBlankString:city.city]) {
            self.city = city;
        }
    }
    
    if ([segue.identifier isEqualToString:@"Back_ChooseArea"]) {
        OpendAreaInfo *area = [(AreaChooseVC*)segue.sourceViewController area];
        if (![MKWStringHelper isNilEmptyOrBlankString:area.area]) {
            self.area = area;
        }
    }
    
    if ([segue.identifier isEqualToString:@"Back_ChooseCommunity"]) {
        OpendCommunityInfo *community = [(CommunityChooseVC*)segue.sourceViewController community];
        if (![MKWStringHelper isNilEmptyOrBlankString:community.name]) {
            self.community = community;
        }
    }
}

- (IBAction)Done:(id)sender {
    
    if (!self.community) {
        [SVProgressHUD showErrorWithStatus:@"请选择完整的小区信息"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在获取小区信息" maskType:SVProgressHUDMaskTypeClear];
    [MainModel asyncGetCommunityInfoWithId:self.community.communityId cacheBlock:^(CommunityInfo *community, NSArray *buildList) {
        
    } remoteBlock:^(CommunityInfo *community, NSArray *buildList, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取小区信息失败，请重试"];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_COMMUNITY_CHANGED object:nil userInfo:@{k_NOTIFY_KEY_COMMUNITY_CHANGED:self.community.communityId}];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_CITY_CHANGED object:nil userInfo:@{k_NOTIFY_KEY_CITY_CHANGED:self.community.city}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
