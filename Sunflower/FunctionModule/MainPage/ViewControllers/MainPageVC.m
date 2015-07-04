//
//  MainPageVC.m
//  Sunflower
//
//  Created by mark on 15/5/1.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MainPageVC.h"
#import "CommonModel.h"
#import "MainModel.h"
#import "UserModel.h"

#import "PropertyPayListVC.h"
#import "MKWWebVC.h"
#import "WeCommentListVC.h"
#import "ServerProxy.h"
#import "PropertyNotifyVC.h"

@interface MainPageVC ()

@property(nonatomic,weak)IBOutlet UIImageView   *communityBgV;
@property(nonatomic,weak)IBOutlet UIView        *noteV;
@property(nonatomic,weak)IBOutlet UIButton      *latestNotifyB;

@property(nonatomic,strong)UIImageView          *avatarV;
@property(nonatomic,strong)UIView               *communityNameV;
@property(nonatomic,strong)UIImageView          *gpsImgeV;
@property(nonatomic,strong)UILabel              *communityNameL;
@property(nonatomic,strong)UILabel              *checkInL;
@property(nonatomic,strong)UILabel              *weatherL;
@property(nonatomic,strong)UILabel              *LimitedL;


@property(nonatomic,strong)CommunityInfo        *community;
@property(nonatomic,strong)CommunityNoteInfo    *latestNoteInfo;

@end

@implementation MainPageVC

- (NSString *)umengPageName {
    return @"首页";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.tabBar.selectedImageTintColor = k_COLOR_BLUE;
    
    self.latestNoteInfo = nil;
    
    if (![[CommonModel sharedModel] currentCommunityId]) {
        [self _showCommunitySettingVC];
    }
    
    [self _setupObserver];
    if ([[CommonModel sharedModel] currentCommunityId]) {
        [self _refreshCommunityInfo];
        [self _refreshLatestNotify];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
}

#pragma mark - Navigation

- (void)_showCommunitySettingVC {
    UINavigationController* CSSettingNaviVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"CSSettingNaviVC"];
    [self presentViewController:CSSettingNaviVC animated:YES completion:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationController.navigationBarHidden = NO;
    
    if ([segue.identifier isEqualToString:@"Segue_MainPage_Payment"]) {
        ((PropertyPayListVC *)[segue destinationViewController]).type = ChargeProperty;
    }
    else if ([segue.identifier isEqualToString:@"Segue_MainPage_Web"]) {
        ((MKWWebVC*)segue.destinationViewController).naviTitle = @"周边游";
        ((MKWWebVC*)segue.destinationViewController).url = [NSURL URLWithString:k_URL_ZHOUBIANYOU];
    }
    else if ([segue.identifier isEqualToString:@"Segue_MainPage_WeiComment"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"Segue_MainPage_NotifyInfo"]) {
        PropertyNotifyVC *vc = [segue destinationViewController];
        vc.note = sender;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)latestNotifyButtonOnClick:(UIButton *)sender {
    if (self.latestNoteInfo) {
        [self performSegueWithIdentifier:@"Segue_MainPage_NotifyInfo" sender:self.latestNoteInfo];
    }
}

#pragma mark - coding Views
- (void)_loadCodingViews {
    self.avatarV = ({
        UIImageView *v = [[UIImageView alloc] init];
        v.clipsToBounds = YES;
        v.image = [UIImage imageNamed:@"default_avatar"];
        v;
    });
    
    self.communityNameV = ({
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = k_COLOR_CLEAR;
        v.clipsToBounds = YES;
        _weak(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            [self _showCommunitySettingVC];
        }];
        [v addGestureRecognizer:tap];
        v;
    });
    
    self.gpsImgeV = ({
        UIImageView *locationV = [[UIImageView alloc] init];
        locationV.image = [UIImage imageNamed:@"GPSIcon"];
        locationV.contentMode = UIViewContentModeScaleToFill;
        locationV.clipsToBounds = YES;
        locationV;
    });
    
    self.communityNameL = [[UILabel alloc] init];
    self.communityNameL.textColor = k_COLOR_WHITE;
    self.communityNameL.backgroundColor = k_COLOR_CLEAR;
    self.communityNameL.font = [UIFont boldSystemFontOfSize:16];
    
    self.checkInL = [[UILabel alloc] init];
    self.checkInL.textColor = k_COLOR_WHITE;
    self.checkInL.font = [UIFont boldSystemFontOfSize:12];
    self.checkInL.backgroundColor = k_COLOR_CLEAR;
    self.checkInL.textAlignment = NSTextAlignmentRight;
    
    self.weatherL = [[UILabel alloc] init];
    self.weatherL.textColor = k_COLOR_WHITE;
    self.weatherL.font = [UIFont systemFontOfSize:12];
    self.weatherL.backgroundColor = k_COLOR_CLEAR;
    
    self.LimitedL = [[UILabel alloc] init];
    self.LimitedL.textColor = k_COLOR_WHITE;
    self.LimitedL.font = [UIFont systemFontOfSize:12];
    self.LimitedL.backgroundColor = k_COLOR_CLEAR;
    
    [self.latestNotifyB setTitleColor:k_COLOR_COUPON_TEXT forState:UIControlStateNormal];
}

- (void)_layoutCodingViews {
    _weak(self);
    if (![self.avatarV superview]) {
        if ([[UserModel sharedModel] isNormalLogined]) {
            UserInfo *cUser = [[UserModel sharedModel] currentNormalUser];
            [self.communityBgV addSubview:self.avatarV];
            [self.avatarV setImageWithURL:[NSURL URLWithString:cUser.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
            [self.avatarV mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.right.equalTo(self.communityBgV).with.offset(-13);
                make.top.equalTo(self.communityBgV).with.offset(25);
                make.width.height.equalTo(@60);
            }];
            self.avatarV.layer.cornerRadius = 30;
        }
    }
    
    if (![self.communityNameV superview]) {
        [self.communityBgV addSubview:self.communityNameV];
        [self.communityNameV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.communityBgV).with.offset(33);
            make.centerX.equalTo(self.communityBgV);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];
    }
    
    if (![self.gpsImgeV superview]) {
        [self.communityNameV addSubview:self.gpsImgeV];
        [self.gpsImgeV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.centerY.equalTo(self.communityNameV);
            make.width.equalTo(@(self.gpsImgeV.image.size.width));
            make.height.equalTo(@(self.gpsImgeV.image.size.height));
        }];
    }
    
    if (![self.communityNameL superview]) {
        [self.communityNameV addSubview:self.communityNameL];
        [self.communityNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.bottom.right.equalTo(self.communityNameV);
            make.left.equalTo(self.gpsImgeV.mas_right);
        }];
    }
    
    if (![self.checkInL superview]) {
        [self.communityBgV addSubview:self.checkInL];
        [self.checkInL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.communityBgV).with.offset(-13);
            make.bottom.equalTo(self.communityBgV).with.offset(-13);
            make.height.equalTo(@12);
            make.width.equalTo(@100);
        }];
    }
}

