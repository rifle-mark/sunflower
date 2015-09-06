//
//  PropertyInfoVC.m
//  Sunflower
//
//  Created by mark on 15/5/1.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "GCExtension.h"
#import <UIImageView+AFNetworking.h>

#import "OpendCommunity.h"
#import "CommonModel.h"
#import "UserModel.h"
#import "PropertyServiceModel.h"

#import "PropertyInfoVC.h"
#import "PropertyEditVC.h"

@interface PropertyInfoVC ()

@property(nonatomic,strong)OpendCommunityInfo       *community;


@property(nonatomic,weak)IBOutlet UIImageView       *communityImageV;
@property(nonatomic,weak)IBOutlet UILabel           *propertyNameL;
@property(nonatomic,weak)IBOutlet UITextView        *propertyInfoT;
@property(nonatomic,weak)IBOutlet UIButton          *editBtn;
@end

@implementation PropertyInfoVC

- (NSString *)umengPageName {
    return @"物业介绍";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_PropertyInfo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    
    [self _reloadCommunityInfo];
}

- (void)_reloadCommunityInfo {
    // async get community Info
    [[PropertyServiceModel sharedModel] asyncCommunityWithId:[[CommonModel sharedModel] currentCommunityId] cacheBlock:^(OpendCommunityInfo *community) {
        self.community = community;
    } remoteBlock:^(OpendCommunityInfo *community, NSError *error) {
        if (!error) {
            self.community = community;
        }
        else {
            // TODO: MAKEWEI FUCK TODO
            // show error Info
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ([[UserModel sharedModel] isPropertyAdminLogined] && [[UserModel sharedModel].currentAdminUser.communityId integerValue] == [[CommonModel sharedModel].currentCommunityId integerValue]) {
        [self.editBtn setHidden:NO];
    }
    else {
        [self.editBtn setHidden:YES];
    }
    FixesViewDidLayoutSubviewsiOS7Error;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_PropertyInfo_PropertyEdit"]) {
        PropertyEditVC *vc = (PropertyEditVC*)[segue destinationViewController];
        vc.community = self.community;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"UnSegue_PropertyEdit_PropertyInfo"]) {
        if (self.needUpdate) {
            [self _reloadCommunityInfo];
        }
    }
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"community" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.community) {
            [self.communityImageV sd_setImageWithURL:[APIGenerator urlOfPictureWith:[UIScreen mainScreen].bounds.size.width height:[UIScreen mainScreen].bounds.size.width/2 urlString:self.community.images] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
            self.propertyNameL.text = self.community.name;
            self.propertyInfoT.text = self.community.communityDesc;
        }
    }];
}

@end
