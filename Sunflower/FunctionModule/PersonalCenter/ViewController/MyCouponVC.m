//
//  MyCouponVC.m
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MyCouponVC.h"

#import "UserModel.h"
#import "AroundChipInfoVC.h"

typedef NS_ENUM(NSUInteger, ShowCouponType) {
    ValidCoupon,
    UsedCoupon,
    ExpiredCoupon,
};

static NSInteger    c_PageSize = 10;

@interface MyCouponCell : UITableViewCell

@property(nonatomic,strong)CouponListInfo   *coupon;
@property(nonatomic,assign)ShowCouponType   couponType;
@property(nonatomic,assign)BOOL             isCouponEdit;
@property(nonatomic,assign)BOOL             isCouponSelected;

@property(nonatomic,strong)UIView           *contentV;
@property(nonatomic,strong)UIButton         *selectBtn;
@property(nonatomic,strong)UIButton         *deleteBtn;

@property(nonatomic,strong)UIView           *showV;
@property(nonatomic,strong)UIImageView      *topBgV;
@property(nonatomic,strong)UIImageView      *logoV;
@property(nonatomic,strong)UILabel          *titleL;
@property(nonatomic,strong)UILabel          *nameL;
@property(nonatomic,strong)UILabel          *useCountL;
@property(nonatomic,strong)UILabel          *endDateL;

@property(nonatomic,copy)void(^couponDeleteBlock)(CouponListInfo *coupon);
@property(nonatomic,copy)void(^couponSelectBlock)(CouponListInfo *coupon, BOOL isSelected);

+ (NSString *)reuseIdentify;
- (void)setIsCouponEdit:(BOOL)isCouponEdit animated:(BOOL)animate;
@end

@implementation MyCouponCell


+ (NSString *)reuseIdentify {
    return @"MyCouponCellIdentify";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _isCouponEdit = NO;
        _weak(self);
        self.contentV = [[UIView alloc] init];
        self.contentV.clipsToBounds = YES;
        [self.contentView addSubview:self.contentV];
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(13);
            make.right.equalTo(self.contentView).with.offset(-13);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.selectBtn = [[UIButton alloc] init];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_select_btn_n"] forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_select_btn_h"] forState:UIControlStateHighlighted];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_select_btn_s"] forState:UIControlStateSelected];
        [self.contentV addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.bottom.equalTo(self.contentV);
            make.width.equalTo(@37);
        }];
        [self.selectBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.selectBtn setSelected:!self.selectBtn.isSelected];
            GCBlockInvoke(self.couponSelectBlock, self.coupon, self.selectBtn.isSelected);
        }];
        
        self.deleteBtn = [[UIButton alloc] init];
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_delete_btn"] forState:UIControlStateNormal];
        [self.contentV addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.top.bottom.equalTo(self.contentV);
            make.width.equalTo(@50);
        }];
        [self.deleteBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.couponDeleteBlock, self.coupon);
        }];
        
        self.showV = [[UIView alloc] init];
        self.showV.backgroundColor = k_COLOR_CLEAR;
        [self.contentV addSubview:self.showV];
        [self.showV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentV);
        }];
        
        self.topBgV = [[UIImageView alloc] init];
        self.topBgV.userInteractionEnabled = YES;
        [self.showV addSubview:self.topBgV];
        [self.topBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.showV);
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
            make.right.equalTo(self.topBgV).with.offset(-24);
            make.height.equalTo(@20);
        }];
        
        self.nameL = [[UILabel alloc] init];
        self.nameL.font = [UIFont boldSystemFontOfSize:17];
        self.nameL.textColor = k_COLOR_COUPON_TEXT;
        self.nameL.adjustsFontSizeToFitWidth = YES;
        self.nameL.minimumScaleFactor = 14;
        [self.topBgV addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.topBgV).with.offset(96);
            make.left.equalTo(self.topBgV).with.offset(12);
            make.right.equalTo(self.topBgV).with.offset(-12);
            make.height.equalTo(@17);
        }];
        
        self.endDateL = [[UILabel alloc] init];
        self.endDateL.font = [UIFont systemFontOfSize:12];
        self.endDateL.textColor = k_COLOR_COUPON_TEXT;
        [self.topBgV addSubview:self.endDateL];
        [self.endDateL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.nameL);
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
        
        UISwipeGestureRecognizer *lswip = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            if (self.isCouponEdit) {
                return;
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    _strong(self);
                    make.left.equalTo(self.contentV).with.offset(-50);
                    make.top.bottom.equalTo(self.contentV);
                    make.width.equalTo(self.contentV);
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }];
        lswip.numberOfTouchesRequired = 1;
        lswip.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.showV addGestureRecognizer:lswip];
        
        UISwipeGestureRecognizer *rswip = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            if (self.isCouponEdit) {
                return;
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    _strong(self);
                    make.left.equalTo(self.contentV).with.offset(0);
                    make.top.bottom.equalTo(self.contentV);
                    make.width.equalTo(self.contentV);
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }];
        rswip.numberOfTouchesRequired = 1;
        rswip.direction = UISwipeGestureRecognizerDirectionRight;
        [self.showV addGestureRecognizer:rswip];
        
        [self _setupObserver];
        
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"coupon" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.logoV setImageWithURL:[NSURL URLWithString:self.coupon.logo] placeholderImage:nil];
        self.titleL.text = self.coupon.name;
        self.nameL.text = self.coupon.subTitle;
        self.endDateL.text = [NSString stringWithFormat:@"有效期:%@",[self.coupon.endDate dateSplitByChinese]];
        self.useCountL.text = [NSString stringWithFormat:@"已有%@人领取", self.coupon.useCount];
    }];
    
    [self startObserveObject:self forKeyPath:@"couponType" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.couponType == ValidCoupon) {
            self.topBgV.image = [UIImage imageNamed:@"valid_coupon_bg"];
        }
        
        if (self.couponType == UsedCoupon) {
            self.topBgV.image = [UIImage imageNamed:@"used_coupon_bg"];
        }
        
        if (self.couponType == ExpiredCoupon) {
            self.topBgV.image = [UIImage imageNamed:@"notstart_coupon_bg"];
        }
        
    }];
    
    [self startObserveObject:self forKeyPath:@"isCouponEdit" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _strong(self);
            [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentV).with.offset(self.isCouponEdit?37:0);
                make.top.bottom.width.equalTo(self.contentV);
            }];
            
            [self layoutIfNeeded];
        }];
    }];
}

