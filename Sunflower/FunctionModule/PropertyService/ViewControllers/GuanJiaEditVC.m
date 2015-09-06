//
//  GuanJiaEditVC.m
//  Sunflower
//
//  Created by makewei on 15/6/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "GuanJiaEditVC.h"
#import "EYImagePickerViewController.h"
#import "MKWTextField.h"

#import "PropertyServiceModel.h"
#import "CommonModel.h"

#import <UIImageView+WebCache.h>

@interface GuanJiaEditVC ()

@property(nonatomic,strong)UIScrollView     *editScrolV;
@property(nonatomic,strong)UIView           *contentV;

@property(nonatomic,strong)UIImageView      *imageV;
@property(nonatomic,strong)MKWTextField     *nameT;
@property(nonatomic,strong)MKWTextField     *titleT;
@property(nonatomic,strong)MKWTextField     *telT;
@property(nonatomic,strong)UIButton         *deleteBtn;
@property(nonatomic,strong)UIButton         *saveBtn;
@property(nonatomic,weak)UIView             *focusedT;


@property(nonatomic,strong)NSString         *imageUrl;

@end

@implementation GuanJiaEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.editScrolV handleKeyboard];
    [self _setupTapGesture];
    [self _loadData];
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
    FixesViewDidLayoutSubviewsiOS7Error;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (!self.editScrolV) {
        self.editScrolV = [[UIScrollView alloc] init];
        self.editScrolV.showsHorizontalScrollIndicator = NO;
        self.editScrolV.showsVerticalScrollIndicator = NO;
        
        _weak(self);
        self.contentV = [[UIView alloc] init];
        [self.editScrolV addSubview:self.contentV];
        
        self.imageV = [[UIImageView alloc] init];
        self.imageV.layer.borderColor = [k_COLOR_GALLERY CGColor];
        self.imageV.layer.borderWidth = 1;
        [self.contentV addSubview:self.imageV];
        
        UILabel *(^labelBlock)(CGFloat font, UIColor *txtColor, NSString *txt) = ^(CGFloat font, UIColor *txtColor, NSString *txt){
            UILabel *l = [[UILabel alloc] init];
            l.font = [UIFont boldSystemFontOfSize:font];
            l.text = txt;
            l.textColor = txtColor;
            return l;
        };
        MKWTextField *(^textFiledBlock)(UIKeyboardType type) = ^(UIKeyboardType type){
            MKWTextField *filed = [[MKWTextField alloc] init];
            filed.background = [UIImage imageNamed:@"edit_filed_bg"];
            filed.textEdgeInset = UIEdgeInsetsMake(7, 15, 7, 15);
            filed.keyboardType = type;
            filed.autocapitalizationType = UITextAutocapitalizationTypeNone;
            filed.autocorrectionType = UITextAutocorrectionTypeNo;
            filed.font = [UIFont boldSystemFontOfSize:14];
            filed.textColor = k_COLOR_GALLERY_F;
            [filed withBlockForDidBeginEditing:^(UITextField *view) {
                _strong(self);
                self.focusedT = view;
            }];
            [filed withBlockForShouldReturn:^BOOL(UITextField *view) {
                _strong(self);
                self.focusedT = nil;
                [view resignFirstResponder];
                return YES;
            }];
            return filed;
        };
        
        UILabel *imgTitleL = labelBlock(17, k_COLOR_BLUE, @"物业管家照片");
        [self.contentV addSubview:imgTitleL];
        UILabel *imgSubTitleL = labelBlock(12, k_COLOR_GALLERY_F, @"请上传物业管家照片,以便更好的为社区服务");
        imgSubTitleL.numberOfLines = 2;
        [self.contentV addSubview:imgSubTitleL];
        
        UIButton *(^picButtonBlock)(NSString *str, NSString *bgImg, NSString *icoImg) = ^(NSString *str, NSString *bgImg, NSString *icoImg) {
            UIButton *b = [[UIButton alloc] init];
            b.backgroundColor = k_COLOR_CLEAR;
            [b setBackgroundImage:[UIImage imageNamed:bgImg] forState:UIControlStateNormal];
            [b setImage:[UIImage imageNamed:icoImg] forState:UIControlStateNormal];
            [b setTitle:str forState:UIControlStateNormal];
            [b setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
            [b setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
            [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            b.titleLabel.font = [UIFont systemFontOfSize:13];
            return b;
        };
        
        UIButton *uploadBtn = picButtonBlock(@"上传照片", @"btn_bg_blue", @"ico_photo");
        [uploadBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
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
                        _strong(self);
                        [SVProgressHUD showWithStatus:@"正在上传图片" maskType:SVProgressHUDMaskTypeClear];
                        UIImage *newImage = [thumbnail adjustedToStandardSize];
                        [[CommonModel sharedModel] uploadImage:newImage path:filePath progress:nil remoteBlock:^(NSString *url, NSError *error) {
                            if (!error) {
                                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                [self.imageV setImage:newImage];
                                self.imageUrl = url;
                            }
                            else {
                                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                            }
                        }];
                        
                    }];
                }];
                [self presentViewController:picker animated:YES completion:nil];
            };
            
            EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForLibraryPhotoEditable:NO];
            SetupEYImagePicker(picker);
        }];
        [self.contentV addSubview:uploadBtn];
        
        
        UIButton *camareBtn = picButtonBlock(@"立即拍照", @"btn_bg_blue", @"ico_camera");
        [camareBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if (![EYImagePickerViewController isCameraPhotoAvailable]) {
                [SVProgressHUD showErrorWithStatus:@"照相机不可用，请修改设置"];
                return;
            }
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
                        _strong(self);
                        [SVProgressHUD showWithStatus:@"正在上传图片" maskType:SVProgressHUDMaskTypeClear];
                        UIImage *newImage = [thumbnail adjustedToStandardSize];
                        [[CommonModel sharedModel] uploadImage:newImage path:filePath progress:nil remoteBlock:^(NSString *url, NSError *error) {
                            if (!error) {
                                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                [self.imageV setImage:newImage];
                                self.imageUrl = url;
                            }
                            else {
                                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                            }
                        }];
                        
                    }];
                }];
                [self presentViewController:picker animated:YES completion:nil];
            };
            
            EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForCameraPhotoEditable:NO];
            SetupEYImagePicker(picker);
        }];
        [self.contentV addSubview:camareBtn];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = k_COLOR_GALLERY;
        [self.contentV addSubview:lineV];
        
        UILabel *nameTitleL = labelBlock(15, k_COLOR_GALLERY_F, @"姓名:");
        [self.contentV addSubview:nameTitleL];
        self.nameT = textFiledBlock(UIKeyboardTypeDefault);
        [self.contentV addSubview:self.nameT];
        UILabel *jobTitleL = labelBlock(15, k_COLOR_GALLERY_F, @"职务:");
        [self.contentV addSubview:jobTitleL];
        self.titleT = textFiledBlock(UIKeyboardTypeDefault);
        [self.contentV addSubview:self.titleT];
        UILabel *telTitleL = labelBlock(15, k_COLOR_GALLERY_F, @"电话:");
        [self.contentV addSubview:telTitleL];
        self.telT = textFiledBlock(UIKeyboardTypeNamePhonePad);
        [self.contentV addSubview:self.telT];
        self.deleteBtn = [[UIButton alloc] init];
        self.deleteBtn.backgroundColor = k_COLOR_RED;
        self.deleteBtn.layer.cornerRadius = 4;
        self.deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        [self.deleteBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateDisabled];
        [self.deleteBtn setEnabled:NO];
        [self.deleteBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if (!self.guanjia) {
                return;
            }
            
            GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"删除管家" andMessage:@"您确定要删除该管家吗？"];
            [alert setCancelButtonWithTitle:@"取消" actionBlock:nil];
            [alert addOtherButtonWithTitle:@"删除" actionBlock:^{
                [[PropertyServiceModel sharedModel] asyncDeleteGuanJiaWithGuanJiaId:self.guanjia.guanjiaId remoteBlock:^(BOOL isSuccess, NSError *error) {
                    _strong(self);
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.domain];
                        return;
                    }
                    
                    [SVProgressHUD showErrorWithStatus:@"操作成功"];
                    [self performSegueWithIdentifier:[self unwindSegueIdentify] sender:nil];
                }];
            }];
            [alert show];
        }];
        [self.contentV addSubview:self.deleteBtn];
        self.saveBtn = [[UIButton alloc] init];
        self.saveBtn.backgroundColor = k_COLOR_BLUE;
        self.saveBtn.layer.cornerRadius = 4;
        self.saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.saveBtn setTitle:@"发布" forState:UIControlStateNormal];
        [self.saveBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [self.saveBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        [self.saveBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateSelected];
        [self.saveBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if (!self.guanjia && [MKWStringHelper isNilEmptyOrBlankString:self.imageUrl]) {
                [SVProgressHUD showErrorWithStatus:@"请上传图片"];
                return;
            }
            NSString *name = [MKWStringHelper trimWithStr:self.nameT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:name]) {
                [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
                return;
            }
            NSString *job = [MKWStringHelper trimWithStr:self.titleT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:job]) {
                [SVProgressHUD showErrorWithStatus:@"请输入职务"];
                return;
            }
            NSString *tel = [MKWStringHelper trimWithStr:self.telT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:tel]) {
                [SVProgressHUD showErrorWithStatus:@"请输入电话"];
                return;
            }
            
            if (self.guanjia) {
                [[PropertyServiceModel sharedModel] asyncUpdateGuanJiaWithGuanJiaId:self.guanjia.guanjiaId communityId:[CommonModel sharedModel].currentCommunityId userName:name job:job tel:tel image:([MKWStringHelper isNilEmptyOrBlankString:self.imageUrl]?self.guanjia.image:self.imageUrl) remoteBlock:^(BOOL isSuccess, NSError *error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.domain];
                        return;
                    }
                    
                    [SVProgressHUD showErrorWithStatus:@"发布成功"];
                    [self performSegueWithIdentifier:[self unwindSegueIdentify] sender:nil];
                }];
            }
            else {
                [[PropertyServiceModel sharedModel] asyncAddGuanJiaWithCommunityId:[CommonModel sharedModel].currentCommunityId userName:name job:job tel:tel image:self.imageUrl remoteBlock:^(BOOL isSuccess, NSError *error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.domain];
                        return;
                    }
                    
                    [SVProgressHUD showErrorWithStatus:@"发布成功"];
                    [self performSegueWithIdentifier:[self unwindSegueIdentify] sender:nil];
                }];
            }
            
        }];
        [self.contentV addSubview:self.saveBtn];
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentV).with.offset(10);
            make.left.equalTo(self.contentV).with.offset(10);
            make.width.equalTo(@131);
            make.height.equalTo(@161);
        }];
        [imgTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentV).with.offset(15);
            make.left.equalTo(self.imageV.mas_right).with.offset(15);
            make.height.equalTo(@17);
            make.right.equalTo(self.contentV).with.offset(-27);
        }];
        _weak(imgTitleL);
        [imgSubTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(imgTitleL);
            make.top.equalTo(imgTitleL.mas_bottom).with.offset(10);
            make.left.equalTo(self.imageV.mas_right).with.offset(15);
            make.height.equalTo(@35);
            make.right.equalTo(self.contentV).with.offset(-27);
        }];
        _weak(imgSubTitleL);
        [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(imgSubTitleL);
            make.top.equalTo(imgSubTitleL.mas_bottom).with.offset(10);
            make.left.equalTo(imgSubTitleL);
            make.width.equalTo(@142);
            make.height.equalTo(@35);
        }];
        _weak(uploadBtn);
        [camareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(uploadBtn);
            make.top.equalTo(uploadBtn.mas_bottom).with.offset(10);
            make.left.width.height.equalTo(uploadBtn);
        }];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.imageV.mas_bottom).with.offset(9);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@1);
        }];
        _weak(lineV);
        [nameTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(lineV);
            make.top.equalTo(lineV.mas_bottom).with.offset(14);
            make.left.equalTo(self.contentV).with.offset(13);
            make.right.equalTo(self.contentV).with.offset(-13);
            make.height.equalTo(@15);
        }];
        _weak(nameTitleL);
        [self.nameT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(nameTitleL);
            make.top.equalTo(nameTitleL.mas_bottom).with.offset(8);
            make.left.right.equalTo(nameTitleL);
            make.height.equalTo(@35);
        }];
        [jobTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(nameTitleL);
            make.top.equalTo(self.nameT.mas_bottom).with.offset(14);
            make.left.right.height.equalTo(nameTitleL);
        }];
        _weak(jobTitleL);
        [self.titleT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(jobTitleL);
            make.top.equalTo(jobTitleL.mas_bottom).with.offset(8);
            make.left.right.height.equalTo(self.nameT);
        }];
        [telTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(nameTitleL);
            make.top.equalTo(self.titleT.mas_bottom).with.offset(14);
            make.left.right.height.equalTo(nameTitleL);
        }];
        _weak(telTitleL);
        [self.telT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(telTitleL);
            make.top.equalTo(telTitleL.mas_bottom).with.offset(8);
            make.left.right.height.equalTo(self.nameT);
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.nameT);
            make.right.equalTo(self.contentV.mas_centerX).with.offset(-3);
            make.top.equalTo(self.telT.mas_bottom).with.offset(12);
            make.height.equalTo(@43);
        }];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.equalTo(self.contentV.mas_centerX).with.offset(3);
            make.right.equalTo(self.nameT);
            make.top.height.equalTo(self.deleteBtn);
        }];
    }
}

