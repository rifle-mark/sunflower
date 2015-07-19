//
//  AroundChipAddressListVC.m
//  Sunflower
//
//  Created by mark on 15/5/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "AroundChipAddressListVC.h"
#import "ShopPicture.h"

#import <UIImageView+WebCache.h>


@interface CouponShopTableCell : UITableViewCell

@property(nonatomic,strong)UIImageView           *logoV;
@property(nonatomic,strong)UILabel               *nameL;
@property(nonatomic,strong)UILabel               *addL;

@property(nonatomic,strong)ShopPictureInfo       *shop;

@property(nonatomic,copy)void(^callBlcok)();


+ (NSString*)reuseIdentify;

@end

@implementation CouponShopTableCell

+(NSString *)reuseIdentify {
    return @"LCouponShopTableCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _weak(self);
        
        self.logoV = [[UIImageView alloc] init];
        self.logoV.layer.cornerRadius = 34;
        self.logoV.clipsToBounds = YES;
        [self.contentView addSubview:self.logoV];
        [self.logoV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(8);
            make.left.equalTo(self.contentView).with.offset(20);
            make.width.height.equalTo(@68);
        }];
        
        self.nameL = [[UILabel alloc] init];
        self.nameL.font = [UIFont boldSystemFontOfSize:15];
        self.nameL.textColor = k_COLOR_GALLERY_F;
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(19);
            make.left.equalTo(self.logoV.mas_right).with.offset(20);
            make.right.equalTo(self.contentView).with.offset(-88);
            make.height.equalTo(@15);
        }];
        
        self.addL = [[UILabel alloc] init];
        self.addL.font = [UIFont boldSystemFontOfSize:13];
        self.addL.textColor = k_COLOR_GALLERY_F;
        self.addL.numberOfLines = 2;
        [self.contentView addSubview:self.addL];
        [self.addL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(7);
            make.left.equalTo(self.nameL);
            make.right.equalTo(self.nameL);
            make.height.equalTo(@30);
        }];
        
        UIButton *callBtn = [[UIButton alloc] init];
        [callBtn setImage:[UIImage imageNamed:@"coupon_addr_call"] forState:UIControlStateNormal];
        [callBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.callBlcok);
        }];
        [self.contentView addSubview:callBtn];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.top.equalTo(self.contentView);
            make.width.height.equalTo(@88);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = k_COLOR_GALLERY;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.bottom.right.equalTo(self.contentView);
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
        [self.logoV sd_setImageWithURL:[APIGenerator urlOfPictureWith:68 height:68 urlString:self.shop.image] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.nameL.text = self.shop.name;
        self.addL.text = self.shop.address;
    }];
}

@end


@interface AroundChipAddressListVC ()

@property(nonatomic,strong)UITableView      *shopTableV;

@end

@implementation AroundChipAddressListVC

- (NSString *)umengPageName {
    return @"优惠券可用店铺列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_AroundChipAddressList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (self.shopTableV) {
        return;
    }
    
    self.shopTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        [v registerClass:[CouponShopTableCell class] forCellReuseIdentifier:[CouponShopTableCell reuseIdentify]];
        
        _weak(self);
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.shopArray count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 88;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            CouponShopTableCell *cell = [view dequeueReusableCellWithIdentifier:[CouponShopTableCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[CouponShopTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CouponShopTableCell reuseIdentify]];
            }
            
            cell.shop = self.shopArray[path.row];
            _weak(cell);
            cell.callBlcok = ^(){
                _strong(cell);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",cell.shop.tel]]];
            };
            [cell.logoV sd_setImageWithURL:[APIGenerator urlOfPictureWith:68 height:68 urlString:self.logoUrlStr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
            return cell;
        }];
        v;
    });
}

- (void)_layoutCodingViews {
    if ([self.shopTableV superview]) {
        return;
    }
    
    _weak(self);
    UIView *topTmp = [[UIView alloc] init];
    topTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:topTmp];
    [topTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(self.topLayoutGuide.length));
    }];
    UIView *botTmp = [[UIView alloc] init];
    botTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:botTmp];
    [botTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(self.bottomLayoutGuide.length));
    }];
    
    _weak(topTmp);
    _weak(botTmp);
    [self.view addSubview:self.shopTableV];
    [self.shopTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(topTmp);
        _strong(botTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];
}
@end
