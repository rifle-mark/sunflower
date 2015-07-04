//
//  ShopCouponEditVC.m
//  Sunflower
//
//  Created by makewei on 15/5/23.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopCouponEditVC.h"

#import "GCExtension.h"
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>
#import "EYImagePickerViewController.h"
#import <SVProgressHUD.h>

#import "UserModel.h"
#import "CommonModel.h"
#import "CommunityLifeModel.h"

@interface ShopCouponEditVC ()

@property(nonatomic,strong)UIScrollView         *scrollV;
@property(nonatomic,strong)UIView               *contentV;
@property(nonatomic,strong)UIImageView          *imageV;
@property(nonatomic,strong)UILabel              *imageTitleL;
@property(nonatomic,strong)UILabel              *imageSuggestL;
@property(nonatomic,strong)UIView               *sepratorV;
@property(nonatomic,strong)UIButton             *uploadBtn;
@property(nonatomic,strong)UILabel              *nameTitleL;
@property(nonatomic,strong)UITextField          *nameT;
@property(nonatomic,strong)UILabel              *themTitleL;
@property(nonatomic,strong)UITextField          *themT;
@property(nonatomic,strong)UILabel              *endDateTitleL;
@property(nonatomic,strong)UILabel              *detailTitleL;
@property(nonatomic,strong)UIDatePicker         *datePicker;
@property(nonatomic,strong)UIButton              *endDateL;
@property(nonatomic,strong)UITextView           *detailT;
@property(nonatomic,strong)UIButton             *deleteBtn;
@property(nonatomic,strong)UIButton             *submitBtn;

@property(nonatomic,weak)UIView                 *focusedV;
@property(nonatomic,strong)NSString             *imageUrl;
@property(nonatomic,strong)NSDate               *endDate;
@property(nonatomic,strong)CouponInfo           *coupon;

@end

@implementation ShopCouponEditVC

- (NSString *)umengPageName {
    return @"商户优惠券编辑";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_CouponEdit_CouponList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    
    [self _refreshCouponInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView {
    [super loadView];
    
    // load self view;
    [self _loadEditor];
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //layour self subview;
    [self _layoutEditor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"coupon" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.imageV setImageWithURL:[NSURL URLWithString:self.coupon.image] placeholderImage:nil];
        self.nameT.text = self.coupon.name;
        self.themT.text = self.coupon.subTitle;
        self.detailT.text = self.coupon.couponDesc;
        [self.endDateL setTitle:[self.coupon.endDate dateSplitByChinese] forState:UIControlStateNormal];
    }];
}

- (void)_refreshCouponInfo {
    _weak(self);
    if (!self.couponId) {
        return;
    }
    [[CommunityLifeModel sharedModel] asyncCouponWithCouponId:self.couponId cacheBlock:nil remoteBlock:^(CouponInfo *info, NSArray *shopList, NSError *error) {
        _strong(self);
        self.coupon = info;
    }];
}

