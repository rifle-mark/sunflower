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


@interface MainPageBtnCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView      *imageV;
@property(nonatomic,strong)UILabel          *titleL;

+ (NSString *)reuseIdentify;
@end

@implementation MainPageBtnCell

+ (NSString *)reuseIdentify {
    return @"AuditTelNumCellIdentify";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.titleL];
        
        [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.titleL.superview).with.offset(-8);
            make.centerX.equalTo(self.titleL.superview);
            make.height.equalTo(@14);
        }];
        [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageV.superview).with.offset(8);
            make.bottom.equalTo(self.titleL.mas_top).with.offset(-10);
            make.width.equalTo(self.imageV.mas_height);
            make.centerX.equalTo(self.imageV.superview);
        }];
    }
    return self;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageV;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.font = [UIFont boldSystemFontOfSize:14];
        _titleL.textColor = k_COLOR_GALLERY_F;
    }
    return _titleL;
}

@end

@interface MainPageVC ()

@property(nonatomic,strong)UIImageView   *communityBgV;
@property(nonatomic,strong)UIView        *noteV;
@property(nonatomic,strong)UIButton      *latestNotifyB;
@property(nonatomic,strong)UICollectionView *collectionView;

//@property(nonatomic,strong)UIImageView          *avatarV;
@property(nonatomic,strong)UIView               *communityNameV;
@property(nonatomic,strong)UIImageView          *gpsImgeV;
@property(nonatomic,strong)UILabel              *communityNameL;
@property(nonatomic,strong)UILabel              *checkInL;
@property(nonatomic,strong)UILabel              *weatherL;
@property(nonatomic,strong)UILabel              *LimitedL;


@property(nonatomic,strong)CommunityInfo        *community;
@property(nonatomic,strong)CommunityNoteInfo    *latestNoteInfo;
@property(nonatomic,strong)NSDictionary         *weatherInfoDic;

@end

@implementation MainPageVC

- (NSString *)umengPageName {
    return @"首页";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.tintColor = k_COLOR_BLUE;
    self.latestNoteInfo = nil;

    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.noteV];
    [self.view addSubview:self.communityBgV];
    [self.communityBgV addSubview:self.communityNameV];
    [self.communityNameV addSubview:self.gpsImgeV];
    [self.communityNameV addSubview:self.communityNameL];
    [self.communityBgV addSubview:self.checkInL];
    [self.communityBgV addSubview:self.weatherL];

    [self _setupObserver];
    if ([[CommonModel sharedModel] currentCommunityId]) {
        [self _refreshCommunityInfo];
        
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    if ([[CommonModel sharedModel] currentCommunityId]) {
        [self _refreshLatestNotify];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[CommonModel sharedModel] currentCommunityId]) {
        [self _showCommunitySettingVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    _weak(self);
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.collectionView.superview);
        make.bottom.equalTo(self.collectionView.superview).with.offset(-(self.bottomLayoutGuide.length));
        CGFloat height = ceilf((([UIScreen mainScreen].bounds.size.width - 50)/3.0)*9/4+30);
        make.height.equalTo(@(height));
    }];
    
    [self.noteV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noteV.superview);
        make.bottom.equalTo(self.collectionView.mas_top);
        make.height.equalTo(@40);
    }];
    
    [self.communityBgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.communityBgV.superview);
        make.bottom.equalTo(self.noteV.mas_top);
    }];
    
    // communityNameV
    CGRect nameRect = CGRectZero;
    if (self.community) {
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        NSDictionary *att = @{NSFontAttributeName:self.communityNameL.font,
                              NSForegroundColorAttributeName:self.communityNameL.textColor,
                              NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                              NSParagraphStyleAttributeName:ps,};
        nameRect = [self.community.name boundingRectWithSize:ccs(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
    }
    [self.communityNameV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.communityBgV).with.offset(33);
        make.width.equalTo(@(nameRect.size.width+24));
        make.centerX.equalTo(self.communityBgV);
        make.height.equalTo(@30);
    }];
    // gpsImgeV
    [self.gpsImgeV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.centerY.equalTo(self.communityNameV);
        make.size.mas_equalTo(CGSizeMake(24, 30));
    }];
    // communityNameL
    [self.communityNameL mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.bottom.right.equalTo(self.communityNameV);
        make.left.equalTo(self.gpsImgeV.mas_right);
    }];
    // checkInL
    [self.checkInL mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.right.equalTo(self.communityBgV).with.offset(-13);
        make.bottom.equalTo(self.communityBgV).with.offset(-13);
        make.height.equalTo(@12);
        make.width.equalTo(@100);
    }];
    // weatherL
    [self.weatherL mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.bottom.equalTo(self.checkInL);
        make.left.equalTo(self.communityBgV).with.offset(15);
        make.right.equalTo(self.checkInL.mas_left);
    }];
    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    

    FixesViewDidLayoutSubviewsiOS7Error;
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
    
    if ([segue.identifier isEqualToString:@"Segue_MainPage_Payment"]) {
        ((PropertyPayListVC *)[segue destinationViewController]).type = ChargeProperty;
    }
    else if ([segue.identifier isEqualToString:@"Segue_MainPage_Web"]) {
        ((MKWWebVC*)segue.destinationViewController).naviTitle = @"周边游";
        ((MKWWebVC*)segue.destinationViewController).showControl = YES;
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
    
}

