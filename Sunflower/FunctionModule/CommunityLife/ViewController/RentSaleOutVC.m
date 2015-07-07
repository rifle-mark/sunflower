//
//  RentSaleOutVC.m
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "GCExtension.h"
#import <UIImageView+AFNetworking.h>
#import "CycleScrollView.h"
#import "SMPageControl.h"
#import <Masonry.h>

#import "CommunityLifeModel.h"
#import "CommonModel.h"

#import "RentSaleOutVC.h"

@interface RentSaleOutVC ()

@property(nonatomic,weak)IBOutlet UIView        *imageContainerV;
@property(nonatomic,weak)IBOutlet UILabel       *titleL;
@property(nonatomic,weak)IBOutlet UILabel       *priceL;
@property(nonatomic,weak)IBOutlet UIView        *detailContainerV;

@property(nonatomic,weak)IBOutlet UIImageView   *avatarV;
@property(nonatomic,weak)IBOutlet UILabel       *nickNameL;
@property(nonatomic,weak)IBOutlet UILabel       *timeL;

@property(nonatomic,strong)CycleScrollView      *imagesV;
@property(nonatomic,strong)SMPageControl        *imagesP;
@property(nonatomic,strong)UITextView           *detailT;

@property(nonatomic,strong)RentHouseInfo        *house;
@property(nonatomic,strong)NSArray              *imageArray;

@end

@implementation RentSaleOutVC

- (NSString *)umengPageName {
    return @"租凭信息-出租/出售详情";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_RentSaleOut";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncRentHouseWithId:self.houseId cacheBlock:nil remoteBlock:^(RentHouseInfo *info, NSArray *images, NSError *error) {
        _strong(self);
        if (!error) {
            self.house = info;
            self.imageArray = images;
        }
    }];
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _weak(self);
    [self.detailContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
    }];
    [self.imagesV setSize:ccs(V_W_(self.view), V_H_(self.imageContainerV)) position:ccp(0, 0) anchor:ccp(0, 0)];
    [self.imageContainerV addSubview:self.imagesV];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)_loadCodingViews {
    [self _setupImagesView];
    [self _setupDetailTextView];
}

#pragma mark - UI Control Action
- (IBAction)callBtnTap:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.house.userPhone]]];
}

- (IBAction)msgBtnTap:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", self.house.userPhone]]];
}

#pragma mark - private

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"house" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        // TODO:MAKEWEI FUCK TODO
        // update UI
        self.titleL.text = self.house.title;
        if ([self.house.type integerValue] == 1) {
            self.priceL.text = [NSString stringWithFormat:@"%@元/月", self.house.price];
        }
        else {
            self.priceL.text = [NSString stringWithFormat:@"%@万元", self.house.price];
        }
        [self.avatarV setImageWithURL:[NSURL URLWithString:self.house.adminAvatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.nickNameL.text = self.house.userName;
        self.timeL.text = [self.house.crateDate dateSplitBySplash];
        [self _setupDetailView];
    }];
    
    [self startObserveObject:self forKeyPath:@"imageArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        if ([self.imageArray count] <=1) {
            [self.imagesV stopAutoScroll];
        }
        else {
            [self.imagesV startAutoScroll];
        }
        
        self.imagesV.totalPagesCount = ^NSInteger(void) {
            _strong(self);
            if ([self.imageArray count] <= 0) {
                return 0;
            }
            return [self.imageArray count];
        };
        self.imagesP.numberOfPages = [self.imageArray count];
        CGSize size = [self.imagesP sizeForNumberOfPages:self.imagesP.numberOfPages];
        [self.imagesP setSize:size position:ccp(V_WM_(self.imagesV), V_Y1(self.imagesV)-15) anchor:ccp(0.5, 1)];
        
    }];
}

- (void)_setupImagesView {
    _weak(self);
    self.imagesV = ({
        CycleScrollView *v = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, V_W_(self.view), V_W_(self.view)/2) animationDuration:2];
        v;
    });
    self.imagesV.fetchContentViewAtIndex = ^UIView *(NSInteger idx) {
        _strong(self);
        UIImageView *retV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.imagesV.bounds), CGRectGetHeight(self.imagesV.frame))];
        if ([self.imageArray count] <= 0) {
            return retV;
        }
        if (idx >= 0 && idx < [self.imageArray count]) {
            [retV setImageWithURL:[NSURL URLWithString:((HouseImageInfo *)self.imageArray[idx]).image] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
        }
        else if (idx < 0) {
            [retV setImageWithURL:[NSURL URLWithString:((HouseImageInfo *)self.imageArray[self.imageArray.count - 1]).image] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
        }
        else {
            [retV setImageWithURL:[NSURL URLWithString:((HouseImageInfo *)self.imageArray[0]).image] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
        }
        return retV;
    };
    self.imagesP = ({
        SMPageControl *p = [[SMPageControl alloc] init];
        p.numberOfPages = 0;
        p.pageIndicatorTintColor = [UIColor lightGrayColor];
        p.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        p;
    });
    
    [self.imagesV addSubview:self.imagesP];
}

- (void)_setupDetailTextView {
    self.detailT = ({
        UITextView *t = [[UITextView alloc] init];
        [t setEditable:NO];
        [t setSelectable:YES];
        [t setShowsVerticalScrollIndicator:NO];
        [t setShowsHorizontalScrollIndicator:NO];
        [t setScrollEnabled:NO];
        t;
    });
}

- (void)_setupDetailView {
    if (!self.house) {
        return;
    }
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 4;
    ps.alignment = NSTextAlignmentLeft;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.lineHeightMultiple = 1;
    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps,};
    NSMutableString *detail = [[NSMutableString alloc] init];
    [detail appendString:[NSString stringWithFormat:@"区域板块：%@\n", @""]];
    [detail appendString:[NSString stringWithFormat:@"户型：%@室%@厅%@卫\n", self.house.room, self.house.hall, self.house.toilet]];
    [detail appendString:[NSString stringWithFormat:@"面积：%@平米\n", self.house.area]];
    [detail appendString:[NSString stringWithFormat:@"楼层：%@层\n", self.house.floor]];
    [detail appendString:[NSString stringWithFormat:@"装修：%@\n", self.house.fix]];
    [detail appendString:[NSString stringWithFormat:@"朝向：%@\n", self.house.orientation]];
    [detail appendString:[NSString stringWithFormat:@"可入住时间：%@\n", self.house.checkIn]];
    [detail appendString:[NSString stringWithFormat:@"描述：%@", self.house.rentDesc]];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:detail attributes:att];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(V_W_(self.view)-30, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    [self.detailT setSize:CGSizeMake(V_W_(self.view)-30, rect.size.height+15) position:ccp(15, 15) anchor:ccp(0, 0)];
    self.detailT.attributedText = str;
    [self.detailContainerV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(rect.size.height + 30));
    }];
    [self.detailContainerV addSubview:self.detailT];
}

@end
