//
//  AroundChipListVC.m
//  Sunflower
//
//  Created by mark on 15/5/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//


#import "PropertyServiceModel.h"
#import "CommonModel.h"
#import "UserModel.h"
#import "CouponList.h"
#import "NSNumber+MKWDate.h"

#import "CouponTableCell.h"
#import "AroundChipListVC.h"
#import "AroundChipInfoVC.h"


typedef NS_ENUM(NSUInteger, CouponState) {
    ValidForAdd,
    AlreadyAdd,
    HasUsed,
    NotStart,
    HasFinished
};

@interface CouponListCell : UITableViewCell

@property(nonatomic,strong)CouponListInfo   *coupon;
@property(nonatomic,assign)CouponState      couponState;

@property(nonatomic,strong)UIImageView      *topBgV;
@property(nonatomic,strong)UIImageView      *logoV;
@property(nonatomic,strong)UILabel          *titleL;
@property(nonatomic,strong)UILabel          *nameL;
@property(nonatomic,strong)UILabel          *useCountL;
@property(nonatomic,strong)UIButton         *stateBtn;
@property(nonatomic,strong)UILabel          *endDateL;

@property(nonatomic,copy)void(^getCouponBlock)();

+ (NSString *)reuseIdentify;
@end

@implementation CouponListCell


+ (NSString *)reuseIdentify {
    return @"CouponListCellIdentify";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _weak(self);
        self.topBgV = [[UIImageView alloc] init];
        self.topBgV.userInteractionEnabled = YES;
        [self.contentView addSubview:self.topBgV];
        [self.topBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(13);
            make.right.equalTo(self.contentView).with.offset(-13);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.logoV = [[UIImageView alloc] init];
        self.logoV.layer.borderWidth = 1;
        self.logoV.layer.borderColor = [k_COLOR_WHITE CGColor];
        self.logoV.layer.cornerRadius = 30;
        self.logoV.clipsToBounds = YES;
        [self.topBgV addSubview:self.logoV];
        [self.logoV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.topBgV).with.offset(12);
            make.left.equalTo(self.topBgV).with.offset(17);
            make.width.height.equalTo(@60);
        }];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.font = [UIFont boldSystemFontOfSize:20];
        self.titleL.textColor = k_COLOR_WHITE;
        self.titleL.adjustsFontSizeToFitWidth = YES;
        self.titleL.minimumScaleFactor = 16;
        [self.topBgV addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.logoV);
            make.left.equalTo(self.logoV.mas_right).with.offset(24);
            make.right.equalTo(self.topBgV).with.offset(24);
            make.height.equalTo(@20);
        }];
        
        self.stateBtn = [[UIButton alloc] init];
        [self.stateBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if (self.couponState == ValidForAdd) {
                GCBlockInvoke(self.getCouponBlock);
            }
        }];
        [self.topBgV addSubview:self.stateBtn];
        [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.topBgV).with.offset(-10);
            make.top.equalTo(self.topBgV).with.offset(96);
            make.width.equalTo(@86);
            make.height.equalTo(@23);
        }];
        
        self.nameL = [[UILabel alloc] init];
        self.nameL.font = [UIFont boldSystemFontOfSize:17];
        self.nameL.textColor = k_COLOR_COUPON_TEXT;
        self.nameL.adjustsFontSizeToFitWidth = YES;
        self.nameL.minimumScaleFactor = 14;
        [self.topBgV addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.stateBtn);
            make.left.equalTo(self.topBgV).with.offset(12);
            make.right.equalTo(self.stateBtn.mas_left).with.offset(-10);
            make.height.equalTo(@17);
        }];
        
        self.endDateL = [[UILabel alloc] init];
        self.endDateL.font = [UIFont systemFontOfSize:12];
        self.endDateL.textColor = k_COLOR_COUPON_TEXT;
        [self.topBgV addSubview:self.endDateL];
        [self.endDateL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.stateBtn);
            make.width.equalTo(@142);
            make.height.equalTo(@12);
            make.bottom.equalTo(self.topBgV).with.offset(-9);
        }];
        
        self.useCountL = [[UILabel alloc] init];
        self.useCountL.font = [UIFont systemFontOfSize:12];
        self.useCountL.textColor = k_COLOR_COUPON_TEXT;
        [self.topBgV addSubview:self.useCountL];
        [self.useCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.nameL);
            make.centerY.equalTo(self.endDateL);
            make.right.equalTo(self.endDateL.mas_left).with.offset(-10);
            make.height.equalTo(@12);
        }];
        
        [self _setupObserver];
        
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"coupon" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.logoV setImageWithURL:[NSURL URLWithString:self.coupon.logo] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.titleL.text = self.coupon.name;
        self.nameL.text = self.coupon.subTitle;
        self.endDateL.text = [NSString stringWithFormat:@"有效期:%@",[self.coupon.endDate dateSplitByChinese]];
        self.useCountL.text = [NSString stringWithFormat:@"已有%@人领取", self.coupon.useCount];
    }];
    
    [self startObserveObject:self forKeyPath:@"couponState" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        switch (self.couponState) {
            case ValidForAdd: {
                self.topBgV.image = [UIImage imageNamed:@"valid_coupon_bg"];
                [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"valid_coupon_btn"] forState:UIControlStateNormal];
                [self.stateBtn setEnabled:YES];
                break;
            }
            case AlreadyAdd: {
                self.topBgV.image = [UIImage imageNamed:@"valid_coupon_bg"];
                [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"got_coupon_btn"] forState:UIControlStateDisabled];
                [self.stateBtn setEnabled:NO];
                break;
            }
            case NotStart: {
                self.topBgV.image = [UIImage imageNamed:@"notstart_coupon_bg"];
                [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"notstart_coupon_btn"] forState:UIControlStateDisabled];
                [self.stateBtn setEnabled:NO];
                break;
            }
            case HasFinished: {
                self.topBgV.image = [UIImage imageNamed:@"finished_coupon_bg"];
                [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"finished_coupon_btn"] forState:UIControlStateDisabled];
                [self.stateBtn setEnabled:NO];
                break;
            }
            case HasUsed: {
                self.topBgV.image = [UIImage imageNamed:@"used_coupon_bg"];
                [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"used_coupon_btn"] forState:UIControlStateDisabled];
                [self.stateBtn setEnabled:NO];
                break;
            }
            default:
                break;
        }
    }];
}
@end


