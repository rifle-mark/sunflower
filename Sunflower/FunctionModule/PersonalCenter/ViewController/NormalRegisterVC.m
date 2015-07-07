//
//  NormalRegisterVC.m
//  Sunflower
//
//  Created by mark on 15/5/9.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "UserModel.h"
#import "CommonModel.h"

#import "NormalRegisterVC.h"
#import "MKWTextField.h"
#import "ServerProxy.h"
#import "ContractVC.h"
#import "APIGenerator.h"

@interface NormalRegisterVC () <UITextFieldDelegate>

@property(nonatomic,strong)UIScrollView     *contentScrollV;
@property(nonatomic,strong)UIView           *scrolContentV;
@property(nonatomic,strong)MKWTextField     *businessNameT;
@property(nonatomic,strong)MKWTextField     *nickNameT;
@property(nonatomic,strong)MKWTextField     *phoneNumbT;
@property(nonatomic,strong)MKWTextField     *checkCodeT;
@property(nonatomic,strong)MKWTextField     *passwordT;
@property(nonatomic,strong)MKWTextField     *password2T;
@property(nonatomic,strong)UIButton         *businessTypeBtn;
@property(nonatomic,strong)UIButton         *checkCodeBtn;
@property(nonatomic,strong)UIButton         *checkboxBtn;
@property(nonatomic,strong)UIButton         *okBtn;

@property(nonatomic,strong)UITableView      *selectionView;

@property(nonatomic,strong)NSArray          *selectionArray;
@property(nonatomic,strong)NSNumber         *businessType;
@property(nonatomic,strong)NSString         *checkCode;
@property(nonatomic,weak)UITextField        *focusedField;

@end

@implementation NormalRegisterVC

