//
//  NormalUserInfoEditVC.m
//  Sunflower
//
//  Created by makewei on 15/6/9.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "NormalUserInfoEditVC.h"
#import "EYImagePickerViewController.h"

#import "CommonModel.h"
#import "UserModel.h"

@interface NormalUserInfoEditVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;
@property(nonatomic,strong)UIView           *avatarEditV;
@property(nonatomic,strong)UIImageView      *avatarV;
@property(nonatomic,strong)UIButton         *pickBtn;
@property(nonatomic,strong)UIView           *nickNameEditV;
@property(nonatomic,strong)UILabel          *nickNameTitleL;
@property(nonatomic,strong)UITextView       *nickNameT;

@property(nonatomic,strong)NSString         *avatarUrl;

@end

@implementation NormalUserInfoEditVC

- (NSString *)umengPageName {
    return self.isProperty?@"物业资料编辑":@"个人资料编辑";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_NormalUserInfoEdit";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.isProperty?@"物业信息":@"个人信息";
    
    UIBarButtonItem *saveBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(_saveUserInfo:)];
    saveBar.tintColor = k_COLOR_WHITE;
    self.navigationItem.rightBarButtonItem = saveBar;
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
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

#pragma mark - Coding View
- (void)_loadCodingViews {
    if (!self.avatarEditV) {
        [self _loadAvatarEditView];
    }
    if (!self.nickNameEditV) {
        [self _loadNickNameEditView];
    }
}

- (void)_loadAvatarEditView {
    self.avatarEditV = [[UIView alloc] init];
    self.avatarEditV.backgroundColor = k_COLOR_CLEAR;
    self.avatarV = [[UIImageView alloc] init];
    self.avatarV.clipsToBounds = YES;
    self.avatarV.layer.cornerRadius = [[UIScreen mainScreen] bounds].size.width==320?40:53;
    if (self.isProperty) {
        [self.avatarV setImageWithURL:[NSURL URLWithString:[UserModel sharedModel].currentAdminUser.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }
    else {
        [self.avatarV setImageWithURL:[NSURL URLWithString:[UserModel sharedModel].currentNormalUser.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }
    [self.avatarEditV addSubview:self.avatarV];
    _weak(self);
    [self.avatarV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.centerX.centerY.equalTo(self.avatarEditV);
        make.width.height.equalTo(@([[UIScreen mainScreen] bounds].size.width==320?80:106));
    }];
    
    self.pickBtn = [[UIButton alloc] init];
    [self.pickBtn setBackgroundImage:[UIImage imageNamed:@"pc_edit_avatar"] forState:UIControlStateNormal];
    [self.pickBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        void (^SetupEYImagePicker)(EYImagePickerViewController* picker) =
        ^(EYImagePickerViewController* picker) {
            _strong(self);
            picker.dismissBlock = ^(NSDictionary* userInfo) {
                _strong(self);
                [self dismissViewControllerAnimated:YES completion:nil];
            };
            [picker withBlockForDidFinishPickingMediaUsingFilePath:^(EYImagePickerViewController *picker, UIImage *thumbnail, NSString *filePath) {
                _strong(self);
                [self dismissViewControllerAnimated:NO completion:^{
                    [SVProgressHUD showWithStatus:@"正在上传图片" maskType:SVProgressHUDMaskTypeClear];
                    UIImage *newImage = [thumbnail adjustedToStandardSize];
                    [[CommonModel sharedModel] uploadImage:newImage path:filePath progress:nil remoteBlock:^(NSString *url, NSError *error) {
                        _strong(self);
                        if (!error) {
                            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                            self.avatarUrl = url;
                            self.avatarV.image = newImage;
//                            [[UserModel sharedModel] updateUserInfoWithNickName:[UserModel sharedModel].currentNormalUser.nickName avatar:url remoteBlock:nil];
                        }
                        else {
                            [SVProgressHUD showErrorWithStatus:@"上传失败"];
                        }
                    }];
                    
                }];
            }];
            [self presentViewController:picker animated:YES completion:nil];
        };
        
        // 文本，小视频，本地视频，拍照，手机相册选择
        GCActionSheet* as = [[GCActionSheet alloc] initWithTitle:@""];
        
        [as setCancelButtonTitle:@"取消" actionBlock:nil];
        
        if ([EYImagePickerViewController isCameraPhotoAvailable]) {
            [as addOtherButtonTitle:@"拍照" actionBlock:^{
                EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForCameraPhotoEditable:YES];
                SetupEYImagePicker(picker);
            }];
        }
        
        if ([EYImagePickerViewController isLibraryPhotoAvailable]) {
            [as addOtherButtonTitle:@"手机相册" actionBlock:^{
                EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForLibraryPhotoEditable:YES];
                SetupEYImagePicker(picker);
            }];
        }
        [as showInView:self.view];
    }];
    [self.avatarEditV addSubview:self.pickBtn];
    [self.pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.right.bottom.equalTo(self.avatarV);
        make.width.height.equalTo(@30);
    }];
}

