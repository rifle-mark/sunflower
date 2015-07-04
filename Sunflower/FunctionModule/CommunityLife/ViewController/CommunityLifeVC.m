//
//  CommunityLifeVC.m
//  Sunflower
//
//  Created by mark on 15/5/1.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CommunityLifeVC.h"
#import "AroundChipListVC.h"
#import "RentListVC.h"
#import "MKWWebVC.h"

#import "CommunityLifeModel.h"
#import "MKWModelHandler.h"
#import "CommonModel.h"
#import "WeiCommentAction.h"
#import "UserModel.h"
#import "ServerProxy.h"

@interface CommunityLifeVC ()

@property(nonatomic,weak)IBOutlet UIView    *scrollContentV;
@property(nonatomic,strong)UIView           *contentV;
@property(nonatomic,strong)UIButton         *weiCommentV;
@property(nonatomic,strong)UIImageView      *hasNewWeiIcon;
@property(nonatomic,strong)UIButton         *couponBtn;
@property(nonatomic,strong)UIButton         *travelBtn;
@property(nonatomic,strong)UIButton         *rentBtn;
@property(nonatomic,strong)UIButton         *serviceBtn;
@property(nonatomic,strong)UIButton         *infoBtn;

@end

@implementation CommunityLifeVC

- (NSString *)umengPageName {
    return @"社区生活首页";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // TODO: check if has new comment in wei comment model
    [self _updateWeiCommentState];
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
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

    if ([segue.identifier isEqualToString:@"Segue_CL_Coupon"]) {
        ((AroundChipListVC*)segue.destinationViewController).type = Coupon_all;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_CL_Rent"]) {
        ((RentListVC*)segue.destinationViewController).type = Rent_Out;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_CL_TravelWeb"]) {
        ((MKWWebVC*)segue.destinationViewController).naviTitle = @"周边游";
        ((MKWWebVC*)segue.destinationViewController).url = [NSURL URLWithString:k_URL_ZHOUBIANYOU];
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
//    [self _updateWeiCommentState];
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    _weak(self);
    if (!self.contentV) {
        self.contentV = [[UIView alloc] init];
        self.contentV.backgroundColor = k_COLOR_CLEAR;
    }

    UIButton *(^lifeButtonBlock)(NSString *bg, NSString *hbg, NSString *segue) = ^(NSString *bg, NSString *hbg, NSString *segue){
        UIButton *b = [[UIButton alloc] init];
        [b setBackgroundImage:[UIImage imageNamed:bg] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:(hbg?hbg:bg)] forState:UIControlStateHighlighted];
        b.backgroundColor = k_COLOR_BLUE;
        _weak(b);
        [b addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            _strong(b);
            [self performSegueWithIdentifier:segue sender:b];
            if ([b isEqual:self.weiCommentV]) {
                [self.hasNewWeiIcon setHidden:YES];
            }
        }];
        return b;
    };
    if (!self.weiCommentV) {
        self.weiCommentV = lifeButtonBlock(@"life_weicomment_btn", nil, @"Segue_CL_WeiComment");
    }
    if (!self.couponBtn) {
        self.couponBtn = lifeButtonBlock(@"life_coupon_btn", nil, @"Segue_CL_Coupon");
    }
    if (!self.travelBtn) {
        self.travelBtn = lifeButtonBlock(@"life_travel_btn", nil, @"Segue_CL_TravelWeb");
    }
    if (!self.rentBtn) {
        self.rentBtn = lifeButtonBlock(@"life_rent_btn", nil, @"Segue_CL_Rent");
    }
    if (!self.serviceBtn) {
        self.serviceBtn = lifeButtonBlock(@"life_service_btn", nil, @"Segue_CL_Service");
    }
    if (!self.infoBtn) {
        self.infoBtn = lifeButtonBlock(@"life_info_btn", nil, @"Segue_CL_Info");
    }
    
    [self.contentV addSubview:self.weiCommentV];
    [self.weiCommentV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.equalTo(self.contentV);
        make.height.equalTo(@68);
    }];
    
    self.hasNewWeiIcon = [[UIImageView alloc] init];
    self.hasNewWeiIcon.image = [UIImage imageNamed:@"notify_red"];
    [self.hasNewWeiIcon setHidden:YES];
    [self.contentV addSubview:self.hasNewWeiIcon];
    [self.hasNewWeiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.centerY.equalTo(self.weiCommentV);
        make.left.equalTo(self.weiCommentV).with.offset(150);
        make.width.height.equalTo(@10);
    }];
    
    [self.contentV addSubview:self.couponBtn];
    [self.couponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.top.equalTo(self.weiCommentV.mas_bottom);
        make.height.equalTo(@68);
    }];
    [self.contentV addSubview:self.travelBtn];
    [self.travelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.top.equalTo(self.couponBtn.mas_bottom);
        make.height.equalTo(@68);
    }];
    [self.contentV addSubview:self.rentBtn];
    [self.rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.top.equalTo(self.travelBtn.mas_bottom);
        make.height.equalTo(@68);
    }];
    [self.contentV addSubview:self.serviceBtn];
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.top.equalTo(self.rentBtn.mas_bottom);
        make.height.equalTo(@68);
    }];
    [self.contentV addSubview:self.infoBtn];
    [self.infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.top.equalTo(self.serviceBtn.mas_bottom);
        make.height.equalTo(@68);
    }];
}

- (void)_layoutCodingViews {
    if ([self.contentV superview]) {
        return;
    }
    _weak(self);
    [self.scrollContentV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
        make.height.equalTo(@(68*6));
    }];
    
    [self.scrollContentV addSubview:self.contentV];
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.bottom.equalTo(self.scrollContentV);
    }];
}

#pragma mark - data
- (void)_updateWeiCommentState {
    if (![UserModel sharedModel].isNormalLogined) {
        return;
    }
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncWeiListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] parentId:@0 page:@1 pageSize:@1 cacheBlock:nil remoteBlock:^(NSArray *commentList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if (!error) {
            if ([commentList count] > 0) {
                WeiCommentInfo *info = commentList[0];
                WeiCommentAction * action = (WeiCommentAction*)[[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_WEICOMMENTACTION predicate:[NSPredicate predicateWithFormat:@"commentId=%@ And userId=%@", info.commentId, [UserModel sharedModel].currentNormalUser.userId]] firstObject];
                
                if (!action) {
                    [self.hasNewWeiIcon setHidden:NO];
                }
                else {
                    [self.hasNewWeiIcon setHidden:YES];
                }
            }
        }
    }];
}

@end
