//
//  PropertyNoteEditVC.m
//  Sunflower
//
//  Created by makewei on 15/5/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyNoteEditVC.h"
#import "GCExtension.h"
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>
#import "EYImagePickerViewController.h"
#import <SVProgressHUD.h>
#import "PropertyServiceModel.h"
#import "CommonModel.h"
#import "UserModel.h"

@interface PropertyNoteEditVC ()

@property(nonatomic,weak)IBOutlet UIScrollView  *scrollV;
@property(nonatomic,weak)IBOutlet UIView        *contentV;
@property(nonatomic,strong)UIImageView          *imageV;
@property(nonatomic,strong)UILabel              *imageTitleL;
@property(nonatomic,strong)UIButton             *uploadBtn;
@property(nonatomic,strong)UIButton             *camareBtn;
@property(nonatomic,strong)UIView               *separateV;
@property(nonatomic,strong)UILabel              *nameTitleL;
@property(nonatomic,strong)UITextField          *nameT;
@property(nonatomic,strong)UILabel              *detailTitleL;
@property(nonatomic,strong)UITextView           *detailT;
@property(nonatomic,strong)UIButton             *delBtn;
@property(nonatomic,strong)UIButton             *publicBtn;

@property(nonatomic,weak)UIView                 *focusedV;
@property(nonatomic,strong)NSString             *imageUrl;

@end

@implementation PropertyNoteEditVC

- (NSString *)umengPageName {
    return @"通知公告编辑";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_NoteEdit_NoteList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.note) {
        self.imageUrl = self.note.image;
    }
    [self.scrollV handleKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    
    [self _loadEditer];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutEditer];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)_loadEditer {
    self.imageV = ({
        UIImageView *v = [[UIImageView alloc] init];
        v;
    });
    if (self.note) {
        [self.imageV setImageWithURL:[NSURL URLWithString:self.note.image] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
    }
    
    UILabel *(^titleLabelBlock)(NSString *str) = ^(NSString *str){
        UILabel *l = [[UILabel alloc] init];
        l.backgroundColor = k_COLOR_CLEAR;
        l.font = [UIFont boldSystemFontOfSize:14];
        l.textColor = k_COLOR_GALLERY_F;
        l.text = str;
        return l;
    };
    UIButton *(^picButtonBlock)(NSString *str, NSString *bgImg) = ^(NSString *str, NSString *bgImg) {
        UIButton *b = [[UIButton alloc] init];
        b.backgroundColor = k_COLOR_CLEAR;
        [b setBackgroundImage:[UIImage imageNamed:bgImg] forState:UIControlStateNormal];
        [b setTitle:str forState:UIControlStateNormal];
        [b setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [b setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
        b.titleLabel.font = [UIFont systemFontOfSize:13];
        return b;
    };
    _weak(self);
    self.imageTitleL = titleLabelBlock(@"物业照片");
    self.uploadBtn = picButtonBlock(@"上传照片", @"upload_btn");
    [self.uploadBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        //TODO
        // upload pic
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
    self.camareBtn = picButtonBlock(@"立即拍照", @"camare_btn");
    [self.camareBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
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
    self.separateV = [[UIView alloc] init];
    self.separateV.backgroundColor = k_COLOR_GALLERY;
    self.nameTitleL = titleLabelBlock(@"公告标题:");
    self.nameT = [[UITextField alloc] init];
    self.nameT.layer.borderColor = [k_COLOR_GALLERY CGColor];
    self.nameT.layer.borderWidth = 1;
    self.nameT.layer.cornerRadius = 4;
    self.nameT.returnKeyType = UIReturnKeyDefault;
    self.nameT.font = [UIFont systemFontOfSize:14];
    self.nameT.textColor = k_COLOR_GALLERY_F;
    [self.nameT withBlockForDidBeginEditing:^(UITextField *view) {
        _strong(self);
        self.focusedV = view;
    }];
    [self.nameT withBlockForShouldReturn:^BOOL(UITextField *view) {
        [view resignFirstResponder];
        return YES;
    }];
    self.nameT.text = (self.note?self.note.title:@"");
    self.detailTitleL = titleLabelBlock(@"公告内容:");
    self.detailT = [[UITextView alloc] init];
    self.detailT.layer.borderWidth = 1;
    self.detailT.layer.borderColor = [k_COLOR_GALLERY CGColor];
    self.detailT.layer.cornerRadius = 4;
    self.detailT.font = [UIFont systemFontOfSize:14];
    self.detailT.textColor = k_COLOR_GALLERY_F;
    [self.detailT withBlockForDidBeginEditing:^(UITextView *view) {
        _strong(self);
        self.focusedV = view;
    }];
    self.detailT.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.detailT.text = (self.note?self.note.content:@"");
    
    self.delBtn = [[UIButton alloc] init];
    self.delBtn.backgroundColor = k_COLOR_RED;
    self.delBtn.layer.cornerRadius = 4;
    [self.delBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [self.delBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [self.delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.delBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if (!self.note) {
            return;
        }
        
        [[PropertyServiceModel sharedModel] asyncDeleteNoteInfoWithNoteId:self.note.noticeId remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
            if(error) {
                [SVProgressHUD showErrorWithStatus:@"删除失败，请检查网络"];
                return;
            }
            
            [SVProgressHUD showErrorWithStatus:@"删除成功"];
            [self performSegueWithIdentifier:@"UnSegue_NoteEdit_NoteList" sender:self.delBtn];
        }];
    }];
    
    
    self.publicBtn = [[UIButton alloc] init];
    self.publicBtn.backgroundColor = k_COLOR_BLUE;
    self.publicBtn.layer.cornerRadius = 4;
    [self.publicBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [self.publicBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [self.publicBtn setTitle:@"发布" forState:UIControlStateNormal];
    [self.publicBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        //TODO:
        //public the proerty info be edited
        if ([MKWStringHelper isNilEmptyOrBlankString:self.imageUrl]) {
            [SVProgressHUD showErrorWithStatus:@"请上传公告图片"];
            return;
        }
        
        NSString *name = [MKWStringHelper trimWithStr:self.nameT.text];
        if ([MKWStringHelper isNilEmptyOrBlankString:name]) {
            [SVProgressHUD showErrorWithStatus:@"请输入公告名称"];
            return;
        }
        
        NSString *desc = [MKWStringHelper trimWithStr:self.detailT.text];
        if ([MKWStringHelper isNilEmptyOrBlankString:desc]) {
            [SVProgressHUD showErrorWithStatus:@"请输入公告信息"];
            return;
        }
        
        if (self.note) {
            // Update
            [[PropertyServiceModel sharedModel] asyncUpdateNoteInfoWithNoteId:self.note.noticeId communityId:[[[UserModel sharedModel] currentAdminUser] communityId] title:name detail:desc image:self.imageUrl remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                _strong(self);
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"修改失败，请检查网络"];
                    return;
                }
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self performSegueWithIdentifier:@"UnSegue_NoteEdit_NoteList" sender:self.publicBtn];
            }];
        }
        else {
            [[PropertyServiceModel sharedModel] asyncAddNoteInfoWithCommunityId:[[[UserModel sharedModel] currentAdminUser] communityId] title:name detail:desc image:self.imageUrl remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                _strong(self);
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"发布失败，请检查网络"];
                    return;
                }
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                [self performSegueWithIdentifier:@"UnSegue_NoteEdit_NoteList" sender:self.publicBtn];
            }];
        }
    }];
}