- (BOOL)isCouponSelected {
    return [self.selectBtn isSelected];
}
- (void)setIsCouponSelected:(BOOL)isCouponSelected {
    [self.selectBtn setSelected:isCouponSelected];
}

- (void)setIsCouponEdit:(BOOL)isCouponEdit animated:(BOOL)animate {
    if (animate) {
        self.isCouponEdit = isCouponEdit;
    }
    else {
        _isCouponEdit = isCouponEdit;
    }
}
@end



@interface MyCouponVC ()
@property(nonatomic,weak)IBOutlet UIView        *contentV;

@property(nonatomic,strong)UIView               *choiceV;
@property(nonatomic,strong)UIButton             *validBtn;
@property(nonatomic,strong)UIButton             *usedBtn;
@property(nonatomic,strong)UIButton             *expiredBtn;
@property(nonatomic,strong)UITableView          *couponTableV;

@property(nonatomic,strong)NSNumber             *cValidPage;
@property(nonatomic,strong)NSNumber             *cUsedPage;
@property(nonatomic,strong)NSNumber             *cExpiredPage;
@property(nonatomic,strong)NSArray              *validCouponList;
@property(nonatomic,strong)NSArray              *usedCouponList;
@property(nonatomic,strong)NSArray              *expiredCouponList;
@property(nonatomic,assign)ShowCouponType       currentType;

@property(nonatomic,assign)BOOL                 isEdit;
@property(nonatomic,strong)NSMutableArray       *selectedCouponList;

@end


@implementation MyCouponVC

