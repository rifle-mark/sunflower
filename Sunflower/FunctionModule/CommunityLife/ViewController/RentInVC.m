//
//  RentSaleInVC.m
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "RentInVC.h"
#import "CommunityLifeModel.h"

#import <Masonry.h>
#import "GCExtension.h"
#import <UIImageView+AFNetworking.h>
#import "NSNumber+MKWDate.h"

@interface RentInVC ()

@property(nonatomic,weak)IBOutlet UILabel       *titleL;
@property(nonatomic,weak)IBOutlet UIView        *detailCV;
@property(nonatomic,weak)IBOutlet UILabel       *detailL;
@property(nonatomic,weak)IBOutlet UIImageView   *avataV;
@property(nonatomic,weak)IBOutlet UILabel       *nameL;
@property(nonatomic,weak)IBOutlet UILabel       *timeL;


@property(nonatomic,strong)RentHouseInfo        *house;

@end

@implementation RentInVC

- (NSString *)umengPageName {
    return @"租凭信息-求租详情";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_RentIn";
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
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _weak(self);
    [self.detailCV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI Control Action
- (IBAction)callBtnTap:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.house.userPhone]]];
}

- (IBAction)msgBtnTap:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", self.house.userPhone]]];
}

#pragma mark - Business Logic
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"house" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        self.titleL.text = self.house.title;
        self.avataV.clipsToBounds = YES;
        [self.avataV setImageWithURL:[NSURL URLWithString:self.house.userAvatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.nameL.text = self.house.userName;
        self.timeL.text = [self.house.crateDate dateSplitBySplash];
        [self _setupDetailView];
    }];
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
    NSDictionary *att = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps,};
    NSMutableString *detail = [[NSMutableString alloc] init];
    
    [detail appendString:[NSString stringWithFormat:@"求租描述：\n\n%@", self.house.rentDesc]];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:detail attributes:att];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(V_W_(self.view)-30, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    [self.detailL setSize:CGSizeMake(V_W_(self.view)-30, rect.size.height+15) position:ccp(15, 15) anchor:ccp(0, 0)];
    self.detailL.numberOfLines = 0;
    self.detailL.attributedText = str;
    [self.detailCV setFrameHeight:rect.size.height + 30];
}

@end
