//
//  LifeServiceInfoVC.m
//  Sunflower
//
//  Created by mark on 15/5/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//
#import "GCExtension.h"
#import <UIImageView+AFNetworking.h>

#import "LifeServiceInfoVC.h"

#import "CommunityLifeModel.h"
#import "MKWColorHelper.h"
#import "MKWWebVC.h"

@interface LifeServiceInfoVC ()

@property(nonatomic,weak)IBOutlet UIImageView       *serviceImageV;
@property(nonatomic,weak)IBOutlet UILabel           *serviceNameL;
@property(nonatomic,weak)IBOutlet UILabel           *serviceSubTitleL;
@property(nonatomic,weak)IBOutlet UILabel           *serviceDesTitleL;
@property(nonatomic,weak)IBOutlet UITextView        *serviceDetailT;
@property(nonatomic,weak)IBOutlet UIButton          *serviceOrderBtn;
@property(nonatomic,weak)IBOutlet UIButton          *serviceCallBtn;

@end

@implementation LifeServiceInfoVC

- (NSString *)umengPageName {
    return @"生活服务详情";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_LifeServiceInfo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.serviceImageV.contentMode = UIViewContentModeScaleToFill;
    self.serviceImageV.clipsToBounds = YES;
    [self _setupObserver];
    
    [CommunityLifeModel sharedModel] ;
    self.navigationItem.title = self.lifeServer.title;
}

- (void)loadView {
    [super loadView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.serviceImageV sd_setImageWithURL:[NSURL URLWithString:self.lifeServer.banner] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
    self.serviceNameL.text = self.lifeServer.title;
    self.serviceSubTitleL.text = self.lifeServer.subTitle;
    self.serviceDesTitleL.text = [NSString stringWithFormat:@"%@服务介绍", self.lifeServer.title];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 4;
    ps.paragraphSpacing = 6;
    ps.paragraphSpacingBefore = 4;
    self.serviceDetailT.attributedText = [[NSAttributedString alloc] initWithString:self.lifeServer.serverDesc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:RGB(78, 78, 78), NSParagraphStyleAttributeName:ps}];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_LifeService_Web"]) {
        NSString *url = sender;
        MKWWebVC *webVC = (MKWWebVC*)segue.destinationViewController;
        webVC.url = [NSURL URLWithString:url];
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}


#pragma mark - Business Logic
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"lifeServer" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.serviceImageV sd_setImageWithURL:[NSURL URLWithString:self.lifeServer.banner] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
        self.serviceNameL.text = self.lifeServer.title;
        self.serviceSubTitleL.text = self.lifeServer.subTitle;
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        ps.lineSpacing = 4;
        ps.paragraphSpacing = 6;
        ps.paragraphSpacingBefore = 4;
        self.serviceDetailT.attributedText = [[NSAttributedString alloc] initWithString:self.lifeServer.serverDesc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:RGB(78, 78, 78), NSParagraphStyleAttributeName:ps}];
    }];
}

#pragma mark - UI Control Action
- (IBAction)orderBtnTap:(id)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.lifeServer.url]];
    [self performSegueWithIdentifier:@"Segue_LifeService_Web" sender:self.lifeServer.url];
}

- (IBAction)callBtnTap:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.lifeServer.tel]]];
}

@end