- (NSString *)umengPageName {
    return @"用户注册";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_Register_PCCenter";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.businessType = @(-1);
    self.navigationItem.title = (self.naviTitle?self.naviTitle:@"注册");
    [self.contentScrollV handleKeyboard];
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
    
    [self _setupTapGuester];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Coding Views 
- (void)_loadCodingViews {
    _weak(self);
    
    self.contentScrollV = [[UIScrollView alloc] init];
    self.contentScrollV.showsHorizontalScrollIndicator = NO;
    self.contentScrollV.showsVerticalScrollIndicator = NO;

    self.scrolContentV = [[UIView alloc] init];
    [self.contentScrollV addSubview:self.scrolContentV];
    
    MKWTextField *(^textFieldBlock)(NSString *bg, NSString *placeholder) = ^(NSString *bg, NSString *placeholder){
        MKWTextField *f = [[MKWTextField alloc]init];
        f.textColor = k_COLOR_GALLERY_F;
        f.font = [UIFont boldSystemFontOfSize:15];
        f.textEdgeInset = UIEdgeInsetsMake(0, 40, 0, 5);
        f.backgroundColor = k_COLOR_WHITE;
        f.background = [UIImage imageNamed:bg];
        f.placeholder = placeholder;
        f.autocapitalizationType = UITextAutocapitalizationTypeNone;
        f.autocorrectionType = UITextAutocorrectionTypeNo;
        f.returnKeyType = UIReturnKeyDone;
        [f withBlockForDidBeginEditing:^(UITextField *view) {
            _strong(self);
            self.focusedField = view;
        }];
        [f withBlockForShouldReturn:^BOOL(UITextField *view) {
            [view resignFirstResponder];
            return YES;
        }];
        return f;
    };
    
    UIButton *(^buttonBlock)(NSString *title, UIColor *bgColor) = ^(NSString *title, UIColor *bgColor){
        UIButton *b = [[UIButton alloc] init];
        b.backgroundColor = bgColor;
        b.layer.cornerRadius = 4;
        [b setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [b setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        [b setTitle:title forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        return b;
    };
    MKWTextField *topField = nil;
    if (self.type == BusinessUser) {
        self.businessNameT = textFieldBlock(@"pc_register_bussines_name_bg", @"请输入商户名称");
        topField = self.businessNameT;
    }
    if (self.type == NormalUser) {
        self.nickNameT = textFieldBlock(@"pc_register_bussines_name_bg", @"请输入您的昵称");
        topField = self.nickNameT;
    }
    
    [self.scrolContentV addSubview:topField];
    [topField mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.scrolContentV).with.offset(10);
        make.left.equalTo(self.scrolContentV).with.offset(20);
        make.right.equalTo(self.scrolContentV).with.offset(-20);
        make.height.equalTo((self.type==BusinessUser?@43:@0));
    }];
    self.phoneNumbT = textFieldBlock(@"pc_register_username_bg", @"请输入您的手机号码");
    self.phoneNumbT.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrolContentV addSubview:self.phoneNumbT];
    _weak(topField);
    [self.phoneNumbT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(topField);
        if (self.type == NormalUser) {
            make.top.equalTo(self.scrolContentV).with.offset(10);
            make.left.equalTo(self.scrolContentV).with.offset(20);
            make.right.equalTo(self.scrolContentV).with.offset(-20);
            make.height.equalTo(@43);
        }
        else {
            make.top.equalTo(topField.mas_bottom).with.offset(5);
            make.left.right.height.equalTo(topField);
        }
    }];

    self.checkCodeBtn = buttonBlock(@"获取验证码", k_COLOR_BLUE);
    [self.checkCodeBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        NSString *phoneNum = [self.phoneNumbT.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([MKWStringHelper isVAlidatePhoneNumber:phoneNum]) {
            [[UserModel sharedModel] asyncCheckCodeWithPhoneNumber:phoneNum remoteBlock:^(NSString *code, NSString *msg, NSError *error) {
                _strong(self);
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                    self.checkCode = code;
                    [self.checkCodeBtn setEnabled:NO];
                    // start timing after 1 minuts enable again.
                    return;
                }
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"手机号码错误"];
        }

    }];
    [self.scrolContentV addSubview:self.checkCodeBtn];
    [self.checkCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.phoneNumbT.mas_bottom).with.offset(5);
        make.right.height.equalTo(self.phoneNumbT);
        make.width.equalTo(@80);
    }];
    self.checkCodeT = textFieldBlock(@"pc_register_checkcode_bg", @"请输入验证码");
    [self.scrolContentV addSubview:self.checkCodeT];
    [self.checkCodeT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.bottom.equalTo(self.checkCodeBtn);
        make.left.equalTo(self.phoneNumbT);
        make.right.equalTo(self.checkCodeBtn.mas_left).with.offset(-2);
    }];
    self.passwordT = textFieldBlock(@"pc_register_passwd_bg", @"请设置密码,6-14位,建议数字加字母组合");
    [self.passwordT setSecureTextEntry:YES];
    [self.scrolContentV addSubview:self.passwordT];
    [self.passwordT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.checkCodeT.mas_bottom).with.offset(5);
        make.left.right.height.equalTo(self.phoneNumbT);
    }];
    self.password2T = textFieldBlock(@"pc_register_passwd_bg", @"请再次输入密码");
    [self.password2T setSecureTextEntry:YES];
    [self.scrolContentV addSubview:self.password2T];
    [self.password2T mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.passwordT.mas_bottom).with.offset(5);
        make.left.right.height.equalTo(self.phoneNumbT);
    }];
    
    if (self.type == BusinessUser) {
        self.businessTypeBtn = [[UIButton alloc] init];
        [self.businessTypeBtn setBackgroundImage:[UIImage imageNamed:@"pc_businesstype_btn"] forState:UIControlStateNormal];
        [self.businessTypeBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [self.businessTypeBtn setTitle:@"请选择商家类型(如:食)" forState:UIControlStateNormal];
        self.businessTypeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.businessTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.businessTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        [self.businessTypeBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self _showSelectionView:self.businessTypeBtn];
        }];
        [self.scrolContentV addSubview:self.businessTypeBtn];
        [self.businessTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.password2T.mas_bottom).with.offset(5);
            make.left.right.height.equalTo(self.phoneNumbT);
        }];
    }

    self.checkboxBtn = [[UIButton alloc] init];
    [self.checkboxBtn setImage:[UIImage imageNamed:@"pc_audit_checkbox_n"] forState:UIControlStateNormal];
    [self.checkboxBtn setImage:[UIImage imageNamed:@"pc_audit_checkbox_s"] forState:UIControlStateSelected];
    [self.checkboxBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self.checkboxBtn setSelected:!self.checkboxBtn.isSelected];
    }];
    [self.scrolContentV addSubview:self.checkboxBtn];
    [self.checkboxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.type==NormalUser?self.password2T.mas_bottom:self.businessTypeBtn.mas_bottom).with.offset(5);
        make.left.equalTo(self.scrolContentV).with.offset(10);
        make.width.height.equalTo(@38);
    }];

    UILabel * readL = [[UILabel alloc] init];
    readL.text = @"我已经阅读并同意";
    readL.textColor = k_COLOR_GALLERY_F;
    readL.font = [UIFont boldSystemFontOfSize:12];
    [self.scrolContentV addSubview:readL];
    [readL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.bottom.equalTo(self.checkboxBtn);
        make.left.equalTo(self.checkboxBtn.mas_right);
        make.width.equalTo(@97);
    }];

    UIButton *contractBtn = [[UIButton alloc] init];
    [contractBtn setTitleColor:k_COLOR_BLUE forState:UIControlStateNormal];
    [contractBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [contractBtn setTitle:@"《向日葵智慧社区服务条款》" forState:UIControlStateNormal];
    contractBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [contractBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self performSegueWithIdentifier:@"Segue_PCRegister_Contract" sender:nil];
    }];
    [self.scrolContentV addSubview:contractBtn];
    _weak(readL);
    [contractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(readL);
        make.top.bottom.equalTo(self.checkboxBtn);
        make.left.equalTo(readL.mas_right);
        make.right.equalTo(self.phoneNumbT);
    }];

    self.okBtn = buttonBlock(@"完成注册", k_COLOR_BLUE);
    [self.okBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self _register];
    }];
    [self.scrolContentV addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.checkboxBtn.mas_bottom).with.offset(10);
        make.left.right.height.equalTo(self.phoneNumbT);
    }];
    
    if (!self.selectionView) {
        self.selectionView = ({
            UITableView *v = [[UITableView alloc] init];
            [v setShowsHorizontalScrollIndicator:NO];
            [v setShowsVerticalScrollIndicator:NO];
            [v registerClass:[UITableViewCell class] forCellReuseIdentifier:@"selectionCell"];
            [v setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            v.layer.borderColor = [k_COLOR_GALLERY_F CGColor];
            v.layer.borderWidth = 1;
            v.layer.cornerRadius = 4;
            [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
                return [self.selectionArray count];
            }];
            [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
                UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:@"selectionCell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectionCell"];
                }
                NSString *selection = [self.selectionArray objectAtIndex:path.row];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = k_COLOR_GALLERY_F;
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.text = selection;
                return cell;
            }];
            [v withBlockForSectionNumber:^NSInteger(UITableView *view) {
                return 1;
            }];
            [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
                return 30;
            }];
            v;
        });
    }
}