#pragma mark - data
- (void)_setupObserver {
    _weak(self);
    [self addObserverForNotificationName:k_NOTIFY_NAME_CURRENT_COMMUNITY_CHANGED usingBlock:^(NSNotification *notification) {
        _strong(self);
        if ([[CommonModel sharedModel] currentCommunityId]) {
            if (!self.community) {
                [self _refreshCommunityInfo];
                [self _refreshLatestNotify];
                return;
            }
            
            if (self.community && [self.community.communityId integerValue] != [[[CommonModel sharedModel] currentCommunityId] integerValue]) {
                [self _refreshCommunityInfo];
                [self _refreshLatestNotify];
                return;
            }
        }
    }];
    
    [self startObserveObject:self forKeyPath:@"community" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        NSDictionary *att = @{NSFontAttributeName:self.communityNameL.font,
                              NSForegroundColorAttributeName:self.communityNameL.textColor,
                              NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                              NSParagraphStyleAttributeName:ps,};
        CGRect nameRect = [self.community.name boundingRectWithSize:ccs(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
        [self.communityNameV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.communityBgV).with.offset(33);
            make.width.equalTo(@(nameRect.size.width+30));
            make.centerX.equalTo(self.communityBgV);
            make.height.equalTo(@30);
        }];
        self.communityNameL.text = self.community.name;
        
        self.checkInL.text = [NSString stringWithFormat:@"已有%@人入住", self.community.checkInUserCount];
    }];
    
    [self startObserveObject:self forKeyPath:@"latestNoteInfo" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        NSString *title = self.latestNoteInfo ? self.latestNoteInfo.title : @"暂无最新公告";
        [self.latestNotifyB setTitle:title forState:UIControlStateNormal];
    }];
}

- (void)_refreshCommunityInfo {
    _weak(self);
    [MainModel asyncGetCommunityInfoWithId:[[CommonModel sharedModel] currentCommunityId] cacheBlock:^(CommunityInfo *community, NSArray *buildList) {
        _strong(self);
        self.community = community;
    } remoteBlock:^(CommunityInfo *community, NSArray *buildList, NSError *error) {
        _strong(self);
        self.community = community;
    }];
}

- (void)_refreshLatestNotify {
    _weak(self);
    [[PropertyServiceModel sharedModel] asyncCommunityNoteListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] pageIndex:@1 pageSize:@1 cacheBlock:nil remoteBlock:^(NSArray *list, NSNumber *cPage, NSError *error) {
        _strong(self);
        self.latestNoteInfo = !error && [list count] > 0 ? list[0] : nil;
    }];
}

@end