- (IBAction)latestNotifyButtonOnClick:(UIButton *)sender {
    if (self.latestNoteInfo) {
        [self performSegueWithIdentifier:@"Segue_MainPage_NotifyInfo" sender:self.latestNoteInfo];
    }
}

#pragma mark - coding Views
- (UIView *)communityNameV {
    if (!_communityNameV) {
        _communityNameV = ({
            UIView *v = [[UIView alloc] init];
            v.backgroundColor = k_COLOR_CLEAR;
            v.clipsToBounds = YES;
            _weak(self);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
                _strong(self);
                [self performSelectorOnMainThread:@selector(_showCommunitySettingVC) withObject:nil waitUntilDone:YES ];
            }];
            [v addGestureRecognizer:tap];
            v;
        });
    }
    return _communityNameV;
}

- (UIImageView *)gpsImgeV {
    if (!_gpsImgeV) {
        _gpsImgeV = ({
            UIImageView *locationV = [[UIImageView alloc] init];
            locationV.image = [UIImage imageNamed:@"main_db"];
            locationV.contentMode = UIViewContentModeScaleToFill;
            locationV.clipsToBounds = YES;
            locationV;
        });
    }
    return _gpsImgeV;
}
- (UILabel *)communityNameL {
    if (!_communityNameL) {
        _communityNameL = [[UILabel alloc] init];
        _communityNameL.textColor = k_COLOR_WHITE;
        _communityNameL.backgroundColor = k_COLOR_CLEAR;
        _communityNameL.font = [UIFont boldSystemFontOfSize:16];
    }
    return _communityNameL;
}

- (UILabel *)checkInL {
    if (!_checkInL) {
        _checkInL = [[UILabel alloc] init];
        _checkInL.textColor = k_COLOR_WHITE;
        _checkInL.font = [UIFont boldSystemFontOfSize:12];
        _checkInL.backgroundColor = k_COLOR_CLEAR;
        _checkInL.textAlignment = NSTextAlignmentRight;
    }
    return _checkInL;
}
- (UILabel *)weatherL {
    if (!_weatherL) {
        _weatherL = [[UILabel alloc] init];
        _weatherL.textColor = k_COLOR_WHITE;
        _weatherL.font = [UIFont systemFontOfSize:12];
        _weatherL.backgroundColor = k_COLOR_CLEAR;
    }
    return _weatherL;
}