- (void)_setupTapGuester {
    _weak(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        _strong(self);
        if (self.focusedField && [self.focusedField isFirstResponder]) {
            [self.focusedField resignFirstResponder];
        }
        if (self.selectionView && [self.selectionView superview] &&!CGRectContainsPoint(self.selectionView.frame, [touch locationInView:[self.selectionView superview]])) {
            [self.selectionView removeFromSuperview];
        }
        return NO;
    }];
    [self.view addGestureRecognizer:tap];
}

- (void)_layoutCodingViews {
    if (![self.contentScrollV superview]) {
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
        
        [self.view addSubview:self.contentScrollV];
        _weak(topTmp);
        _weak(botTmp);
        [self.contentScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(topTmp);
            _strong(botTmp);
            make.left.right.equalTo(self.view);
            make.top.equalTo(topTmp.mas_bottom);
            make.bottom.equalTo(botTmp.mas_top);
        }];
        
        [self.scrolContentV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentScrollV);
            make.width.equalTo(self.view);
            make.height.equalTo(self.type==NormalUser?@345:@395);
        }];
    }
}


#pragma mark - Business Logic
- (void)_register {
    NSString *businessName = @"";
    if (self.type == BusinessUser) {
        businessName = [MKWStringHelper trimWithStr:self.businessNameT.text];
        if ([MKWStringHelper isNilEmptyOrBlankString:businessName]) {
            [SVProgressHUD showErrorWithStatus:@"请输入商户名称"];
            return;
        }
    }
    
    NSString *phoneNum = [MKWStringHelper trimWithStr:self.phoneNumbT.text];
    if (![MKWStringHelper isVAlidatePhoneNumber:phoneNum]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码错误"];
        return;
    }
    NSString *checkCode = [self.checkCodeT.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([checkCode compare:self.checkCode options:NSCaseInsensitiveSearch] != NSOrderedSame) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        return;
    }
    NSString *passwd = self.passwordT.text;
    NSString *passwd2 = self.password2T.text;
    if (![passwd isEqualToString:passwd2]) {
        [SVProgressHUD showErrorWithStatus:@"密码不一致"];
        return;
    }
    
    if (self.type == BusinessUser) {
        if ([self.businessType integerValue] == -1) {
            [SVProgressHUD showErrorWithStatus:@"请选择商户类型"];
            return;
        }
    }
    _weak(self);
    if (self.type == NormalUser) {
        [[UserModel sharedModel] normalRegisterWithPhoneNumber:phoneNum password:passwd remoteBlock:^(UserInfo *user, NSError *error) {
            _strong(self);
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"注册失败：%@", error.domain]];
        }];
    }
    if (self.type == BusinessUser) {
        [[UserModel sharedModel] businessUserRegistWithName:businessName phoneNum:phoneNum password:passwd communityId:[CommonModel sharedModel].currentCommunityId type:self.businessType remoteBlock:^(AdminUserInfo *admin, NSError *error){
            if (!error) {
                [self performSegueWithIdentifier:@"UnSegue_Register_PCCenter" sender:nil];
                return;
            }
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
}

- (void)_showSelectionView:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _weak(self);
    _weak(btn);
    void (^showSelectionBlock)() = ^{
        [self.selectionView withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            _strong(btn);
            UITableViewCell *cell = [view cellForRowAtIndexPath:path];
            [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
            [btn setTitle:cell.textLabel.text forState:UIControlStateHighlighted];
            if ([btn isEqual:self.businessTypeBtn]) {
                if ([btn.titleLabel.text isEqualToString:@"衣"]) {
                    self.businessType = @(1);
                }
                if ([btn.titleLabel.text isEqualToString:@"食"]) {
                    self.businessType = @(2);
                }
                if ([btn.titleLabel.text isEqualToString:@"住"]) {
                    self.businessType = @(3);
                }
                if ([btn.titleLabel.text isEqualToString:@"行"]) {
                    self.businessType = @(4);
                }
                if ([btn.titleLabel.text isEqualToString:@"乐"]) {
                    self.businessType = @(5);
                }
                if ([btn.titleLabel.text isEqualToString:@"享"]) {
                    self.businessType = @(6);
                }
            }
            [self.selectionView removeFromSuperview];
        }];
        
        if (![self.selectionView superview]) {
            [[btn superview] addSubview:self.selectionView];
        }
        [self.selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(btn);
            CGRect rect = [btn convertRect:btn.bounds toView:[btn superview]];
            make.left.equalTo(btn);
            make.right.equalTo(btn);
            if (rect.origin.y+rect.size.height + 90 > V_H_([btn superview])-50) {
                make.bottom.equalTo(btn.mas_top);
            }
            else {
                make.top.equalTo(btn.mas_bottom);
            }
            make.height.equalTo(@90);
        }];
        [[btn superview] bringSubviewToFront:self.selectionView];
    };
    
    self.selectionArray = @[];
    if ([btn isEqual:self.businessTypeBtn]) {
        self.selectionArray = @[@"衣", @"食", @"住", @"行", @"乐", @"享"];
    }
    
    [self.selectionView reloadData];
    [self.selectionView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    showSelectionBlock();
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_PCRegister_Contract"]) {
        if (self.type == NormalUser) {
            ((ContractVC*)segue.destinationViewController).url = [NSURL URLWithString:[APIGenerator apiAddressWithSuffix:k_API_USER_ANNOUNCE]];
        }
        else if (self.type == BusinessUser) {
            ((ContractVC*)segue.destinationViewController).url = [NSURL URLWithString:[APIGenerator apiAddressWithSuffix:k_API_BUSINESS_ANNOUNCE]];
        }
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

@end
