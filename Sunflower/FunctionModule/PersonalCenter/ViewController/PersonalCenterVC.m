//
//  PersonalCenterVC.m
//  Sunflower
//
//  Created by mark on 15/5/7.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "WeCommentListVC.h"
#import "NormalRegisterVC.h"
#import "ContractVC.h"
#import "FindPasswdVC.h"
#import "APIGenerator.h"

#import "UserModel.h"
#import "ServerProxy.h"

@interface PersonalCenterVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

//
@property(nonatomic,weak)IBOutlet UIView            *normalV;
@property(nonatomic,weak)IBOutlet UIScrollView      *pcScrollV;
@property(nonatomic,weak)IBOutlet UIView            *pcContentV;
@property(nonatomic,weak)IBOutlet UIImageView       *avatarV;
@property(nonatomic,weak)IBOutlet UIView            *userInfoV;
@property(nonatomic,weak)IBOutlet UILabel           *nickNameL;
@property(nonatomic,weak)IBOutlet UILabel           *timeL;
@property(nonatomic,weak)IBOutlet UIButton          *editBtn;
@property(nonatomic,weak)IBOutlet UIView            *loginV;
@property(nonatomic,weak)IBOutlet UIButton          *loginBtn;
@property(nonatomic,weak)IBOutlet UIView            *midV;
@property(nonatomic,weak)IBOutlet UILabel           *couponCountL;
@property(nonatomic,weak)IBOutlet UILabel           *userPointsL;
@property(nonatomic,strong)UIButton                 *orderBtn;
@property(nonatomic,strong)UIButton                 *recorderBtn;
@property(nonatomic,strong)UIButton                 *rentBtn;
@property(nonatomic,strong)UIButton                 *weiBtn;
@property(nonatomic,strong)UIButton                 *fixBtn;
@property(nonatomic,strong)UIButton                 *pointBtn;
@property(nonatomic,strong)UIButton                 *contractBtn;
@property(nonatomic,strong)UIButton                 *aboutBtn;
@property(nonatomic,strong)UIButton                 *quitBtn;
@property(nonatomic,strong)UIView                   *pcLoginNoteV;

//
@property(nonatomic,weak)IBOutlet UIView            *businessV;
@property(nonatomic,weak)IBOutlet UIView            *businessScroConV;
@property(nonatomic,weak)IBOutlet UIView            *businessLoginV;
@property(nonatomic,weak)IBOutlet UILabel           *businessNameL;
@property(nonatomic,weak)IBOutlet UIImageView       *businessAvatarV;
@property(nonatomic,weak)IBOutlet UITextField       *bloginNameT;
@property(nonatomic,weak)IBOutlet UITextField       *bloginPasswdT;
@property(nonatomic,weak)IBOutlet UIButton          *businessContractBtn;

//
@property(nonatomic,weak)IBOutlet UIView            *propertyV;
@property(nonatomic,weak)IBOutlet UIView            *propertyLoginV;
@property(nonatomic,weak)IBOutlet UILabel           *propertyNameL;
@property(nonatomic,weak)IBOutlet UIImageView       *propertyAvatarV;
@property(nonatomic,weak)IBOutlet UITextField       *ploginNameT;
@property(nonatomic,weak)IBOutlet UITextField       *ploginPasswdT;

@property(nonatomic,weak)UITextField                *focusedField;

@property(nonatomic,strong)UserInfo                 *normalUser;
@property(nonatomic,strong)AdminUserInfo            *adminUser;

@end

@implementation PersonalCenterVC