static NSArray *normalImages;
static NSArray *hilightImages;

@interface AroundChipListVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;

@property(nonatomic,strong)UITableView      *couponTableView;

@property(nonatomic,strong)NSArray          *couponArray;
@property(nonatomic,strong)NSNumber         *currentPage;

@end

@implementation AroundChipListVC

+ (void)initialize {
    normalImages = @[@"cl_little_all",
                     @"cl_little_yi",
                     @"cl_little_shi",
                     @"cl_little_zhu",
                     @"cl_little_xing",
                     @"cl_little_le",
                     @"cl_little_xiang"];
    
    hilightImages = @[@"cl_little_all_s",
                      @"cl_little_yi_s",
                      @"cl_little_shi_s",
                      @"cl_little_zhu_s",
                      @"cl_little_xing_s",
                      @"cl_little_le_s",
                      @"cl_little_xiang_s"];
}

- (NSString *)umengPageName {
    return @"周边优惠列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_AroundChipList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    
    [self _reloadCouponList];
    
}

- (void)loadView {
    [super loadView];
    
    [self _loadCouponTableV];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (NSInteger i = 0; i<7; i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:(110001+i)];
        if (i == self.type) {
            [btn setBackgroundImage:[UIImage imageNamed:hilightImages[i]] forState:UIControlStateNormal];
        }
        else {
            [btn setBackgroundImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
        }
    }
    
    [self _layoutCouponTableV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}


- (IBAction)couponTypeTap:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSInteger idx = btn.tag - 110001;

    if (self.type == (CouponType)idx) {
        return;
    }
    self.type = (CouponType)idx;
    
    
    for (NSInteger i = 0; i<7; i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:(110001+i)];
        if (i == idx) {
            [btn setBackgroundImage:[UIImage imageNamed:hilightImages[i]] forState:UIControlStateNormal];
        }
        else {
            [btn setBackgroundImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
        }
    }
    
    [self _reloadCouponList];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_CouponList_CouponInfo"]) {
        CouponListCell *cell = (CouponListCell*)sender;
        ((AroundChipInfoVC*)segue.destinationViewController).couponId = cell.coupon.couponId;
    }
}