- (void)_layoutEditer {
    if ([self.imageV superview]) {
        return;
    }
    
    _weak(self);
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
        make.height.equalTo(@508);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
        if (self.focusedV) {
            [self.focusedV resignFirstResponder];
        }
    }];
    [self.contentV addGestureRecognizer:tap];
    
    [self.contentV addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(15);
        make.left.equalTo(self.contentV).with.offset(10);
        make.height.equalTo(@114);
        make.width.equalTo(@200);
    }];
    
    [self.contentV addSubview:self.imageTitleL];
    [self.imageTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.imageV);
        make.left.equalTo(self.imageV.mas_right).with.offset(10);
        make.right.equalTo(self.contentV).with.offset(-13);
        make.height.equalTo(@14);
    }];
    
    [self.contentV addSubview:self.camareBtn];
    [self.camareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.bottom.equalTo(self.imageV);
        make.left.equalTo(self.imageV.mas_right).with.offset(10);
        make.right.equalTo(self.imageTitleL);
        make.height.equalTo(@35);
    }];
    
    [self.contentV addSubview:self.uploadBtn];
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.bottom.equalTo(self.camareBtn.mas_top).with.offset(-10);
        make.left.right.height.equalTo(self.camareBtn);
    }];
    
    [self.contentV addSubview:self.separateV];
    [self.separateV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.imageV.mas_bottom).with.offset(15);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    [self.contentV addSubview:self.nameTitleL];
    [self.nameTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.separateV.mas_bottom).with.offset(13);
        make.left.equalTo(self.imageV);
        make.right.equalTo(self.camareBtn);
        make.height.equalTo(@14);
    }];
    
    [self.contentV addSubview:self.nameT];
    [self.nameT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nameTitleL.mas_bottom).with.offset(10);
        make.left.right.equalTo(self.nameTitleL);
        make.height.equalTo(@34);
    }];
    
    [self.contentV addSubview:self.detailTitleL];
    [self.detailTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nameT.mas_bottom).with.offset(13);
        make.left.right.height.equalTo(self.nameTitleL);
    }];
    
    [self.contentV addSubview:self.detailT];
    [self.detailT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.detailTitleL.mas_bottom).with.offset(10);
        make.left.right.equalTo(self.nameT);
        make.height.equalTo(@165);
    }];
    
    NSNumber *btnWidth = @((V_W_(self.view)-30)/2);
    _weak(btnWidth);
    [self.contentV addSubview:self.delBtn];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(btnWidth);
        make.top.equalTo(self.detailT.mas_bottom).with.offset(10);
        make.left.equalTo(self.detailT);
        make.width.equalTo(btnWidth);
        make.height.equalTo(@43);
    }];
    
    [self.contentV addSubview:self.publicBtn];
    [self.publicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(btnWidth);
        make.top.equalTo(self.detailT.mas_bottom).with.offset(10);
        make.right.equalTo(self.detailT);
        make.width.equalTo(btnWidth);
        make.height.equalTo(@43);
    }];
}

@end