- (NSString *)umengPageName {
    return @"我的优惠券列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_MyCoupon";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentType = ValidCoupon;
    [self _setupObserver];
    
    [self _loadValidCouponAtPage:@1 pageSize:@(c_PageSize)];
    [self _loadUsedCouponAtPage:@1 pageSize:@(c_PageSize)];
    [self _loadExpiredCouponAtPage:@1 pageSize:@(c_PageSize)];
    self.cValidPage = @1;
    self.cUsedPage = @1;
    self.cExpiredPage = @1;
    
    self.selectedCouponList = [[NSMutableArray alloc] init];
    _isEdit = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_edit_btn"] style:UIBarButtonItemStyleBordered target:self action:@selector(_couponEditTap:)];
    editItem.tintColor = k_COLOR_WHITE;
    self.navigationItem.rightBarButtonItem = editItem;
    
    [self _loadChoiceView];
    [self _loadCouponTableV];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingSubviews];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_MyCoupon_CouponInfo"]) {
        if ([sender isKindOfClass:[CouponListInfo class]]) {
            AroundChipInfoVC *vc = (AroundChipInfoVC*)segue.destinationViewController;
            vc.couponId = ((CouponListInfo*)sender).couponId;
            vc.isManager = NO;
        }
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}


#pragma mark - UI Control Action
- (void)_couponEditTap:(id)sender {
    __block BOOL edit = !self.isEdit;
    _weak(self);
    if (!edit && [self.selectedCouponList count] > 0) {
        NSMutableArray *couponIdArray = [[NSMutableArray alloc] initWithCapacity:[self.selectedCouponList count]];
        for (CouponListInfo *info in self.selectedCouponList) {
            [couponIdArray addObject:info.couponId];
        }
        
        [[UserModel sharedModel] asyncDeleteMyCouponWithArray:couponIdArray remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
            _strong(self);
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"成功删除"];
                [self _refreshCouponList];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"操作失败"];
            }
            [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"navi_edit_btn"]];
            [self _setCouponListEdit:edit];
            self.isEdit = edit;
        }];
    }
    
    
    else if (!edit) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"navi_edit_btn"]];
        [self _setCouponListEdit:edit];
        self.isEdit = edit;
    }
    
    if (edit) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_cancel"]];
        [self _setCouponListEdit:edit];
        self.isEdit = edit;
    }
}

#pragma mark - data
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"validCouponList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.currentType == ValidCoupon) {
            [self.couponTableV reloadData];
        }
    }];
    
    [self startObserveObject:self forKeyPath:@"usedCouponList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.currentType == UsedCoupon) {
            [self.couponTableV reloadData];
        }
    }];
    
    [self startObserveObject:self forKeyPath:@"expiredCouponList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.currentType == ExpiredCoupon) {
            [self.couponTableV reloadData];
        }
    }];
    
    [self startObserveObject:self forKeyPath:@"currentType" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.couponTableV reloadData];
    }];
}
- (void)_loadValidCouponAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[UserModel sharedModel] asyncGetUserValidCouponAtPage:page pageSize:pageSize cacheBlock:^(NSArray *couponList) {
        
    } remoteBlock:^(NSArray *couponList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if ([self.couponTableV.header isRefreshing]) {
            [self.couponTableV.header endRefreshing];
        }
        if ([self.couponTableV.footer isRefreshing]) {
            [self.couponTableV.footer endRefreshing];
        }
        if (!error) {
            if ([cPage integerValue] == 1) {
                self.cValidPage = cPage;
                self.validCouponList = couponList;
                return;
            }
            if ([couponList count] > 0) {
                self.cValidPage = cPage;
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.validCouponList];
                [tmp addObjectsFromArray:couponList];
                self.validCouponList = tmp;
            }
            
        }
    }];
}

- (void)_loadUsedCouponAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[UserModel sharedModel] asyncGetUserUsedCouponAtPage:page pageSize:pageSize cacheBlock:^(NSArray *couponList) {
        
    } remoteBlock:^(NSArray *couponList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if ([self.couponTableV.header isRefreshing]) {
            [self.couponTableV.header endRefreshing];
        }
        if ([self.couponTableV.footer isRefreshing]) {
            [self.couponTableV.footer endRefreshing];
        }
        if (!error) {
            if ([cPage integerValue] == 1) {
                self.cUsedPage = cPage;
                self.usedCouponList = couponList;
                return;
            }
            if ([couponList count] > 0) {
                self.cUsedPage = cPage;
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.usedCouponList];
                [tmp addObjectsFromArray:couponList];
                self.usedCouponList = tmp;
            }
        }
    }];
}

