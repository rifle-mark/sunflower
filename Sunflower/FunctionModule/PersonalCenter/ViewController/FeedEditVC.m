//
//  FeedEditVC.m
//  Sunflower
//
//  Created by kelei on 15/7/25.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "FeedEditVC.h"
#import "EYImagePickerViewController.h"
#import "CommonModel.h"
#import "UserModel.h"


@interface FeedEditPicCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView      *imgV;
@property(nonatomic,strong)UIButton         *deleteBtn;
@property(nonatomic,strong)UIButton         *pickBtn;

@property(nonatomic,strong)NSString         *imgUrl;

@property(nonatomic,copy)void(^imageDeleteBlock)(NSString *imgUrl, UIImage *img);
@property(nonatomic,copy)void(^imagePickBlock)(FeedEditPicCell *cell);

+ (NSString *)reuseIdentify;

@end

@implementation FeedEditPicCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imgV];
        _weak(self);
        [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(8);
            make.right.equalTo(self.contentView).with.offset(-8);
        }];
        self.deleteBtn = [[UIButton alloc] init];
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"life_wecomment_img_delete_btn"] forState:UIControlStateNormal];
        [self.deleteBtn addControlEvents:UIControlEventTouchDown action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.imageDeleteBlock, self.imgUrl, self.imgV.image);
        }];
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerX.equalTo(self.imgV.mas_right);
            make.centerY.equalTo(self.imgV.mas_top);
            make.width.height.equalTo(@16);
        }];
        
        self.pickBtn = [[UIButton alloc] init];
        [self.pickBtn setBackgroundImage:[UIImage imageNamed:@"life_weicomment_img_add_btn"] forState:UIControlStateNormal];
        [self.pickBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.imagePickBlock, self);
        }];
        [self.contentView addSubview:self.pickBtn];
        [self.pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(8);
            make.right.equalTo(self.contentView).with.offset(-8);
        }];
        
        [self.imgV setHidden:YES];
        [self.deleteBtn setHidden:YES];
        
        [self _setupObserver];
    }
    
    return self;
}

- (void)prepareForReuse {
    [self.pickBtn setHidden:NO];
    [self.imgV setHidden:YES];
    [self.deleteBtn setHidden:YES];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"imgUrl" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.imgUrl) {
            [self.imgV setHidden:NO];
            [self.deleteBtn setHidden:NO];
            [self.pickBtn setHidden:YES];
        }
        else {
            [self.pickBtn setHidden:NO];
            [self.imgV setHidden:YES];
            [self.deleteBtn setHidden:YES];
        }
    }];
}

+ (NSString *)reuseIdentify {
    return @"WeiCommentEditPicCellIdentify";
}

@end




@interface FeedEditVC ()

@property(nonatomic,strong)UILabel          *contentTitleL;
@property(nonatomic,strong)UITextView       *contentTextV;
@property(nonatomic,strong)UILabel          *picsTitleL;
@property(nonatomic,strong)UILabel          *picsDescriptionL;
@property(nonatomic,strong)UICollectionView *picsV;
@property(nonatomic,strong)UIButton         *submitB;

@property(nonatomic,strong)NSMutableArray   *picUrlArray;
@property(nonatomic,strong)NSMutableArray   *picArray;

@end

static NSString *const kContentHint = @"请输入反馈，我们将为您不断改进";

@implementation FeedEditVC