- (NSString *)umengPageName {
    return @"个人中心首页";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([UserModel sharedModel].isNormalLogined) {
        self.normalUser = [UserModel sharedModel].currentNormalUser;
        self.userPointsL.text = [self.normalUser.points stringValue];
        self.couponCountL.text = [self.normalUser.couponCount stringValue];
    }
    
    [self _setupObserver];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        if (self.focusedField) {
            [self.focusedField resignFirstResponder];
        }
        return NO;
    }];
    [self.view addGestureRecognizer:tap];
    
    self.pcScrollV.showsVerticalScrollIndicator = NO;
    self.pcScrollV.showsHorizontalScrollIndicator = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView {
    [super loadView];
    
    [self _loadPCSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _refreshLoginState];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _weak(self);
    [self.businessScroConV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
    }];
    
    [self _layoutPCSubViews];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_PC_WeiCommunity"]) {
        ((WeCommentListVC*)segue.destinationViewController).isMine = YES;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_PCCenter_Register"]) {
        ((NormalRegisterVC*)segue.destinationViewController).type = BusinessUser;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_PCCenter_FindPassword"]) {
       ((FindPasswdVC*)segue.destinationViewController).type = BusinessUser;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_PC_Contract"]) {
        if ([sender isEqual:self.contractBtn]) {
            ((ContractVC*)segue.destinationViewController).url = [NSURL URLWithString:[APIGenerator apiAddressWithSuffix:k_API_USER_ANNOUNCE]];
            return;
        }
        else if ([sender isEqual:self.businessContractBtn]) {
            ((ContractVC*)segue.destinationViewController).url = [NSURL URLWithString:[APIGenerator apiAddressWithSuffix:k_API_BUSINESS_ANNOUNCE]];
        }
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - UI Control Action

- (IBAction)viewTap:(id)sender {
    if (self.focusedField) {
        [self.focusedField resignFirstResponder];
    }
}

- (IBAction)normalUserBtnTap:(id)sender {
    [self.view bringSubviewToFront:self.normalV];
}

- (IBAction)businessBtnTap:(id)sender {
    [self.view bringSubviewToFront:self.businessV];
}

- (IBAction)propertyBtnTap:(id)sender {
    [self.view bringSubviewToFront:self.propertyV];
}

- (IBAction)normalUserCheckInTap:(id)sender {
    if (![UserModel sharedModel].isNormalLogined) {
        return;
    }
    
    [UserPointHandler addUserPointWithType:CheckIn showInfo:YES];
}

- (IBAction)businessLogOutTap:(id)sender {
    if (![[UserModel sharedModel] isBusinessAdminLogined]) {
        [SVProgressHUD showInfoWithStatus:@"您尚未登录"];
        return;
    }

    [[UserModel sharedModel] adminLogOutWithType:Business];
}

- (IBAction)propertyLogOutTap:(id)sender {
    if (![[UserModel sharedModel] isPropertyAdminLogined]) {
        [SVProgressHUD showInfoWithStatus:@"您尚未登录"];
        return;
    }
    
    [[UserModel sharedModel] adminLogOutWithType:Property];
    
    [SVProgressHUD showSuccessWithStatus:@"小区设置已切换为您的生活小区"];
}

- (IBAction)businessForgetPasswdTap:(id)sender {
    [self performSegueWithIdentifier:@"Segue_PCCenter_FindPassword" sender:sender];
}

- (IBAction)businessContractTap:(id)sender {
    [self performSegueWithIdentifier:@"Segue_PC_Contract" sender:sender];
}
- (IBAction)businessRegistTap:(id)sender {
    [self performSegueWithIdentifier:@"Segue_PCCenter_Register" sender:sender];
}

- (IBAction)businessLoginTap:(id)sender {
    NSString *name = [MKWStringHelper trimWithStr:self.bloginNameT.text];
    if ([MKWStringHelper isNilEmptyOrBlankString:name]) {
        [SVProgressHUD showErrorWithStatus:@"请输入帐号"];
        return;
    }
    if ([MKWStringHelper isNilEmptyOrBlankString:self.bloginPasswdT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (self.focusedField) {
        [self.focusedField resignFirstResponder];
    }
    
    if ([[UserModel sharedModel] isPropertyAdminLogined]) {
        [SVProgressHUD showErrorWithStatus:@"请先退出商家用户"];
        return;
    }
    
    [[UserModel sharedModel] adminLoginWithUserName:name password:self.bloginPasswdT.text type:Business remoteBlock:^(AdminUserInfo *admin, NSError *error) {
        if (!error && admin && [admin.adminType integerValue] == Business) {
            self.adminUser = admin;
            self.bloginNameT.text = @"";
            self.bloginPasswdT.text = @"";
        }
        else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"登录失败:%@", [error domain]]];
        }
    }];
}