- (void)_loadEditor {
    self.scrollV = [[UIScrollView alloc] init];
    self.scrollV.showsHorizontalScrollIndicator = NO;
    self.scrollV.showsVerticalScrollIndicator = NO;
    
    self.contentV = [[UIView alloc] init];
    [self.scrollV addSubview:self.contentV];
    
    self.imageV = ({
        UIImageView *v = [[UIImageView alloc] init];
        v.layer.borderColor = [k_COLOR_GALLERY CGColor];
        v.layer.borderWidth = 1;
        v;
    });
    
    self.imageTitleL = ({
        UILabel *l = [[UILabel alloc] init];
        l.font = [UIFont boldSystemFontOfSize:14];
        l.textColor = k_COLOR_BLUE;
        l.text = @"优惠产品图片";
        l;
    });
    self.imageSuggestL = ({
        UILabel *l = [[UILabel alloc] init];
        l.font = [UIFont boldSystemFontOfSize:10];
        l.textColor = k_COLOR_GALLERY_F;
        l.text = @"建议750x375";
        l;
    });
    
    self.uploadBtn = ({
        UIButton *b = [[UIButton alloc] init];
        b.backgroundColor = k_COLOR_BLUE;
        b.layer.cornerRadius = 4;
        [b setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [b setTitle:@"上传图片" forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:14];
        _weak(self);
        [b addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
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
                        [[CommonModel sharedModel] uploadImage:thumbnail path:filePath progress:nil remoteBlock:^(NSString *url, NSError *error) {
                            if (!error) {
                                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                [self.imageV setImage:thumbnail];
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
        b;
    });
    
    self.sepratorV = ({
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = k_COLOR_GALLERY;
        v;
    });
    
    UILabel *(^subLabelBlock)(NSString *str) = ^(NSString *str) {
        UILabel *l = [[UILabel alloc] init];
        l.font = [UIFont boldSystemFontOfSize:14];
        l.textColor = k_COLOR_GALLERY_F;
        l.text = str;
        return l;
    };
    
    _weak(self);
    UITextField *(^textFieldBlock)() = ^{
        UITextField *t = [[UITextField alloc] init];
        t.borderStyle = UITextBorderStyleRoundedRect;
        t.autocapitalizationType = UITextAutocapitalizationTypeNone;
        t.autocorrectionType = UITextAutocorrectionTypeNo;
        t.returnKeyType = UIReturnKeyDone;
        t.font = [UIFont systemFontOfSize:14];
        t.textColor = k_COLOR_GALLERY_F;
        [t withBlockForDidBeginEditing:^(UITextField *view) {
            _strong(self);
            self.focusedV = view;
        }];
        [t withBlockForShouldReturn:^BOOL(UITextField *view) {
            [view resignFirstResponder];
            return YES;
        }];
        return t;
    };
    
    self.nameTitleL = subLabelBlock(@"产品名称:");
    self.nameT = textFieldBlock();
    self.themTitleL = subLabelBlock(@"优惠主题:");
    self.themT = textFieldBlock();
    self.endDateTitleL = subLabelBlock(@"有效日期:");
    self.endDateL = [[UIButton alloc] init];
    self.endDateL.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.endDateL setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
    self.endDateL.layer.borderColor = [k_COLOR_GALLERY CGColor];
    self.endDateL.layer.borderWidth = 1;
    self.endDateL.layer.cornerRadius = 4;
    [self.endDateL setTitle:@"点击选择日期" forState:UIControlStateNormal];
    [self.endDateL addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if ([self.datePicker isHidden]) {
            [self.datePicker setHidden:NO];
        }
    }];
    
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker setHidden:YES];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = k_COLOR_GALLERY;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.detailTitleL = subLabelBlock(@"优惠细则");
    self.detailT = ({
        UITextView *v = [[UITextView alloc] init];
        v.font = [UIFont systemFontOfSize:14];
        v.textColor = k_COLOR_GALLERY_F;
        v.textContainerInset = UIEdgeInsetsMake(15, 5, 15, 5);
        v.layer.borderColor = [k_COLOR_GALLERY CGColor];
        v.layer.borderWidth = 1;
        v.layer.cornerRadius = 4;
        [v withBlockForDidBeginEditing:^(UITextView *view) {
            _strong(self);
            self.focusedV = view;
        }];
        v;
    });
    
    self.deleteBtn = ({
        UIButton *b = [[UIButton alloc] init];
        b.layer.borderWidth = 1;
        b.layer.borderColor = [k_COLOR_MINE_SHAFT CGColor];
        b.layer.cornerRadius = 4;
        [b setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [b setTitle:@"删除" forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:14];
        if (!self.couponId) {
            [b setEnabled:NO];
        }
        [b addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"确认删除" andMessage:@"你确定要删除这项优惠吗？"];
            [alert setCancelButtonWithTitle:@"取消" actionBlock:nil];
            [alert addOtherButtonWithTitle:@"删除" actionBlock:^{
                _strong(self);
                if (!self.couponId) {
                    return ;
                }
                [[UserModel sharedModel] asyncDeleteCouponWithCouponId:self.couponId remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                    _strong(self);
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [self performSegueWithIdentifier:@"UnSegue_CouponEdit_CouponList" sender:self.deleteBtn];
                        return;
                    }
                    [SVProgressHUD showSuccessWithStatus:@"删除失败，请检查网络"];
                }];
            }];
        }];
        b;
    });
    
    self.submitBtn = ({
        UIButton *b = [[UIButton alloc] init];
        b.layer.cornerRadius = 4;
        [b setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        b.backgroundColor = k_COLOR_BLUE;
        [b setTitle:@"提交" forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:14];
        [b addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            if ([MKWStringHelper isNilEmptyOrBlankString:self.imageUrl]) {
                [SVProgressHUD showErrorWithStatus:@"请上传产品图片"];
                return;
            }
            
            NSString *name = [MKWStringHelper trimWithStr:self.nameT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:name]) {
                [SVProgressHUD showErrorWithStatus:@"请输入产品名称"];
                return;
            }
            
            NSString *them = [MKWStringHelper trimWithStr:self.themT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:them]) {
                [SVProgressHUD showErrorWithStatus:@"请输入优惠主题"];
                return;
            }
            
            if (!self.endDate) {
                [SVProgressHUD showErrorWithStatus:@"请选择到期日期"];
                return;
            }
            
            NSString *endDateStr = [NSString stringWithFormat:@"/Date(%ld000)/", (NSUInteger)[self.endDate timeIntervalSince1970]];
            
            NSString *desc = [MKWStringHelper trimWithStr:self.detailT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:desc]) {
                [SVProgressHUD showErrorWithStatus:@"请输优惠细则"];
                return;
            }
            
            if (self.couponId) {
                [[UserModel sharedModel] asyncUpdateCouponWithCouponId:self.couponId name:name subTitle:them endDate:endDateStr detail:desc imgUrl:self.imageUrl remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                        [self performSegueWithIdentifier:@"UnSegue_CouponEdit_CouponList" sender:nil];
                        return;
                    }
                    [SVProgressHUD showErrorWithStatus:@"修改失败，请检查网络"];
                }];
            }
            else {
                [[UserModel sharedModel] asyncAddCouponWithName:name subTitle:them endDate:endDateStr detail:desc imgUrl:self.imageUrl remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                        [self performSegueWithIdentifier:@"UnSegue_CouponEdit_CouponList" sender:nil];
                        return;
                    }
                    [SVProgressHUD showErrorWithStatus:@"添加失败，请检查网络"];
                }];
            }
        }];
        b;
    });
    
    [self.contentV addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(8);
        make.left.equalTo(self.contentV).with.offset(13);
        make.width.equalTo(@176);
        make.height.equalTo(@88);
    }];
    
    [self.contentV addSubview:self.imageTitleL];
    [self.imageTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(16);
        make.left.equalTo(self.imageV.mas_right).with.offset(21);
        make.right.equalTo(self.contentV).with.offset(-13);
        make.height.equalTo(@14);
    }];
    
    [self.contentV addSubview:self.imageSuggestL];
    [self.imageSuggestL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.imageTitleL.mas_bottom).with.offset(8);
        make.left.equalTo(self.imageTitleL);
        make.right.equalTo(self.imageTitleL);
        make.height.equalTo(@10);
    }];
    
    [self.contentV addSubview:self.uploadBtn];
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.imageSuggestL.mas_bottom).with.offset(8);
        make.left.equalTo(self.imageSuggestL);
        make.width.equalTo(@94);
        make.height.equalTo(@35);
    }];
    
    [self.contentV addSubview:self.sepratorV];
    [self.sepratorV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.imageV.mas_bottom).with.offset(8);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    [self.contentV addSubview:self.nameTitleL];
    [self.nameTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.sepratorV.mas_bottom).with.offset(9);
        make.left.equalTo(self.imageV);
        make.right.equalTo(self.imageTitleL);
        make.height.equalTo(@14);
    }];
    
    [self.contentV addSubview:self.nameT];
    [self.nameT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nameTitleL.mas_bottom).with.offset(8);
        make.left.equalTo(self.imageV);
        make.right.equalTo(self.nameTitleL);
        make.height.equalTo(@34);
    }];
    
    [self.contentV addSubview:self.themTitleL];
    [self.themTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nameT.mas_bottom).with.offset(8);
        make.left.right.height.equalTo(self.nameTitleL);
    }];
    
    [self.contentV addSubview:self.themT];
    [self.themT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.themTitleL.mas_bottom).with.offset(8);
        make.left.right.height.equalTo(self.nameT);
    }];
    
    [self.contentV addSubview:self.endDateTitleL];
    [self.endDateTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.themT.mas_bottom).with.offset(8);
        make.left.right.height.equalTo(self.nameTitleL);
    }];
    
    [self.contentV addSubview:self.endDateL];
    [self.endDateL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.endDateTitleL.mas_bottom).with.offset(8);
        make.left.right.height.equalTo(self.nameT);
    }];
    [self.contentV addSubview:self.detailTitleL];
    [self.detailTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.imageV);
        make.right.equalTo(self.nameT);
        make.top.equalTo(self.endDateL.mas_bottom).with.offset(8);
        make.height.equalTo(self.nameTitleL);
    }];
    
    [self.contentV addSubview:self.detailT];
    [self.detailT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.detailTitleL.mas_bottom).with.offset(8);
        make.left.right.equalTo(self.nameT);
        make.height.equalTo(@140);
    }];
    
    NSNumber *btnW = @((V_W_(self.view) - 31)/2);
    _weak(btnW);
    [self.contentV addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(btnW);
        make.top.equalTo(self.detailT.mas_bottom).with.offset(8);
        make.left.equalTo(self.imageV);
        make.height.equalTo(@35);
        make.width.equalTo(btnW);
    }];
    [self.contentV addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.deleteBtn);
        make.right.equalTo(self.nameT);
        make.height.equalTo(self.deleteBtn);
        make.width.equalTo(self.deleteBtn);
    }];
}

- (void)_layoutEditor {
    if ([self.scrollV superview]) {
        return;
    }
    
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
    [self.view addSubview:self.scrollV];
    _weak(topTmp);
    _weak(botTmp);
    [self.scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(topTmp);
        _strong(botTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];

    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.bottom.equalTo(self.scrollV);
        make.width.equalTo(self.view);
        make.height.equalTo(@540);
    }];
    
    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@216);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        if (self.focusedV) {
            [self.focusedV resignFirstResponder];
        }
        if (!self.datePicker.isHidden) {
            [self.datePicker setHidden:YES];
        }
        return NO;
    }];
    [self.contentV addGestureRecognizer:tap];

    
    
}

- (void)dateChanged:(id)sender {
    if ([self.endDateL superview]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        [self.endDateL setTitle:[formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
        self.endDate = self.datePicker.date;
    }
}
@end