- (UILabel *)LimitedL {
    if (!_LimitedL) {
        _LimitedL = [[UILabel alloc] init];
        _LimitedL.textColor = k_COLOR_WHITE;
        _LimitedL.font = [UIFont systemFontOfSize:12];
        _LimitedL.backgroundColor = k_COLOR_CLEAR;
    }
    return _LimitedL;
}
- (UIButton *)latestNotifyB {
    if (!_latestNotifyB) {
        _latestNotifyB = [UIButton buttonWithType:UIButtonTypeSystem];
        [_latestNotifyB setTitleColor:k_COLOR_COUPON_TEXT forState:UIControlStateNormal];
    }
    return _latestNotifyB;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = ([UIScreen mainScreen].bounds.size.width-50)/3.0;
        CGFloat itemH = itemW*3/4;
        layout.itemSize = ccs(ceilf(itemW), ceilf(itemH));
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 10;
        if (SYSTEM_VERSION_LESS_THAN(@"8")) {
            layout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
        }
        else {
            layout.sectionInset = UIEdgeInsetsMake(-10, 13, 0, 13);
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = k_COLOR_WHITE;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[MainPageBtnCell class] forCellWithReuseIdentifier:[MainPageBtnCell reuseIdentify]];
        
        [_collectionView withBlockForItemNumber:^NSInteger(UICollectionView *view, NSInteger section) {
            return 9;
        }];
        [_collectionView withBlockForItemCell:^UICollectionViewCell *(UICollectionView *view, NSIndexPath *path) {
            MainPageBtnCell *cell = [view dequeueReusableCellWithReuseIdentifier:[MainPageBtnCell reuseIdentify] forIndexPath:path];
            if (path.item == 0) {
                cell.imageV.image = [UIImage imageNamed:@"wyjs"];
                cell.titleL.text = @"物业介绍";
            }
            
            if (path.item == 1) {
                cell.imageV.image = [UIImage imageNamed:@"tzgg"];
                cell.titleL.text = @"通知公告";
            }
            
            if (path.item == 2) {
                cell.imageV.image = [UIImage imageNamed:@"znmj"];
                cell.titleL.text = @"智能门禁";
            }
            
            if (path.item == 3) {
                cell.imageV.image = [UIImage imageNamed:@"cyjf"];
                cell.titleL.text = @"常用缴费";
            }
            
            if (path.item == 4) {
                cell.imageV.image = [UIImage imageNamed:@"wxbx"];
                cell.titleL.text = @"维修保修";
            }
            
            if (path.item == 5) {
                cell.imageV.image = [UIImage imageNamed:@"shfw"];
                cell.titleL.text = @"生活服务";
            }
            
            if (path.item == 6) {
                cell.imageV.image = [UIImage imageNamed:@"zbyh"];
                cell.titleL.text = @"周边优惠";
            }
            
            if (path.item == 7) {
                cell.imageV.image = [UIImage imageNamed:@"blcx"];
                cell.titleL.text = @"周边游";
            }
            
            if (path.item == 8) {
                cell.imageV.image = [UIImage imageNamed:@"sqlt"];
                cell.titleL.text = @"微社区";
            }
            
            UIView *bgV = [[UIView alloc] initWithFrame:cell.bounds];
            bgV.backgroundColor = k_COLOR_GRAY_BG;
            cell.backgroundView = bgV;
            UIView *sbgV = [[UIView alloc] initWithFrame:cell.bounds];
            sbgV.backgroundColor = k_COLOR_BON_JOUR;
            cell.selectedBackgroundView = sbgV;
            cell.clipsToBounds = YES;
            cell.layer.cornerRadius = 4;
            return cell;
        }];
        
        [_collectionView withBlockForItemDidSelect:^(UICollectionView *view, NSIndexPath *path) {
            [view deselectItemAtIndexPath:path animated:YES];
            if (path.item == 0) {
                //wyjs
                [self performSegueWithIdentifier:@"Segue_MainPage_CommunityInfo" sender:nil];
            }
            
            if (path.item == 1) {
                //tzgg
                [self performSegueWithIdentifier:@"Segue_MainPage_NotifyList" sender:nil];
            }
            
            if (path.item == 2) {
                //znmj
            }
            
            if (path.item == 3) {
                //cyjf
                [self performSegueWithIdentifier:@"Segue_MainPage_Payment" sender:nil];
            }
            
            if (path.item == 4) {
                //wxbx
                [self performSegueWithIdentifier:@"Segue_MainPage_FixList" sender:nil];
            }
            
            if (path.item == 5) {
                //shfw
                [self performSegueWithIdentifier:@"Segue_MainPage_ServiceList" sender:nil];
            }
            
            if (path.item == 6) {
                //zbyh
                [self performSegueWithIdentifier:@"Segue_MainPage_CouponList" sender:nil];
            }
            
            if (path.item == 7) {
                //blcx
                [self performSegueWithIdentifier:@"Segue_MainPage_Web" sender:nil];
            }
            
            if (path.item == 8) {
                //sqlt
                [self performSegueWithIdentifier:@"Segue_MainPage_WeiComment" sender:nil];
            }
        }];

    }
    return _collectionView;
}