- (void)_layoutCodingViews {
    if (![self.editScrolV superview]) {
        _weak(self);
        UIView *topTmp = [[UIView alloc] init];
        topTmp.backgroundColor = k_COLOR_CLEAR;
        [self.view addSubview:topTmp];
        [topTmp mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(self.topLayoutGuide.length));
        }];
        
        UIView *botTmp = [[UIView alloc] init];
        botTmp.backgroundColor = k_COLOR_CLEAR;
        [self.view addSubview:botTmp];
        [botTmp mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.left.right.equalTo(self.view);
            make.height.equalTo(@(self.bottomLayoutGuide.length));
        }];
        
        _weak(topTmp);
        _weak(botTmp);
        [self.view addSubview:self.editScrolV];
        [self.editScrolV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(topTmp);
            _strong(botTmp);
            make.top.equalTo(topTmp.mas_bottom);
            make.bottom.equalTo(botTmp.mas_top);
            make.left.right.equalTo(self.view);
        }];
        
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.bottom.top.equalTo(self.editScrolV);
            make.width.equalTo(self.view);
            make.height.equalTo(@465);
        }];
        
    }
}

- (void)_setupTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        if (self.focusedT && [self.focusedT isFirstResponder]) {
            [self.focusedT resignFirstResponder];
            self.focusedT = nil;
        }
        return NO;
    }];
    
    [self.view addGestureRecognizer:tap];
}

- (void)_loadData {
    if (self.guanjia) {
        [self.imageV sd_setImageWithURL:[APIGenerator urlOfPictureWith:131 height:161 urlString:self.guanjia.image] placeholderImage:[UIImage imageNamed:@"default_left_height"]];
        self.nameT.text = self.guanjia.name;
        self.titleT.text = self.guanjia.title;
        self.telT.text = self.guanjia.phone;
        [self.deleteBtn setEnabled:YES];
    }
    else {
        [self.deleteBtn setEnabled:NO];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_Property_GuanJiaEdit";
}

- (NSString *)umengPageName {
    return @"管家编辑";
}

@end
