//
//  FindPasswdVC.m
//  Sunflower
//
//  Created by mark on 15/5/9.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "FindPasswdVC.h"

#import "MKWStringHelper.h"
#import "UserModel.h"

#import <SVProgressHUD.h>

@interface FindPasswdVC () <UITextFieldDelegate>

@property(nonatomic,weak)IBOutlet UIScrollView          *scrollV;
@property(nonatomic,weak)IBOutlet UIView                *contentV;
@property(nonatomic,weak)IBOutlet UITextField           *phoneNumbT;
@property(nonatomic,weak)IBOutlet UITextField           *checkCodeT;
@property(nonatomic,weak)IBOutlet UITextField           *passwordT;
@property(nonatomic,weak)IBOutlet UITextField           *password2T;
@property(nonatomic,weak)IBOutlet UIButton              *checkCodeBtn;
@property(nonatomic,weak)IBOutlet UIButton              *okBtn;

@property(nonatomic,strong)NSString                     *checkCode;
@property(nonatomic,weak)UITextField                    *focusedField;

@end

@implementation FindPasswdVC

- (NSString *)umengPageName {
    return @"找回密码";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_FindPassword";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollV handleKeyboard];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.contentV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UI Control Action
- (IBAction)checkCodeTap:(id)sender {
    NSString *phoneNum = [self.phoneNumbT.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    __block NSInteger second = 20;
    _weak(self);
    if ([MKWStringHelper isVAlidatePhoneNumber:phoneNum]) {
        [[UserModel sharedModel] asyncCheckCodeWithPhoneNumber:phoneNum remoteBlock:^(NSString *code, NSString *msg, NSError *error) {
            _strong(self);
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                self.checkCode = code;
                [self.checkCodeBtn setEnabled:NO];
                [self.checkCodeBtn setTitle:@"(20)秒后再次获取" forState:UIControlStateDisabled];
                
                self.checkCodeBtn.backgroundColor = [k_COLOR_BLUE colorWithAlphaComponent:0.8];
                // start timing after 1 minuts enable again.
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES action:^(NSTimer *timer) {
                    _strong(self);
                    if (second > 0) {
                        [self.checkCodeBtn setTitle:[NSString stringWithFormat:@"(%ld)秒后再次获取", (long)second] forState:UIControlStateDisabled];
                        second -= 1;
                    }
                    else {
                        [self.checkCodeBtn setEnabled:YES];
                        [self.checkCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.checkCodeBtn.backgroundColor = k_COLOR_BLUE;
                        [timer invalidate];
                    }
                }];
                return;
            }
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"手机号码错误"];
    }
    
}

- (IBAction)okBtnTap:(id)sender {
    [self _resetPassword];
}

- (IBAction)viewTap:(id)sender {
    if (self.focusedField) {
        [self.focusedField resignFirstResponder];
    }
}

#pragma mark - Business Logic
- (void)_resetPassword {
    NSString *phoneNum = [self.phoneNumbT.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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
    _weak(self);
        [[UserModel sharedModel] setPasswordWithPhoneNumber:phoneNum password:passwd type:self.type remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
            _strong(self);
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"重置成功"];
                [self performSegueWithIdentifier:@"UnSegue_FindPassword" sender:nil];
                return;
            }
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"重置失败:%@", error.domain]];
        }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - UITextFieldDelegate
// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.focusedField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.phoneNumbT]) {
        [self.phoneNumbT resignFirstResponder];
        [self.checkCodeT becomeFirstResponder];
    }
    if ([textField isEqual:self.checkCodeT]) {
        [self.checkCodeT resignFirstResponder];
        [self.passwordT becomeFirstResponder];
    }
    if ([textField isEqual:self.passwordT]) {
        [self.passwordT resignFirstResponder];
        [self.password2T becomeFirstResponder];
    }
    if ([textField isEqual:self.password2T]) {
        [self.password2T resignFirstResponder];
        [self _resetPassword];
    }
    return YES;
}

@end