- (IBAction)propertyLoginTap:(id)sender {
    NSString *name = [MKWStringHelper trimWithStr:self.ploginNameT.text];
    if ([MKWStringHelper isNilEmptyOrBlankString:name]) {
        [SVProgressHUD showErrorWithStatus:@"请输入帐号"];
        return;
    }
    if ([MKWStringHelper isNilEmptyOrBlankString:self.ploginPasswdT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (self.focusedField) {
        [self.focusedField resignFirstResponder];
    }
    
    if ([[UserModel sharedModel] isBusinessAdminLogined]) {
        [SVProgressHUD showErrorWithStatus:@"请先退出物业用户"];
        return;
    }

    [[UserModel sharedModel] adminLoginWithUserName:name password:self.ploginPasswdT.text type:Property remoteBlock:^(AdminUserInfo *admin, NSError *error) {
        if (!error && admin && [admin.adminType integerValue] == Property) {
            self.adminUser = admin;
            self.ploginNameT.text = @"";
            self.ploginPasswdT.text = @"";
            
            [SVProgressHUD showSuccessWithStatus:@"小区设置已切换为您的服务小区"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"登录失败:%@", [error domain]]];
        }
    }];
}

#pragma mark - Business Logic
- (void)_setupObserver {
    _weak(self);
    [self addObserverForNotificationName:k_NOTIFY_NAME_USER_REGISTER usingBlock:^(NSNotification *notification) {
        _strong(self);
        self.normalUser = [[UserModel sharedModel] currentNormalUser];
        [self.loginV setHidden:YES];
        self.couponCountL.text = [self.normalUser.couponCount stringValue];
        self.userPointsL.text = [self.normalUser.points stringValue];
        [self.pcLoginNoteV setHidden:YES];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_USER_LOGIN usingBlock:^(NSNotification *notification) {
        _strong(self);
        self.normalUser = [[UserModel sharedModel] currentNormalUser];
        self.couponCountL.text = [self.normalUser.couponCount stringValue];
        self.userPointsL.text = [self.normalUser.points stringValue];
        [self.loginV setHidden:YES];
        [self.pcLoginNoteV setHidden:YES];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_USER_LOGOUT_NORMAL usingBlock:^(NSNotification *notification) {
        _strong(self);
        [self.loginV setHidden:NO];
        [self.pcLoginNoteV setHidden:NO];
        self.couponCountL.text = @"";
        self.userPointsL.text = @"";
        [self.avatarV setImage:[UIImage imageNamed:@"default_avatar"]];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_USER_INFO_UPDATE usingBlock:^(NSNotification *notification) {
        _strong(self);
        self.normalUser = [[UserModel sharedModel] currentNormalUser];
        self.nickNameL.text = self.normalUser.nickName;
        [self.avatarV setImageWithURL:[NSURL URLWithString:self.normalUser.avatar] placeholderImage:nil];
        self.couponCountL.text = [self.normalUser.couponCount stringValue];
        self.userPointsL.text = [self.normalUser.points stringValue];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_BUSINESS_USER_LOGIN usingBlock:^(NSNotification *notification) {
        _strong(self);
        self.adminUser = [[UserModel sharedModel] currentAdminUser];
        [self.businessLoginV setHidden:YES];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_BUSINESS_USER_REGISTER usingBlock:^(NSNotification *notification) {
        _strong(self);
        self.adminUser = [[UserModel sharedModel] currentAdminUser];
        [self.businessLoginV setHidden:YES];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_BUSINESS_USER_LOGOUT usingBlock:^(NSNotification *notification) {
        _strong(self);
        [self.businessLoginV setHidden:NO];
        [self.businessAvatarV setImage:[UIImage imageNamed:@"default_avatar"]];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_PROPERTY_USER_LOGIN usingBlock:^(NSNotification *notification) {
        _strong(self);
        self.adminUser = [[UserModel sharedModel] currentAdminUser];
        [self.propertyLoginV setHidden:YES];
    }];
    [self addObserverForNotificationName:k_NOTIFY_NAME_PROPERTY_USER_LOGOUT usingBlock:^(NSNotification *notification) {
        _strong(self);
        [self.propertyLoginV setHidden:NO];
        [self.propertyAvatarV setImage:[UIImage imageNamed:@"default_avatar"]];
    }];
    
    [self startObserveObject:self forKeyPath:@"normalUser" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (!self.normalUser) {
            return;
        }
        [self.avatarV setImageWithURL:[NSURL URLWithString:self.normalUser.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.nickNameL.text = self.normalUser.nickName;
        self.timeL.text = [NSString stringWithFormat:@"邻里号: %@", self.normalUser.userId];
    }];
    [self startObserveObject:self forKeyPath:@"adminUser" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        if ([self.adminUser.adminType integerValue] == Business) {
            [self.businessAvatarV setImageWithURL:[NSURL URLWithString:self.adminUser.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
            self.businessNameL.text = self.adminUser.realName;
        }
        else {
            [self.propertyAvatarV setImageWithURL:[NSURL URLWithString:self.adminUser.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
            self.propertyNameL.text = self.adminUser.realName;
        }
    }];
}

- (void)_refreshLoginState {
    [self.loginV setHidden:[[UserModel sharedModel] isNormalLogined]];
    if ([[UserModel sharedModel] isNormalLogined]) {
        self.normalUser = [[UserModel sharedModel] currentNormalUser];
    }
    
    [self.businessLoginV setHidden:[[UserModel sharedModel] isBusinessAdminLogined]];
    if ([[UserModel sharedModel] isBusinessAdminLogined]) {
        self.adminUser = [[UserModel sharedModel] currentAdminUser];
    }
    
    [self.propertyLoginV setHidden:[[UserModel sharedModel] isPropertyAdminLogined]];
    if ([[UserModel sharedModel] isPropertyAdminLogined]) {
        self.adminUser = [[UserModel sharedModel] currentAdminUser];
    }
}



#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identity = @"";
    if (indexPath.row == 0) {
        identity = @"PC_Function_JiFen_Cell";
    }
    if (indexPath.row == 1) {
        identity = @"PC_Function_JiaFei_Cell";
    }
    if (indexPath.row == 2) {
        identity = @"PC_Function_ZuLing_Cell";
    }
    if (indexPath.row == 3) {
        identity = @"PC_Function_GuiZe_Cell";
    }
    if (indexPath.row == 4) {
        identity = @"PC_Function_XieYi_Cell";
    }
    if (indexPath.row == 5) {
        identity = @"PC_Function_TuiChu_Cell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITextFiledDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.focusedField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![self.businessLoginV isHidden]) {
        if ([textField isEqual:self.bloginNameT]) {
            [self.bloginNameT resignFirstResponder];
            [self.bloginPasswdT becomeFirstResponder];
        }
        if ([textField isEqual:self.bloginPasswdT]) {
            [self.bloginPasswdT resignFirstResponder];
        }
    }
    
    if (![self.propertyLoginV isHidden]) {
        if ([textField isEqual:self.ploginNameT]) {
            [self.ploginNameT resignFirstResponder];
            [self.ploginPasswdT becomeFirstResponder];
        }
        if ([textField isEqual:self.ploginPasswdT]) {
            [self.ploginPasswdT resignFirstResponder];
        }
    }
    
    return YES;
}

#pragma mark - private
- (void)_loadPCSubViews {
    _weak(self);
    UIButton *(^btnBlock)(NSString *nbg, NSString *hbg, NSString *segue) = ^(NSString *nbg, NSString *hbg, NSString *segue) {
        UIButton *b = [[UIButton alloc] init];
        [b setBackgroundImage:[UIImage imageNamed:nbg] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:nbg] forState:UIControlStateHighlighted];
        if (hbg) {
            [b setBackgroundImage:[UIImage imageNamed:hbg] forState:UIControlStateHighlighted];
        }
        
        if (segue) {
            _weak(b);
            [b addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                _strong(self);
                _strong(b);
                [self performSegueWithIdentifier:segue sender:b];
            }];
        }
        return b;
    };
    
    self.orderBtn = btnBlock(@"pc_order_btn", nil, nil);
    UIImageView *comming = [[UIImageView alloc] init];
    comming.image = [UIImage imageNamed:@"coming_soon_icon"];
    [self.orderBtn addSubview:comming];
    [comming mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.right.equalTo(self.orderBtn);
        make.top.bottom.equalTo(self.orderBtn);
        make.width.equalTo(self.orderBtn.mas_height);
    }];
    
    self.recorderBtn = btnBlock(@"pc_recorder_btn", nil, @"Segue_PC_PayRecord");
    self.rentBtn = btnBlock(@"pc_rent_btn", nil, @"Segue_PC_MyRentInfo");
    self.weiBtn = btnBlock(@"pc_wei_btn", nil, @"Segue_PC_WeiCommunity");
    self.fixBtn = btnBlock(@"pc_fix_btn", nil, @"Segue_PersonalCenter_MyFixRecord");
    self.pointBtn = btnBlock(@"pc_point_btn", nil, @"Segue_PC_PointRule");
    self.contractBtn = btnBlock(@"pc_contract_btn", nil, @"Segue_PC_Contract");
    self.aboutBtn = btnBlock(@"pc_about_btn", nil, @"Segue_PC_About");
    
    self.quitBtn = [[UIButton alloc] init];
    self.quitBtn.backgroundColor = k_COLOR_RED;
    self.quitBtn.layer.cornerRadius = 4;
    [self.quitBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [self.quitBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    self.quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.quitBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if (![[UserModel sharedModel] isNormalLogined]) {
            [SVProgressHUD showInfoWithStatus:@"您尚未登录"];
            return;
        }
        
        [[UserModel sharedModel] normalLogOut];
        [self.pcScrollV scrollRectToVisible:CGRectMake(0, 0, V_W_(self.view), 10) animated:YES];
    }];
    
    self.pcLoginNoteV = [[UIView alloc] init];
    self.pcLoginNoteV.backgroundColor = k_COLOR_CLEAR;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
    }];
    [self.pcLoginNoteV addGestureRecognizer:tap];
}

- (void)_layoutPCSubViews {
    if ([self.orderBtn superview]) {
        return;
    }
    
    _weak(self);
    [self.pcContentV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
    }];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = k_COLOR_GALLERY;
    [self.pcContentV addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.pcContentV);
        make.top.equalTo(self.midV.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [self.pcContentV addSubview:self.orderBtn];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.midV.mas_bottom).with.offset(1);
        make.left.right.equalTo(self.pcContentV);
        make.height.equalTo(@68);
    }];
    
    [self.pcContentV addSubview:self.recorderBtn];
    [self.recorderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.orderBtn.mas_bottom);
        make.left.right.height.equalTo(self.orderBtn);
    }];
    
    [self.pcContentV addSubview:self.rentBtn];
    [self.rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.recorderBtn.mas_bottom);
        make.left.right.height.equalTo(self.orderBtn);
    }];
    [self.pcContentV addSubview:self.weiBtn];
    [self.weiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.rentBtn.mas_bottom);
        make.left.right.height.equalTo(self.orderBtn);
    }];
    [self.pcContentV addSubview:self.fixBtn];
    [self.fixBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.weiBtn.mas_bottom);
        make.left.right.height.equalTo(self.orderBtn);
    }];
    [self.pcContentV addSubview:self.pointBtn];
    [self.pointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.fixBtn.mas_bottom);
        make.left.right.height.equalTo(self.orderBtn);
    }];
    [self.pcContentV addSubview:self.contractBtn];
    [self.contractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.pointBtn.mas_bottom);
        make.left.right.height.equalTo(self.orderBtn);
    }];
    [self.pcContentV addSubview:self.aboutBtn];
    [self.aboutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contractBtn.mas_bottom);
        make.left.right.height.equalTo(self.orderBtn);
    }];
    
    [self.pcContentV addSubview:self.quitBtn];
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.aboutBtn.mas_bottom).with.offset(12);
        make.left.equalTo(self.orderBtn).with.offset(13);
        make.right.equalTo(self.orderBtn).with.offset(-13);
        make.height.equalTo(@44);
    }];
    
    [self.pcContentV addSubview:self.pcLoginNoteV];
    [self.pcLoginNoteV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.bottom.equalTo(self.pcContentV);
        make.top.equalTo(self.pcContentV).with.offset(200);
    }];
    
    if ([[UserModel sharedModel] isNormalLogined]) {
        [self.pcLoginNoteV setHidden:YES];
    }
}

@end
