//
//  ShopCouponListVC.m
//  Sunflower
//
//  Created by makewei on 15/5/23.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopCouponListVC.h"
#import "ShopCouponEditVC.h"
#import "AroundChipInfoVC.h"

#import "UserModel.h"
#import "CouponList.h"



@interface ShopCouponCell : UITableViewCell

@property(nonatomic,strong)UIImageView  *couponImgV;
@property(nonatomic,strong)UILabel      *nameL;
@property(nonatomic,strong)UILabel      *timeL;
@property(nonatomic,strong)UILabel      *usedL;
@property(nonatomic,strong)UIImageView  *arrowV;
@property(nonatomic,strong)UILabel      *coverL;

@property(nonatomic,strong)CouponListInfo    *coupon;

+ (NSString *)reuseIdentify;
@end

@implementation ShopCouponCell

+ (NSString *)reuseIdentify {
    return @"pc_shop_coupon_cell";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = k_COLOR_WHITE;
        
        _weak(self);
        self.couponImgV = ({
            UIImageView *v = [[UIImageView alloc] init];
            v;
        });
        [self.contentView addSubview:self.couponImgV];
        [self.couponImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.contentView).with.offset(8);
            make.top.equalTo(self.contentView).with.offset(8);
            make.width.equalTo(@123);
            make.height.equalTo(@85);
        }];
        
        self.coverL = ({
            UILabel *l = [[UILabel alloc] init];
            l.numberOfLines = 1;
            l.backgroundColor = [k_COLOR_GALLERY_F colorWithAlphaComponent:0.5];
            l.font = [UIFont boldSystemFontOfSize:16];
            l.textColor = k_COLOR_GALLERY_F;
            l.text = @"已过期";
            l;});
        [self.contentView addSubview:self.coverL];
        [self.coverL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.bottom.right.equalTo(self.couponImgV);
        }];
        [self.coverL setHidden:YES];
        
        self.nameL = ({
            UILabel *l = [[UILabel alloc] init];
            l.numberOfLines = 1;
            l.backgroundColor = k_COLOR_CLEAR;
            l.font = [UIFont boldSystemFontOfSize:18];
            l.minimumScaleFactor = 14;
            l.textColor = k_COLOR_BLUE;
            l;
        });
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.couponImgV.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-40);
            make.top.equalTo(self.contentView).with.offset(15);
            make.height.equalTo(@18);
        }];
        
        self.timeL = ({
            UILabel *l = [[UILabel alloc] init];
            l.numberOfLines = 1;
            l.backgroundColor = k_COLOR_CLEAR;
            l.font = [UIFont systemFontOfSize:14];
            l.textColor = k_COLOR_GALLERY_F;
            l;
        });
        [self.contentView addSubview:self.timeL];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.nameL);
            make.right.equalTo(self.contentView).with.offset(-40);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(10);
            make.height.equalTo(@14);
        }];
        self.usedL = ({
            UILabel *l = [[UILabel alloc] init];
            l.numberOfLines = 0;
            l.backgroundColor = k_COLOR_CLEAR;
            l.font = [UIFont systemFontOfSize:14];
            l.textColor = k_COLOR_GALLERY_F;
            l;
        });
        [self.contentView addSubview:self.usedL];
        [self.usedL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.nameL);
            make.right.equalTo(self.contentView).with.offset(-40);
            make.top.equalTo(self.timeL.mas_bottom).with.offset(1);
            make.height.equalTo(@14);
        }];
        
        self.arrowV = ({
            UIImageView *v = [[UIImageView alloc] init];
            v.image = [UIImage imageNamed:@"right_arrow"];
            v;
        });
        [self.contentView addSubview:self.arrowV];
        [self.arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@10);
            make.height.equalTo(@20);
        }];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"coupon" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.couponImgV setImageWithURL:[NSURL URLWithString:self.coupon.image] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
        self.nameL.text = self.coupon.name;
        self.timeL.text = [NSString stringWithFormat:@"有效期:%@", [self.coupon.endDate dateSplitByChinese]];
        self.usedL.text = [NSString stringWithFormat:@"已有%@人领取", self.coupon.useCount];
        if ([self.coupon.endDate doubleValue] < [[NSDate date] timeIntervalSince1970]) {
            [self.coverL setHidden:NO];
        }
        else {
            [self.coverL setHidden:YES];
        }
    }];
}

- (void)prepareForReuse {
    [self.coverL setHidden:YES];
}

@end

@interface ShopCouponListVC ()

@property(nonatomic,weak)IBOutlet UIView        *contentV;
@property(nonatomic,strong)UITableView          *couponTableV;
@property(nonatomic,strong)NSArray              *couponList;
@property(nonatomic,strong)NSNumber             *currentPage;
@property(nonatomic,strong)NSNumber             *pageSize;