- (void)_loadExpiredCouponAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[UserModel sharedModel] asyncGetUserExpiredCouponAtPage:page pageSize:pageSize cacheBlock:^(NSArray *couponList) {
        
    } remoteBlock:^(NSArray *couponList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if ([self.couponTableV.header isRefreshing]) {
            [self.couponTableV.header endRefreshing];
        }
        if ([self.couponTableV.footer isRefreshing]) {
            [self.couponTableV.footer endRefreshing];
        }
        if (!error) {
            if ([cPage integerValue] == 1) {
                self.cExpiredPage = cPage;
                self.expiredCouponList = couponList;
                return;
            }
            if ([couponList count] > 0) {
                self.cExpiredPage = cPage;
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.expiredCouponList];
                [tmp addObjectsFromArray:couponList];
                self.expiredCouponList = tmp;
            }
        }
    }];
}

- (void)_setCouponListEdit:(BOOL)edit {
    for (MyCouponCell *cell in [self.couponTableV visibleCells]) {
        cell.isCouponSelected = NO;
        cell.isCouponEdit = edit;
        [self.selectedCouponList removeAllObjects];
    }
}


#pragma mark - coding subviews
- (void)_loadChoiceView {
    self.choiceV = [[UIView alloc] init];
    self.choiceV.backgroundColor = k_COLOR_CLEAR;
    
    _weak(self);
    self.validBtn = [[UIButton alloc] init];
    [self.validBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_unused_n"] forState:UIControlStateNormal];
    [self.validBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_unused_s"] forState:UIControlStateHighlighted];
    [self.validBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_unused_s"] forState:UIControlStateSelected];
    [self.choiceV addSubview:self.validBtn];
    [self.validBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.choiceV).with.offset(13);
        make.centerY.equalTo(self.choiceV);
        make.width.equalTo(@67);
        make.height.equalTo(@22);
    }];
    [self.validBtn setSelected:YES];
    
    self.usedBtn = [[UIButton alloc] init];
    [self.usedBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_used_n"] forState:UIControlStateNormal];
    [self.usedBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_used_s"] forState:UIControlStateHighlighted];
    [self.usedBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_used_s"] forState:UIControlStateSelected];
    [self.choiceV addSubview:self.usedBtn];
    [self.usedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.validBtn.mas_right).with.offset(13);
        make.centerY.equalTo(self.choiceV);
        make.width.equalTo(@67);
        make.height.equalTo(@22);
    }];
    
    self.expiredBtn = [[UIButton alloc] init];
    [self.expiredBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_useless_n"] forState:UIControlStateNormal];
    [self.expiredBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_useless_s"] forState:UIControlStateHighlighted];
    [self.expiredBtn setBackgroundImage:[UIImage imageNamed:@"mycoupon_useless_s"] forState:UIControlStateSelected];
    [self.choiceV addSubview:self.expiredBtn];
    [self.expiredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.usedBtn.mas_right).with.offset(13);
        make.centerY.equalTo(self.choiceV);
        make.width.equalTo(@67);
        make.height.equalTo(@22);
    }];
    
    [self.validBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if ([self.validBtn isSelected]) {
            return;
        }
        
        [self.validBtn setSelected:YES];
        [self.usedBtn setSelected:NO];
        [self.expiredBtn setSelected:NO];
        self.currentType = ValidCoupon;
    }];
    
    [self.usedBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if ([self.usedBtn isSelected]) {
            return;
        }
        
        [self.usedBtn setSelected:YES];
        [self.validBtn setSelected:NO];
        [self.expiredBtn setSelected:NO];
        self.currentType = UsedCoupon;
    }];
    
    [self.expiredBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if ([self.expiredBtn isSelected]) {
            return;
        }
        
        [self.expiredBtn setSelected:YES];
        [self.usedBtn setSelected:NO];
        [self.validBtn setSelected:NO];
        self.currentType = ExpiredCoupon;
    }];
}