#pragma mark - private method
- (void)_setupObserver {
    
    _weak(self);
    [self startObserveObject:self forKeyPath:@"couponArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.couponTableView reloadData];
    }];
}

- (void)_reloadCouponList {
    self.currentPage = @1;
    [self _loadCouponListAtPage:self.currentPage];
}

- (void)_loadMoreCouponList {
    [self _loadCouponListAtPage:@([self.currentPage integerValue] + 1)];
}

- (void)_loadCouponListAtPage:(NSNumber *)page {
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncCouponListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] pageIndex:page pageSize:@10 type:self.type cacheBlock:^(NSArray *list) {
        //TODO
    } remoteBlock:^(NSArray *list, NSError *error) {
        _strong(self);
        
        if (self.couponTableView.header.isRefreshing) {
            [self.couponTableView.header endRefreshing];
        }
        
        if (self.couponTableView.footer.isRefreshing) {
            [self.couponTableView.footer endRefreshing];
        }
        
        if (!error) {
            self.currentPage = page;
            if ([page integerValue] == 1) {
                self.couponArray = list;
                return;
            }
            
            NSMutableArray *tmp = [self.couponArray mutableCopy];
            [tmp addObjectsFromArray:list];
            self.couponArray = tmp;
        }
    }];
}


#pragma mark - TableView

- (void)_loadCouponTableV {
    self.couponTableView = ({
        UITableView *v = [[UITableView alloc] init];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        [v registerClass:[CouponListCell class] forCellReuseIdentifier:[CouponListCell reuseIdentify]];
        _weak(self);
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _reloadCouponList];
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMoreCouponList];
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            if ([self.couponArray count] <= 0) {
                return 1;
            }
            return [self.couponArray count];
        }];
        
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 155;
        }];
        
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            if ([self.couponArray count] <= 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                return cell;
            }
            
            CouponListCell *cell = [view dequeueReusableCellWithIdentifier:[CouponListCell reuseIdentify]];
            if (!cell) {
                cell = [[CouponListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CouponListCell reuseIdentify]];
            }
            CouponListInfo *coupon = (CouponListInfo*)self.couponArray[path.row];
            cell.coupon = coupon;
            cell.couponState = [coupon.state integerValue];
            _weak(coupon);
            _weak(cell);
            cell.getCouponBlock = ^(){
                _strong(coupon);
                _strong(cell);
                if ([coupon.state integerValue] != 0) {
                    return;
                }
                
                if (![[UserModel sharedModel] isNormalLogined]) {
                    [SVProgressHUD showErrorWithStatus:@"请先登录"];
                    return;
                }
                
                [[UserModel sharedModel] asyncAddUserCouponWithId:coupon.couponId remoteBlock:^(BOOL isSuccess, NSString *couponCode, NSString *msg, NSError *error) {
                    if (!error) {
                        [UserPointHandler addUserPointWithType:CouponGet showInfo:NO];
                        [SVProgressHUD showSuccessWithStatus:@"成功领取优惠券"];
                        cell.couponState = AlreadyAdd;
                        return;
                    }
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"领取失败\n%@", msg]];
                }];
            };
            return cell;
        }];
        
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            if ([self.couponArray count] <= 0) {
                return;
            }
            
            CouponListCell *cell = (CouponListCell*)[self.couponTableView cellForRowAtIndexPath:path];
            [cell setSelected:NO animated:YES];
            [self performSegueWithIdentifier:@"Segue_CouponList_CouponInfo" sender:cell];
        }];
        v;
    });
}

- (void)_layoutCouponTableV {
    if ([self.couponTableView superview]) {
        return;
    }
    
    [self.contentV addSubview:self.couponTableView];
    _weak(self);
    [self.couponTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.left.right.bottom.equalTo(self.contentV);
    }];
}

@end