@end

@implementation ShopCouponListVC
- (NSString *)umengPageName {
    return @"商户优惠券管理列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_ShopCouponList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = @1;
    self.pageSize = @20;
    [self _setupObserver];
    
    [self _refreshCouponList];
}

-(void)loadView {
    [super loadView];
    
    [self _loadCouponTableV];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCouponTableV];
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
    if ([segue.identifier isEqualToString:@"Segue_ShopCouponList_CouponInfo"]) {
        AroundChipInfoVC *vc = (AroundChipInfoVC*)segue.destinationViewController;
        if (sender) {
            CouponListInfo *coupon = (CouponListInfo *)sender;
            vc.couponId = coupon.couponId;
            vc.isManager = YES;
        }
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - UI
- (void)_loadCouponTableV {
    if (self.couponTableV) {
        return;
    }
    
    self.couponTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        [v registerClass:[ShopCouponCell class] forCellReuseIdentifier:[ShopCouponCell reuseIdentify]];
        
        _weak(self);
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 105;
        }];
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.couponList count];
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            ShopCouponCell *cell = [view dequeueReusableCellWithIdentifier:[ShopCouponCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[ShopCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ShopCouponCell reuseIdentify]];
            }
            cell.coupon = (CouponListInfo *)self.couponList[path.row];
            return cell;
        }];
        
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if (path.row < [self.couponList count]) {
                [self performSegueWithIdentifier:@"Segue_ShopCouponList_CouponInfo" sender:self.couponList[path.row]];
            }
        }];
        
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _refreshCouponList];
            
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMoreCouponList];
        }];
        v;
    });
}

- (void)_layoutCouponTableV {
    if ([self.couponTableV superview]) {
        return;
    }
    
    UIView *tmpv = [[UIView alloc] init];
    tmpv.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:tmpv];
    _weak(self);
    [tmpv mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(-1);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    UIView *ret = [[UIView alloc] init];
    ret.backgroundColor = k_COLOR_GALLERY;
    UIImageView *addIcon = [[UIImageView alloc] init];
    addIcon.image = [UIImage imageNamed:@"edit_add_icon"];
    [ret addSubview:addIcon];
    _weak(ret);
    [addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(ret);
        make.left.equalTo(ret).with.offset(15);
        make.centerY.equalTo(ret);
        make.width.height.equalTo(@20);
    }];
    UILabel *l = [[UILabel alloc] init];
    l.text = @"添加产品优惠";
    l.font = [UIFont boldSystemFontOfSize:16];
    l.textColor = k_COLOR_GALLERY_F;
    [ret addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(ret);
        make.left.equalTo(ret).with.offset(45);
        make.centerY.equalTo(ret);
        make.right.equalTo(ret).with.offset(-45);
        make.height.equalTo(@16);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
        [self performSegueWithIdentifier:@"Segue_PC_CouponList_CouponEdit" sender:nil];
    }];
    [ret addGestureRecognizer:tap];
    
    [self.contentV addSubview:ret];
    [ret mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.bottom.right.equalTo(self.contentV);
        make.height.equalTo(@40);
    }];
    
    [self.contentV addSubview:self.couponTableV];
    [self.couponTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(ret);
        make.left.top.right.equalTo(self.contentV);
        make.bottom.equalTo(ret.mas_top);
    }];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"couponList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.couponTableV reloadData];
    }];
}

- (void)_refreshCouponList {
    [self _loadCouponListAtPage:@1 pageSize:self.pageSize];
}

- (void)_loadMoreCouponList {
    [self _loadCouponListAtPage:@([self.currentPage integerValue]+1) pageSize:self.pageSize];
}

- (void)_loadCouponListAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[UserModel sharedModel] asyncGetShopCouponListWithPage:page pageSize:pageSize CacheBlock:^(NSArray *couponList) {
    } remoteBlock:^(NSArray *couponList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if (self.couponTableV.header.isRefreshing) {
            [self.couponTableV.header endRefreshing];
        }
        if (self.couponTableV.footer.isRefreshing) {
            [self.couponTableV.footer endRefreshing];
        }
        if (!error) {
            if ([cPage integerValue] == 1) {
                self.currentPage = cPage;
                self.couponList = couponList;
            }
            else {
                if ([couponList count] > 0) {
                    self.currentPage = cPage;
                    NSMutableArray *tmp = [self.couponList mutableCopy];
                    [tmp addObjectsFromArray:couponList];
                    self.couponList = tmp;
                }
            }
        }
    }];
}

@end