- (UIView *)noteV {
    if (!_noteV) {
        _noteV = [[UIView alloc] init];
        _noteV.backgroundColor = k_COLOR_GRAY_BG;
    }
    return _noteV;
}

- (UIImageView *)communityBgV {
    if (!_communityBgV) {
        _communityBgV = [[UIImageView alloc] init];
        _communityBgV.image = [UIImage imageNamed:@"communityBg"];
        _communityBgV.contentMode = UIViewContentModeScaleAspectFill;
        _communityBgV.clipsToBounds = YES;
        _communityBgV.userInteractionEnabled = YES;
    }
    return _communityBgV;
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
        if (!self.community) {
            return;
        }
        [self.communityBgV sd_setImageWithURL:[NSURL URLWithString:self.community.images]];
        self.communityNameL.text = self.community.name;
        [self updateViewConstraints];
        
        self.checkInL.text = [NSString stringWithFormat:@"已有%@人入住", self.community.checkInUserCount];
        [self _refreshWeatherInfo];
    }];
    
    [self startObserveObject:self forKeyPath:@"latestNoteInfo" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        NSString *title = self.latestNoteInfo ? self.latestNoteInfo.title : @"暂无最新公告";
        [self.latestNotifyB setTitle:title forState:UIControlStateNormal];
    }];
    
    [self startObserveObject:self forKeyPath:@"weatherInfoDic" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.weatherL && [self.weatherInfoDic count] > 0 && ![MKWStringHelper isNilEmptyOrBlankString:[self.weatherInfoDic objectForKey:@"weather"]] && ![MKWStringHelper isNilEmptyOrBlankString:[self.weatherInfoDic objectForKey:@"l_tmp"]] && ![MKWStringHelper isNilEmptyOrBlankString:[self.weatherInfoDic objectForKey:@"h_tmp"]]) {
            self.weatherL.text = [NSString stringWithFormat:@"%@ %@℃ ~ %@℃", [self.weatherInfoDic objectForKey:@"weather"], [self.weatherInfoDic objectForKey:@"l_tmp"], [self.weatherInfoDic objectForKey:@"h_tmp"]];
        }
    }];
}

- (void)_refreshCommunityInfo {
    _weak(self);
    [MainModel asyncGetCommunityInfoWithId:[[CommonModel sharedModel] currentCommunityId] cacheBlock:^(CommunityInfo *community, NSArray *buildList) {
        _strong(self);
        self.community = community;
    } remoteBlock:^(CommunityInfo *community, NSArray *buildList, NSError *error) {
        _strong(self);
        if (!error) {
            self.community = community;
        }
    }];
}

- (void)_refreshLatestNotify {
    _weak(self);
    [[PropertyServiceModel sharedModel] asyncCommunityNoteListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] pageIndex:@1 pageSize:@1 cacheBlock:nil remoteBlock:^(NSArray *list, NSNumber *cPage, NSError *error) {
        _strong(self);
        self.latestNoteInfo = !error && [list count] > 0 ? list[0] : nil;
    }];
}

- (void)_refreshWeatherInfo {
    _weak(self);
    [MainModel asyncGetWeatherInfoWithCityName:[CommonModel sharedModel].currentCommunity.city remoteBlock:^(NSDictionary *info, NSError *error) {
        _strong(self);
        if (!error) {
            self.weatherInfoDic = info;
        }
    }];
}

@end
