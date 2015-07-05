//
//  NormalLoginVC.m
//  Sunflower
//
//  Created by mark on 15/5/9.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "UserModel.h"

#import "NormalLoginVC.h"
#import "NormalRegisterVC.h"
#import "FindPasswdVC.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>

@interface NormalLoginVC () <UITextFieldDelegate, WXApiDelegate>

@property(nonatomic,weak)IBOutlet UIScrollView      *scrollV;
@property(nonatomic,weak)IBOutlet UIView            *contentV;
@property(nonatomic,weak)IBOutlet UITextField       *phoneNumbT;
@property(nonatomic,weak)IBOutlet UITextField       *passwordT;

@property(nonatomic,weak)UITextField                *focusedField;

@end

@implementation NormalLoginVC

- (NSString *)umengPageName {
    return @"个人用户登录";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_NormalLogin";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollV handleKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([segue.identifier isEqualToString:@"Segue_NormalLogin_Register"]) {
        ((NormalRegisterVC*)segue.destinationViewController).naviTitle = @"注册";
        ((NormalRegisterVC*)segue.destinationViewController).type = NormalUser;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_NormalLogin_FindPassword"]) {
        ((FindPasswdVC*)segue.destinationViewController).type = NormalUser;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Business Logic
- (void)_layoutCodingViews {
    [self.contentV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
    }];
}

- (void)_login {
    NSString *phoneNum = [self.phoneNumbT.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![MKWStringHelper isVAlidatePhoneNumber:phoneNum]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码错误"];
        return;
    }
    
    [[UserModel sharedModel] normalLoginWithUserName:phoneNum password:self.passwordT.text remoteBlock:^(UserInfo *user, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error.domain]];
            return;
        }
        
        if (self.enterVC) {
            [self.navigationController popToViewController:self.enterVC animated:YES];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UI Control Action
- (IBAction)okBtnTap:(id)sender {
    [self _login];
}

- (IBAction)viewTap:(id)sender {
    if (self.focusedField) {
        [self.focusedField resignFirstResponder];
    }
}

- (IBAction)weiXinBtnTap:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showErrorWithStatus:@"请安装微信或选择其它登录方式"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    [[UserModel sharedModel] asyncThirdPartyLoginWithShareType:ShareTypeWeixiSession remoteBlock:^(UserInfo *user, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            if (self.enterVC) {
                [self.navigationController popToViewController:self.enterVC animated:YES];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (IBAction)qqBtnTap:(id)sender {
    if (![QQApi isQQInstalled]) {
        [SVProgressHUD showErrorWithStatus:@"请安装QQ或选择其它登录方式"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    [[UserModel sharedModel] asyncThirdPartyLoginWithShareType:ShareTypeQQSpace remoteBlock:^(UserInfo *user, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            if (self.enterVC) {
                [self.navigationController popToViewController:self.enterVC animated:YES];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (IBAction)weiBoBtnTap:(id)sender {
    
}

- (IBAction)registTap:(id)sender {
    [self performSegueWithIdentifier:@"Segue_NormalLogin_Register" sender:sender];
}

- (IBAction)findPasswordTap:(id)sender {
    [self performSegueWithIdentifier:@"Segue_NormalLogin_FindPassword" sender:sender];
}

#pragma mark - UITextFieldDelegage
// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.focusedField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.phoneNumbT]) {
        [self.phoneNumbT resignFirstResponder];
        [self.passwordT becomeFirstResponder];
    }
    if ([textField isEqual:self.passwordT]) {
        [self.passwordT resignFirstResponder];
        [self _login];
    }
    return YES;
}

#pragma mark - WXDelegate
///*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
// *
// * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
// * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
// * @param req 具体请求内容，是自动释放的
// */
//-(void) onReq:(BaseReq*)req {
//    
//}
//
//
//
///*! @brief 发送一个sendReq后，收到微信的回应
// *
// * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
// * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
// * @param resp具体的回应内容，是自动释放的
// */
//-(void) onResp:(BaseResp*)resp {
//    if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        SendAuthResp *temp = (SendAuthResp*)resp;
//        
//    }
//}

@end