- (NSString *)umengPageName {
    return @"意见反馈";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_FeedEdit";
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.picUrlArray = [[NSMutableArray alloc] init];
    self.picArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    _weak(self);
    if (!self.contentTitleL) {
        self.contentTitleL = ({
            UILabel *v = [[UILabel alloc] init];
            v.text = @"反馈内容：";
            v.textColor = k_COLOR_GALLERY_F;
            v;
        });
    }
    if (!self.contentTextV) {
        self.contentTextV = ({
            UITextView *v = [[UITextView alloc] init];
            v.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            v.backgroundColor = k_COLOR_CLEAR;
            v.textColor = k_COLOR_GALLERY_F;
            v.font = [UIFont boldSystemFontOfSize:15];
            v.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
            v.text = kContentHint;
            v.layer.borderColor = k_COLOR_GALLERY_F.CGColor;
            v.layer.borderWidth = 1;
            v.layer.cornerRadius = 5;
            [v withBlockForDidBeginEditing:^(UITextView *view) {
                _strong(self);
                if ([self.contentTextV.text isEqualToString:kContentHint]) {
                    self.contentTextV.text = @"";
                }
            }];
            
            UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_inputViewDone)];
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
            toolBar.items = @[fixItem, doneItem];
            v.inputAccessoryView = toolBar;
            v;
        });
    }
    if (!self.picsTitleL) {
        self.picsTitleL = ({
            UILabel *v = [[UILabel alloc] init];
            v.text = @"反馈快照：";
            v.textColor = k_COLOR_GALLERY_F;
            v;
        });
    }
    if (!self.picsDescriptionL) {
        self.picsDescriptionL = ({
            UILabel *v = [[UILabel alloc] init];
            v.text = @"可以将您遇到的问题截图给我们，以便更快速解决问题";
            v.textColor = k_COLOR_GALLERY_F;
            v.font = [UIFont systemFontOfSize:12];
            v;
        });
    }
    
    if (!self.picsV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 2;
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 10, 0);
        CGFloat picWH = ([[UIScreen mainScreen] bounds].size.width-50)/5;
        layout.itemSize = ccs(picWH, picWH);
        self.picsV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.picsV.backgroundColor = k_COLOR_CLEAR;
        [self.picsV registerClass:[FeedEditPicCell class] forCellWithReuseIdentifier:[FeedEditPicCell reuseIdentify]];
        [self.picsV withBlockForSectionNumber:^NSInteger(UICollectionView *view) {
            return 1;
        }];
        [self.picsV withBlockForItemNumber:^NSInteger(UICollectionView *view, NSInteger section) {
            _strong(self);
            if ([self.picUrlArray count] == 6) {
                return 6;
            }
            return [self.picUrlArray count]+1;
        }];
        [self.picsV withBlockForItemCell:^UICollectionViewCell *(UICollectionView *view, NSIndexPath *path) {
            _strong(self);
            FeedEditPicCell *cell = [view dequeueReusableCellWithReuseIdentifier:[FeedEditPicCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[FeedEditPicCell alloc] init];
            }
            if (path.row < [self.picUrlArray count]) {
                cell.imgUrl = self.picUrlArray[path.row];
                cell.imgV.image = self.picArray[path.row];
            }
            cell.imageDeleteBlock = ^(NSString *imgUrl, UIImage *img) {
                [self.picArray removeObject:img];
                [self.picUrlArray removeObject:imgUrl];
                [self _refreshPicView];
            };
            cell.imagePickBlock = ^(FeedEditPicCell *cell) {
                // TODO:
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
                                    [self.picUrlArray addObject:url];
                                    [self.picArray addObject:newImage];
                                    [self _refreshPicView];
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
                        EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForCameraPhotoEditable:NO];
                        SetupEYImagePicker(picker);
                    }];
                }
                
                if ([EYImagePickerViewController isLibraryPhotoAvailable]) {
                    [as addOtherButtonTitle:@"手机相册" actionBlock:^{
                        EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForLibraryPhotoEditable:NO];
                        SetupEYImagePicker(picker);
                    }];
                }
                [as showInView:self.view];
            };
            return cell;
        }];
    }
    if (!self.submitB) {
        self.submitB = ({
            UIButton *v = [UIButton buttonWithType:UIButtonTypeSystem];
            [v setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
            [v setTitle:@"立即提交" forState:UIControlStateNormal];
            [v setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
            [v addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
            v;
        });
    }
}

- (void)_layoutCodingViews {
    if (![self.contentTitleL superview]) {
        [self.view addSubview:self.contentTitleL];
        [self.contentTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.topLayoutGuide.length + 10);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
        }];
    }
    if (![self.contentTextV superview]) {
        [self.view addSubview:self.contentTextV];
        [self.contentTextV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentTitleL);
            make.top.equalTo(self.contentTitleL.mas_bottom).offset(5);
            make.height.equalTo(@100);
        }];
    }
    if (![self.picsTitleL superview]) {
        [self.view addSubview:self.picsTitleL];
        [self.picsTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentTitleL);
            make.top.equalTo(self.contentTextV.mas_bottom).offset(10);
        }];
    }
    if (![self.picsDescriptionL superview]) {
        [self.view addSubview:self.picsDescriptionL];
        [self.picsDescriptionL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.picsTitleL);
            make.top.equalTo(self.picsTitleL.mas_bottom);
        }];
    }
    if (![self.picsV superview]) {
        [self.view addSubview:self.picsV];
        [self.picsV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.picsDescriptionL.mas_bottom);
            make.left.right.equalTo(self.contentTitleL);
            CGFloat picw = ([[UIScreen mainScreen] bounds].size.width-50)/5;
            make.height.equalTo(@(picw+10));
        }];
    }
    if (![self.submitB superview]) {
        [self.view addSubview:self.submitB];
        [self.submitB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.picsV.mas_bottom);
            make.left.right.equalTo(self.contentTitleL);
        }];
    }
}

- (void)_refreshPicView {
    if ([self.picUrlArray count] < 5) {
        [self.picsV reloadData];
        return;
    }
    if ([self.picsV.visibleCells count] > 5) {
        [self.picsV reloadData];
        return;
    }
    [self.picsV reloadData];
}

- (void)_submitAction {
    if (![self.contentTextV.text length] || [self.contentTextV.text isEqualToString:kContentHint]) {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈内容"];
        return;
    }
    if (self.contentTextV.isFirstResponder) {
        [self.contentTextV becomeFirstResponder];
    }
    [SVProgressHUD showWithStatus:@"正在提交您的反馈" maskType:SVProgressHUDMaskTypeClear];
    [[UserModel sharedModel] asyncAddFeedWithContent:self.contentTextV.text imageUrls:self.picUrlArray remoteBlock:^(BOOL isSuccess, NSError *error) {
        if (error || !isSuccess) {
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"谢谢您的反馈和支持，我们会持续努力为您服务"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)_inputViewDone {
    [self.contentTextV resignFirstResponder];
}

@end
