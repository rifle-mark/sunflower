//
//  ShopStoreEditVC.m
//  Sunflower
//
//  Created by makewei on 15/5/22.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopStoreEditVC.h"

#import "UserModel.h"

#import "GCExtension.h"
#import <SVProgressHUD.h>
#import <Masonry.h>

@interface ShopStoreEditVC () <UITextFieldDelegate>

@property(nonatomic,weak)IBOutlet UIScrollView   *scrollV;
@property(nonatomic,weak)IBOutlet UIView         *contentV;

@property(nonatomic,strong)UILabel               *nameL;
@property(nonatomic,strong)UITextField           *nameT;
@property(nonatomic,strong)UILabel               *telL;
@property(nonatomic,strong)UITextField           *telT;
@property(nonatomic,strong)UILabel               *addressL;
@property(nonatomic,strong)UITextField           *addressT;
@property(nonatomic,strong)UIButton              *okBtn;

@property(nonatomic,weak)UITextField             *focusedField;

@end

@implementation ShopStoreEditVC

- (NSString *)umengPageName {
    return @"商户分店信息编辑";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_StoreEdit_ShopInfo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollV handleKeyboard];
}

- (void)loadView {
    [super loadView];
    _weak(self);
    UILabel *(^titleLabelBlock)(NSString *str) = ^(NSString *str) {
        UILabel *ret = [[UILabel alloc] init];
        ret.text = str;
        ret.font = [UIFont boldSystemFontOfSize:18];
        ret.textColor = k_COLOR_GALLERY_F;
        ret.backgroundColor = k_COLOR_CLEAR;
        return ret;
    };
    UITextField *(^editFieldBlock)() = ^(){
        _strong(self);
        UITextField *ret = [[UITextField alloc] init];
        ret.borderStyle = UITextBorderStyleRoundedRect;
        ret.font = [UIFont boldSystemFontOfSize:16];
        ret.textColor = k_COLOR_GALLERY_F;
        ret.autocapitalizationType = UITextAutocapitalizationTypeNone;
        ret.autocorrectionType = UITextAutocorrectionTypeNo;
        ret.delegate = self;
        return ret;
    };
    self.nameL = titleLabelBlock(@"店铺名称");
    self.telL = titleLabelBlock(@"店铺电话");
    self.addressL = titleLabelBlock(@"店铺地址");
    self.nameT = editFieldBlock();
    self.nameT.text = (self.store?self.store.name:@"");
    self.nameT.returnKeyType = UIReturnKeyNext;
    self.nameT.placeholder = @"请输入店铺名称";
    self.telT = editFieldBlock();
    self.telT.text = (self.store?self.store.tel:@"");
    self.telT.returnKeyType = UIReturnKeyNext;
    self.telT.keyboardType = UIKeyboardTypePhonePad;
    self.telT.placeholder = @"请输入店铺电话";
    self.addressT = editFieldBlock();
    self.addressT.text = (self.store?self.store.address:@"");
    self.addressT.returnKeyType = UIReturnKeyDone;
    self.addressT.placeholder = @"请输入店铺地址";
    
    self.okBtn = [[UIButton alloc] init];
    self.okBtn.backgroundColor = k_COLOR_BLUE;
    self.okBtn.layer.cornerRadius = 4.0;
    [self.okBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [self.okBtn setTitle:(self.store?@"保存修改":@"确认添加") forState:UIControlStateNormal];
    
    [self.okBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        NSString *name = [MKWStringHelper trimWithStr:self.nameT.text];
        NSString *tel = [MKWStringHelper trimWithStr:self.telT.text];
        NSString *address = [MKWStringHelper trimWithStr:self.addressT.text];
        if ([MKWStringHelper isNilEmptyOrBlankString:name]) {
            [SVProgressHUD showErrorWithStatus:@"请输入店铺名称"];
            return;
        }
        if ([MKWStringHelper isNilEmptyOrBlankString:tel]) {
            [SVProgressHUD showErrorWithStatus:@"请输入店铺电话"];
            return;
        }
        if ([MKWStringHelper isNilEmptyOrBlankString:address]) {
            [SVProgressHUD showErrorWithStatus:@"请输入店铺地址"];
            return;
        }
        
        [SVProgressHUD showWithStatus:@"正在提交保存" maskType:SVProgressHUDMaskTypeClear];
        if (self.store) {
            [[UserModel sharedModel] asyncUpdateShopStoreWithShopId:self.store.shopId name:name tel:tel address:address remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                _strong(self);
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"修改失败，请检查网络"];
                    return;
                }
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self performSegueWithIdentifier:@"UnSegue_StoreEdit_ShopInfo" sender:self.okBtn];
            }];
        }
        else {
            [[UserModel sharedModel] asyncAddShopStoreWithName:name tel:tel address:address remoteBlock:^(BOOL isSuccess, NSNumber *shopId, NSString *msg, NSError *error) {
                _strong(self);
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"添加失败，请检查网络"];
                    return;
                }
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                [self performSegueWithIdentifier:@"UnSegue_StoreEdit_ShopInfo" sender:self.okBtn];
            }];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutControls];
    FixesViewDidLayoutSubviewsiOS7Error;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)_layoutControls {
    _weak(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
        if (self.focusedField) {
            [self.focusedField resignFirstResponder];
        }
    }];
    [self.contentV addGestureRecognizer:tap];
    
    if (![self.nameL superview]) {
        [self.contentV addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentV).with.offset(25);
            make.left.equalTo(self.contentV).with.offset(20);
            make.width.equalTo(self.contentV).with.offset(-50);
            make.height.equalTo(@18);
        }];
    }
    
    if (![self.nameT superview]) {
        [self.contentV addSubview:self.nameT];
        [self.nameT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(10);
            make.left.equalTo(self.nameL.mas_left);
            make.right.equalTo(self.nameL.mas_right);
            make.height.equalTo(@40);
        }];
    }
    
    if (![self.telL superview]) {
        [self.contentV addSubview:self.telL];
        [self.telL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameT.mas_bottom).with.offset(10);
            make.left.equalTo(self.nameT.mas_left);
            make.right.equalTo(self.nameT.mas_right);
            make.height.equalTo(@18);
        }];
    }
    
    if (![self.telT superview]) {
        [self.contentV addSubview:self.telT];
        [self.telT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.telL.mas_bottom).with.offset(10);
            make.left.equalTo(self.telL.mas_left);
            make.right.equalTo(self.telL.mas_right);
            make.height.equalTo(@40);
        }];
    }
    
    if (![self.addressL superview]) {
        [self.contentV addSubview:self.addressL];
        [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.telT.mas_bottom).with.offset(10);
            make.left.equalTo(self.telT.mas_left);
            make.right.equalTo(self.telT.mas_right);
            make.height.equalTo(@18);
        }];
    }
    
    if (![self.addressT superview]) {
        [self.contentV addSubview:self.addressT];
        [self.addressT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.addressL.mas_bottom).with.offset(10);
            make.left.equalTo(self.addressL.mas_left);
            make.right.equalTo(self.addressL.mas_right);
            make.height.equalTo(@40);
        }];
    }
    
    if (![self.okBtn superview]) {
        [self.contentV addSubview:self.okBtn];
        [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.addressT.mas_bottom).with.offset(20);
            make.left.equalTo(self.addressT.mas_left);
            make.right.equalTo(self.addressT.mas_right);
            make.height.equalTo(@40);
        }];
    }
    
    [self.contentV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
    }];
}

#pragma mark - UITextFieldDelegage
// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.focusedField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nameT]) {
        [self.nameT resignFirstResponder];
        [self.telT becomeFirstResponder];
    }
    if ([textField isEqual:self.telT]) {
        [self.telT resignFirstResponder];
        [self.addressT becomeFirstResponder];
    }
    if ([textField isEqual:self.addressT]) {
        [self.addressT resignFirstResponder];
    }
    return YES;
}
@end