- (void)_loadNickNameEditView {
    _weak(self);
    self.nickNameEditV = [[UIView alloc] init];
    self.nickNameEditV.backgroundColor = k_COLOR_CLEAR;
    
    self.nickNameTitleL = [[UILabel alloc] init];
    self.nickNameTitleL.textColor = k_COLOR_GALLERY_F;
    self.nickNameTitleL.font = [UIFont boldSystemFontOfSize:14];
    self.nickNameTitleL.text = @"您的昵称:";
    [self.nickNameEditV addSubview:self.nickNameTitleL];
    [self.nickNameTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nickNameEditV).with.offset(8);
        make.left.equalTo(self.nickNameEditV).with.offset(16);
        make.right.equalTo(self.nickNameEditV).with.offset(-46);
        make.height.equalTo(@14);
    }];
    
    self.nickNameT = [[UITextView alloc] init];
    self.nickNameT.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    self.nickNameT.textColor = k_COLOR_GALLERY_F;
    self.nickNameT.font = [UIFont boldSystemFontOfSize:15];
    if (self.isProperty) {
        self.nickNameT.text = [UserModel sharedModel].currentAdminUser.realName;
    }
    else {
        self.nickNameT.text = [UserModel sharedModel].currentNormalUser.nickName;
    }
    UIButton *clearBtn = [[UIButton alloc] init];
    [clearBtn setBackgroundImage:[UIImage imageNamed:@"edit_clear_btn"] forState:UIControlStateNormal];
    [clearBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        self.nickNameT.text = @"";
    }];

    [self.nickNameEditV addSubview:self.nickNameT];
    [self.nickNameT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nickNameTitleL.mas_bottom).with.offset(13);
        make.left.right.equalTo(self.nickNameTitleL);
        make.height.equalTo(@30);
    }];
    
    [self.nickNameEditV addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.bottom.equalTo(self.nickNameT);
        make.width.equalTo(@30);
        make.right.equalTo(self.nickNameEditV).with.offset(-16);
    }];
}

- (void)_layoutCodingViews {
    self.contentV.backgroundColor = k_COLOR_GALLERY;
    _weak(self);
    if (![self.avatarEditV superview]) {
        [self.contentV addSubview:self.avatarEditV];
        [self.avatarEditV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.left.right.equalTo(self.contentV);
            make.height.equalTo(@([[UIScreen mainScreen] bounds].size.width==320?110:136));
        }];
    }
    
    if (![self.nickNameEditV superview]) {
        [self.contentV addSubview:self.nickNameEditV];
        [self.nickNameEditV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.avatarV.mas_bottom);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@78);
        }];
    }
}

#pragma mark - data
- (void)_saveUserInfo:(id)sender {
    
    NSString *nickname = [MKWStringHelper trimWithStr:self.nickNameT.text];
    if ([MKWStringHelper isNilEmptyOrBlankString:nickname] && [MKWStringHelper isNilEmptyOrBlankString:self.avatarUrl]) {
        [SVProgressHUD showErrorWithStatus:@"没有要保存的内容"];
        return;
    }
    
    if ([MKWStringHelper isNilEmptyOrBlankString:nickname]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
    
    if (!self.isProperty) {
        UserInfo *cUser = [UserModel sharedModel].currentNormalUser;
        [[UserModel sharedModel] updateUserInfoWithNickName:nickname avatar:([MKWStringHelper isNilEmptyOrBlankString:self.avatarUrl]?(cUser.avatar?cUser.avatar:@""):self.avatarUrl) remoteBlock:^(UserInfo *user, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
                return;
            }
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [self performSegueWithIdentifier:@"UnSegue_NormalUserInfoEdit" sender:nil];
        }];
    }
    else {
        AdminUserInfo *admin = [UserModel sharedModel].currentAdminUser;
        [[UserModel sharedModel] updateAdminInfoWithNickName:nickname avatar:([MKWStringHelper isNilEmptyOrBlankString:self.avatarUrl]?(admin.avatar?admin.avatar:@""):self.avatarUrl) remoteBlock:^(BOOL isSuccess, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
                return;
            }
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [self performSegueWithIdentifier:@"UnSegue_NormalUserInfoEdit" sender:nil];
        }];
    }
    
}

@end