- (void)_loadCouponTableV {
    self.couponTableV = ({
        UITableView *v = [[UITableView alloc] init];
        [v registerClass:[MyCouponCell class] forCellReuseIdentifier:[MyCouponCell reuseIdentify]];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        _weak(self);
        
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _refreshCouponList];
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMoreCouponList];
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            if (self.currentType == ValidCoupon) {
                return [self.validCouponList count];
            }
            
            if (self.currentType == UsedCoupon) {
                return [self.usedCouponList count];
            }
            
            if (self.currentType == ExpiredCoupon) {
                return [self.expiredCouponList count];
            }
            
            return 0;
        }];
        
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 155;
        }];
        
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            MyCouponCell *cell = [view dequeueReusableCellWithIdentifier:[MyCouponCell reuseIdentify]];
            if (!cell) {
                cell = [[MyCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyCouponCell reuseIdentify]];
            }
            CouponListInfo *coupon = nil;
            if (self.currentType == ValidCoupon) {
                coupon = self.validCouponList[path.row];
            }
            if (self.currentType == UsedCoupon) {
                coupon = self.usedCouponList[path.row];
            }
            if (self.currentType == ExpiredCoupon) {
                coupon = self.expiredCouponList[path.row];
            }
            
            cell.coupon = coupon;
            [cell setIsCouponEdit:self.isEdit animated:NO];
            cell.couponType = self.currentType;
            cell.couponDeleteBlock = ^(CouponListInfo *coupon){
                _strong(self);
                [[UserModel sharedModel] asyncDeleteMyCouponWithId:coupon.couponId remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [self _refreshCouponList];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }
                }];
            };
            cell.couponSelectBlock = ^(CouponListInfo *coupon, BOOL isSelected) {
                _strong(self);
                if (isSelected) {
                    [self.selectedCouponList addObject:coupon];
                    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_delete"]];
                }
                else {
                    [self.selectedCouponList removeObject:coupon];
                    if ([self.selectedCouponList count] == 0) {
                        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_cancel"]];
                    }
                }
            };
            return cell;
        }];
        
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if (self.isEditing) {
                return;
            }
            
            CouponListInfo *coupon = nil;
            if (self.currentType == ValidCoupon) {
                coupon = self.validCouponList[path.row];
            }
            if (self.currentType == UsedCoupon) {
                coupon = self.usedCouponList[path.row];
            }
            if (self.currentType == ExpiredCoupon) {
                coupon = self.expiredCouponList[path.row];
            }
            [self performSegueWithIdentifier:@"Segue_MyCoupon_CouponInfo" sender:coupon];
        }];
        v;
    });
}

- (void)_layoutCodingSubviews {
    _weak(self);
    if (![self.choiceV superview]) {
        [self.contentV addSubview:self.choiceV];
        [self.choiceV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.equalTo(self.contentV);
            make.height.equalTo(@48);
        }];
    }
    
    if (![self.couponTableV superview]) {
        [self.contentV addSubview:self.couponTableV];
        [self.couponTableV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.choiceV.mas_bottom);
            make.left.right.bottom.equalTo(self.contentV);
        }];
    }
}

- (void)_refreshCouponList {
    if (self.currentType == ValidCoupon) {
        [self _loadValidCouponAtPage:@1 pageSize:@(c_PageSize)];
    }
    if (self.currentType == UsedCoupon) {
        [self _loadUsedCouponAtPage:@1 pageSize:@(c_PageSize)];
    }
    if (self.currentType == ExpiredCoupon) {
        [self _loadUsedCouponAtPage:@1 pageSize:@(c_PageSize)];
    }
}

- (void)_loadMoreCouponList {
    if (self.currentType == ValidCoupon) {
        [self _loadValidCouponAtPage:@([self.cValidPage integerValue] +1) pageSize:@(c_PageSize)];
    }
    
    if (self.currentType == UsedCoupon) {
        [self _loadUsedCouponAtPage:@([self.cUsedPage integerValue] +1) pageSize:@(c_PageSize)];
    }
    
    if (self.currentType == ExpiredCoupon) {
        [self _loadExpiredCouponAtPage:@([self.cExpiredPage integerValue] +1) pageSize:@(c_PageSize)];
    }
}

@end
