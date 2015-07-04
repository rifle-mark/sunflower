//
//  LifeInfoListVC.m
//  Sunflower
//
//  Created by makewei on 15/6/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "LifeInfoListVC.h"

#import "CommunityLifeModel.h"
#import "CommonModel.h"


@interface LifeInfoCell : UITableViewCell

@property(nonatomic,strong)UIImageView      *imageV;
@property(nonatomic,strong)UILabel          *nameL;
@property(nonatomic,strong)UILabel          *subTitleL;
@property(nonatomic,strong)UIImageView      *telIconV;
@property(nonatomic,strong)UILabel          *telL;

@property(nonatomic,strong)PropertyShopInfo *shop;

+ (NSString *)reuseIdentify;
@end

@implementation LifeInfoCell

+ (NSString *)reuseIdentify {
    return @"LifeInfoCellIdentify";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageV = [[UIImageView alloc] init];
        self.imageV.layer.borderColor = [k_COLOR_GALLERY_F CGColor];
        self.imageV.layer.borderWidth = 1;
        
        self.nameL = [[UILabel alloc] init];
        self.nameL.textColor = k_COLOR_GALLERY_F;
        self.nameL.font = [UIFont boldSystemFontOfSize:17];
        
        self.subTitleL = [[UILabel alloc] init];
        self.subTitleL.textColor = k_COLOR_GALLERY_F;
        self.subTitleL.font = [UIFont boldSystemFontOfSize:12];
        
        self.telIconV = [[UIImageView alloc] init];
        self.telIconV.image = [UIImage imageNamed:@""];
        
        self.telL = [[UILabel alloc] init];
        self.telL.textColor = k_COLOR_GALLERY_F;
        self.telL.font = [UIFont boldSystemFontOfSize:12];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = k_COLOR_GALLERY;
        
        _weak(self);
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(15);
            make.left.equalTo(self.contentView).with.offset(12);
            make.bottom.equalTo(self.contentView).with.offset(-20);
            make.width.equalTo(@77);
        }];
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.imageV.mas_right).with.offset(13);
            make.right.equalTo(self.contentView).with.offset(-20);
            make.top.equalTo(self.contentView).with.offset(17);
            make.height.equalTo(@17);
        }];
        [self.contentView addSubview:self.subTitleL];
        [self.subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(10);
            make.left.right.equalTo(self.nameL);
            make.height.equalTo(@12);
        }];
        [self.contentView addSubview:self.telIconV];
        [self.telIconV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.subTitleL.mas_bottom).with.offset(10);
            make.left.equalTo(self.nameL);
            make.width.height.equalTo(@25);
        }];
        [self.contentView addSubview:self.telL];
        [self.telL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.telIconV);
            make.left.equalTo(self.telIconV.mas_right).with.offset(5);
            make.right.equalTo(self.nameL);
            make.height.equalTo(@12);
        }];
        
        [self.contentView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"shop" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.imageV setImageWithURL:[NSURL URLWithString:self.shop.logo] placeholderImage:[UIImage imageNamed:@"default_placeholder"]];
        self.nameL.text = self.shop.name;
        self.subTitleL.text = self.shop.summary;
        self.telL.text = self.shop.tel;
    }];
}

@end

@interface LifeInfoListVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;
@property(nonatomic,strong)UITableView      *infoTableV;
@property(nonatomic,strong)NSArray          *shopList;
@property(nonatomic,strong)NSNumber         *currentPage;

@end

@implementation LifeInfoListVC

- (NSString *)umengPageName {
    return @"社区黄页";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_LifeInfoList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = @0;
    self.shopList = @[];
    [self _setupObserver];
    
    [self _refreshPropertyShopList];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (self.infoTableV) {
        return;
    }
    
    self.infoTableV = ({
        UITableView *v = [[UITableView alloc] init];
        [v registerClass:[LifeInfoCell class] forCellReuseIdentifier:[LifeInfoCell reuseIdentify]];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.showsVerticalScrollIndicator = NO;
        v.showsHorizontalScrollIndicator = NO;
        
        _weak(self);
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _refreshPropertyShopList];
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMorePropertyShop];
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            return [self.shopList count];
        }];
        
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 112;
        }];
        
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            LifeInfoCell *cell = [view dequeueReusableCellWithIdentifier:[LifeInfoCell reuseIdentify]];
            if (!cell) {
                cell = [[LifeInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[LifeInfoCell reuseIdentify]];
            }
            
            cell.shop = self.shopList[path.row];
            return cell;
        }];
        v;
    });
}

- (void)_layoutCodingViews {
    if ([self.infoTableV superview]) {
        return;
    }
    
    _weak(self);
    UIView *tmp = [[UIView alloc] init];
    tmp.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:tmp];
    [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(-1);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    [self.contentV addSubview:self.infoTableV];
    [self.infoTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.bottom.equalTo(self.contentV);
    }];
}

#pragma mark - Data
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"shopList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.infoTableV reloadData];
    }];
}

- (void)_refreshPropertyShopList {
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncInfoListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] page:@1 pageSize:@(10) cacheBlock:nil remoteBlock:^(NSArray *infoList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if (self.infoTableV.header.isRefreshing) {
            [self.infoTableV.header endRefreshing];
        }
        if ([self.infoTableV.footer isRefreshing]) {
            [self.infoTableV.footer endRefreshing];
        }
        if (!error) {
            self.currentPage = @1;
            self.shopList = infoList;
        }
    }];
}

- (void)_loadMorePropertyShop {
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncInfoListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] page:@([self.currentPage integerValue]+1) pageSize:@(10) cacheBlock:nil remoteBlock:^(NSArray *infoList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if (self.infoTableV.header.isRefreshing) {
            [self.infoTableV.header endRefreshing];
        }
        if ([self.infoTableV.footer isRefreshing]) {
            [self.infoTableV.footer endRefreshing];
        }
        if (!error) {
            if ([infoList count] > 0) {
                self.currentPage = cPage;
                NSMutableArray *tmp = [self.shopList mutableCopy];
                [tmp addObjectsFromArray:infoList];
                self.shopList = tmp;
            }
        }
    }];
}

@end
