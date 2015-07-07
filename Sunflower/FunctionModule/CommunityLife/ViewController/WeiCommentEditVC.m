//
//  WeiCommentEditVC.m
//  Sunflower
//
//  Created by makewei on 15/6/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "WeiCommentEditVC.h"
#import "EYImagePickerViewController.h"
#import "LocationChoiceVC.h"
#import "WeCommentListVC.h"

#import "CommonModel.h"
#import "CommunityLifeModel.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIImage+Common.h>

@interface WeiCommentEditPicCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView      *imgV;
@property(nonatomic,strong)UIButton         *deleteBtn;
@property(nonatomic,strong)UIButton         *pickBtn;

@property(nonatomic,strong)NSString         *imgUrl;

@property(nonatomic,copy)void(^imageDeleteBlock)(NSString *imgUrl, UIImage *img);
@property(nonatomic,copy)void(^imagePickBlock)(WeiCommentEditPicCell *cell);

+ (NSString *)reuseIdentify;

@end

@implementation WeiCommentEditPicCell

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

@interface WeiCommentEditVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;

@property(nonatomic,strong)UITextView       *contentEidtV;
@property(nonatomic,strong)UICollectionView *picsV;
@property(nonatomic,strong)UIView           *splitV;
@property(nonatomic,strong)UIButton         *locationBtn;
@property(nonatomic,strong)UIImageView         *shareV;
@property(nonatomic,strong)UIButton         *weiXinBtn;
@property(nonatomic,strong)UIButton         *qqBtn;

@property(nonatomic,strong)NSMutableArray   *picUrlArray;
@property(nonatomic,strong)NSMutableArray   *picArray;

@end

@implementation WeiCommentEditVC

- (NSString *)umengPageName {
    return @"微社区发帖";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_WeiCommentEditer_List";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.picUrlArray = [[NSMutableArray alloc] init];
    self.picArray = [[NSMutableArray alloc] init];
    self.locationName = @"";
    
    [self _setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
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
    if ([segue.identifier isEqualToString:@"Segue_WeiCommentEditer_Location"]) {
        ((LocationChoiceVC *)segue.destinationViewController).unSegueName = @"UnSegue_Location_WeiCommentEditer";
    }
    if ([segue.identifier isEqualToString:@"UnSegue_WeiCommentEditer_List"] && [sender isKindOfClass:[NSNumber class]]) {
        ((WeCommentListVC *)segue.destinationViewController).needRefresh = [((NSNumber *)sender) boolValue];
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    _weak(self);
    if (!self.contentEidtV) {
        self.contentEidtV = [[UITextView alloc] init];
        self.contentEidtV.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.contentEidtV.backgroundColor = k_COLOR_CLEAR;
        self.contentEidtV.textColor = k_COLOR_GALLERY_F;
        self.contentEidtV.font = [UIFont boldSystemFontOfSize:15];
        self.contentEidtV.textContainerInset = UIEdgeInsetsMake(15, 20, 15, 20);
        self.contentEidtV.text = @"此时此地，想说点啥~";
        [self.contentEidtV withBlockForDidBeginEditing:^(UITextView *view) {
            _strong(self);
            if ([self.contentEidtV.text isEqualToString:@"此时此地，想说点啥~"]) {
                self.contentEidtV.text = @"";
            }
        }];
        
        UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_inputViewDone)];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
        toolBar.items = @[fixItem, doneItem];
        self.contentEidtV.inputAccessoryView = toolBar;
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
        [self.picsV registerClass:[WeiCommentEditPicCell class] forCellWithReuseIdentifier:[WeiCommentEditPicCell reuseIdentify]];
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
            WeiCommentEditPicCell *cell = [view dequeueReusableCellWithReuseIdentifier:[WeiCommentEditPicCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[WeiCommentEditPicCell alloc] init];
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
            cell.imagePickBlock = ^(WeiCommentEditPicCell *cell) {
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
    
    if (!self.splitV) {
        self.splitV = [[UIView alloc] init];
        self.splitV.backgroundColor = k_COLOR_GALLERY;
    }
    
    if (!self.locationBtn) {
        self.locationBtn = [[UIButton alloc] init];
        [self.locationBtn setBackgroundImage:[UIImage imageNamed:@"cl_weicomment_location_btn"] forState:UIControlStateNormal];
        [self.locationBtn setBackgroundImage:[UIImage imageNamed:@"cl_weicomment_location_btn"] forState:UIControlStateHighlighted];
        [self.locationBtn setTitle:@"所在位置" forState:UIControlStateNormal];
        [self.locationBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [self.locationBtn setTitleColor:k_COLOR_GRAY forState:UIControlStateHighlighted];
        self.locationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.locationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
        _weak(self);
        [self.locationBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self performSegueWithIdentifier:@"Segue_WeiCommentEditer_Location" sender:nil];
        }];
        
    }
    
    if (!self.shareV) {
        self.shareV = [[UIImageView alloc] init];
        self.shareV.image = [UIImage imageNamed:@"cl_weicomment_share_btn"];
        self.shareV.userInteractionEnabled = YES;
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = @"分享";
        titleL.font = [UIFont boldSystemFontOfSize:15];
        titleL.textColor = k_COLOR_GALLERY_F;
        
        [self.shareV addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.shareV);
            make.left.equalTo(self.shareV).with.offset(50);
            make.height.equalTo(@15);
        }];
        
        self.weiXinBtn = [[UIButton alloc] init];
        [self.weiXinBtn setBackgroundImage:[UIImage imageNamed:@"share_wx_n"] forState:UIControlStateNormal];
        [self.weiXinBtn setBackgroundImage:[UIImage imageNamed:@"share_wx_s"] forState:UIControlStateHighlighted];
        [self.weiXinBtn setBackgroundImage:[UIImage imageNamed:@"share_wx_s"] forState:UIControlStateSelected];
        
        [self.weiXinBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            self.weiXinBtn.selected = !self.weiXinBtn.selected;
            [self.weiXinBtn setBackgroundImage:[UIImage imageNamed:self.weiXinBtn.selected?@"share_wx_n":@"share_wx_s"] forState:UIControlStateHighlighted];
        }];
        
        self.qqBtn = [[UIButton alloc] init];
        [self.qqBtn setBackgroundImage:[UIImage imageNamed:@"share_qq_n"] forState:UIControlStateNormal];
        [self.qqBtn setBackgroundImage:[UIImage imageNamed:@"share_qq_s"] forState:UIControlStateHighlighted];
        [self.qqBtn setBackgroundImage:[UIImage imageNamed:@"share_qq_s"] forState:UIControlStateSelected];
        
        [self.qqBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            self.qqBtn.selected = !self.qqBtn.selected;
            [self.qqBtn setBackgroundImage:[UIImage imageNamed:self.qqBtn.selected?@"share_qq_n":@"share_qq_s"] forState:UIControlStateHighlighted];
        }];
        
        [self.shareV addSubview:self.qqBtn];
        [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.shareV).with.offset(-22);
            make.centerY.equalTo(self.shareV);
            make.width.height.equalTo(@25);
        }];
        [self.shareV addSubview:self.weiXinBtn];
        [self.weiXinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.qqBtn.mas_left).with.offset(-6);
            make.centerY.equalTo(self.shareV);
            make.width.height.equalTo(@25);
        }];
    }
    
}

- (void)_layoutCodingViews {
    _weak(self);
    UIView *tmp = [[UIView alloc] init];
    tmp.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:tmp];
    [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    if (![self.contentEidtV superview]) {
        [self.contentV addSubview:self.contentEidtV];
        [self.contentEidtV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentV).with.offset(1);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@145);
        }];
    }
    
    if (![self.picsV superview]) {
        [self.contentV addSubview:self.picsV];
        [self.picsV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentEidtV.mas_bottom);
            make.left.equalTo(self.contentV).with.offset(15);
            make.right.equalTo(self.contentV).with.offset(-15);
            CGFloat picw = ([[UIScreen mainScreen] bounds].size.width-50)/5;
            make.height.equalTo(@(picw+20));
        }];
    }
    
    if (![self.splitV superview]) {
        [self.contentV addSubview:self.splitV];
        [self.splitV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.picsV.mas_bottom);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@5);
        }];
    }
    
    if (![self.locationBtn superview]) {
        [self.contentV addSubview:self.locationBtn];
        [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.splitV.mas_bottom);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@50);
        }];
    }
    
    if (![self.shareV superview]) {
        [self.contentV addSubview:self.shareV];
        [self.shareV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.locationBtn.mas_bottom);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@50);
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
    _weak(self);
    [self.picsV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentEidtV.mas_bottom);
        make.left.equalTo(self.contentV).with.offset(15);
        make.right.equalTo(self.contentV).with.offset(-15);
        CGFloat picw = ([[UIScreen mainScreen] bounds].size.width-50)/5;
        make.height.equalTo(@((picw+10)*2+20));
    }];
    [self.picsV reloadData];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"locationName" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.locationBtn setTitle:self.locationName forState:UIControlStateNormal];
    }];
}

#pragma mark - UIControl Action
- (IBAction)submitComment:(id)sender {
    _weak(self);
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.contentEidtV resignFirstResponder];
    NSString *content = [self.contentEidtV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([content isEqualToString:@"此时此地，想说点啥~"] || [MKWStringHelper isNilEmptyOrBlankString:content]) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    NSMutableString *imgStr = [@"" mutableCopy];
    for (NSString *url in self.picUrlArray) {
        [imgStr appendString:url];
        [imgStr appendString:@","];
    }
    NSString *imgs = [imgStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    
    id<ISSCAttachment> sharedImage = nil;
    id<ISSCAttachment> thumbImage = nil;
    if ([self.picArray count] > 0) {
        UIImage *shareImage = self.picArray[0];
        if(shareImage)
        {
            sharedImage = [ShareSDK pngImageWithImage:shareImage];
            thumbImage = [ShareSDK pngImageWithImage:[shareImage scaleImageWithSize:CGSizeMake(240, 240)]];
        }
    }
    if ([self.qqBtn isSelected]) {
        id<ISSContent> retVal = [ShareSDK content:content
                                   defaultContent:@""
                                            image:sharedImage
                                            title:content
                                              url:@"www.isunflowet.net.cn"          //必须填写
                                      description:nil
                                        mediaType:SSPublishContentMediaTypeText];

        [retVal addQQSpaceUnitWithTitle:content
                                    url:INHERIT_VALUE
                                           site:nil
                                        fromUrl:nil
                                        comment:INHERIT_VALUE
                                        summary:INHERIT_VALUE
                                          image:INHERIT_VALUE
                                           type:INHERIT_VALUE
                                        playUrl:nil
                                           nswb:nil];
        _weak(self);
        [ShareSDK shareContent:retVal type:ShareTypeQQSpace authOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            _strong(self);
            NSString *title;
            NSString *msg;
            NSString *cancelTitle;
            if (state == SSResponseStateSuccess) {
                title = @"分享成功";
                msg = @"QQ空间分享成功";
                cancelTitle = self.weiXinBtn.isSelected?@"继续分享到微信":@"好的";
                GCAlertView *alert = [[GCAlertView alloc] initWithTitle:title andMessage:msg];
                [alert setCancelButtonWithTitle:cancelTitle actionBlock:^{
                    _strong(self);
                    if ([self.weiXinBtn isSelected]) {
                        id<ISSContent> retVal = [ShareSDK content:content
                                                   defaultContent:content
                                                            image:sharedImage
                                                            title:content
                                                              url:nil          //必须填写
                                                      description:content
                                                        mediaType:sharedImage?SSPublishContentMediaTypeImage:SSPublishContentMediaTypeText];
                        [retVal addWeixinTimelineUnitWithType:INHERIT_VALUE
                                                      content:INHERIT_VALUE
                                                        title:INHERIT_VALUE
                                                          url:INHERIT_VALUE
                                                   thumbImage:thumbImage
                                                        image:INHERIT_VALUE
                                                 musicFileUrl:INHERIT_VALUE
                                                      extInfo:INHERIT_VALUE
                                                     fileData:INHERIT_VALUE
                                                 emoticonData:INHERIT_VALUE];
                        [ShareSDK shareContent:retVal type:ShareTypeWeixiTimeline authOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        }];
                    }
                }];
                [alert show];
                
            }
            else if (state == SSResponseStateFail) {
                title = @"分享失败";
                msg = @"QQ空间分享失败";
                cancelTitle = self.weiXinBtn.isSelected?@"继续分享到微信":@"好的";
                GCAlertView *alert = [[GCAlertView alloc] initWithTitle:title andMessage:msg];
                [alert setCancelButtonWithTitle:cancelTitle actionBlock:^{
                    _strong(self);
                    if ([self.weiXinBtn isSelected]) {
                        id<ISSContent> retVal = [ShareSDK content:content
                                                   defaultContent:content
                                                            image:sharedImage
                                                            title:content
                                                              url:nil
                                                      description:content
                                                        mediaType:sharedImage?SSPublishContentMediaTypeImage:SSPublishContentMediaTypeText];
                        [retVal addWeixinTimelineUnitWithType:INHERIT_VALUE
                                                      content:INHERIT_VALUE
                                                        title:INHERIT_VALUE
                                                          url:INHERIT_VALUE
                                                   thumbImage:thumbImage
                                                        image:INHERIT_VALUE
                                                 musicFileUrl:INHERIT_VALUE
                                                      extInfo:INHERIT_VALUE
                                                     fileData:INHERIT_VALUE
                                                 emoticonData:INHERIT_VALUE];
                        [ShareSDK shareContent:retVal type:ShareTypeWeixiTimeline authOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        }];
                    }
                }];
                [alert show];
            }
            
            

        }];
        
    }
    else if (self.weiXinBtn.isSelected) {
        id<ISSContent> retVal = [ShareSDK content:content
                                   defaultContent:content
                                            image:sharedImage
                                            title:content
                                              url:nil
                                      description:content
                                        mediaType:sharedImage?SSPublishContentMediaTypeImage:SSPublishContentMediaTypeText];
        [retVal addWeixinTimelineUnitWithType:INHERIT_VALUE
                                      content:INHERIT_VALUE
                                        title:INHERIT_VALUE
                                          url:INHERIT_VALUE
                                   thumbImage:thumbImage
                                        image:INHERIT_VALUE
                                 musicFileUrl:INHERIT_VALUE
                                      extInfo:INHERIT_VALUE
                                     fileData:INHERIT_VALUE
                                 emoticonData:INHERIT_VALUE];
        [ShareSDK shareContent:retVal type:ShareTypeWeixiTimeline authOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        }];
    }
    
    [[CommunityLifeModel sharedModel] asyncWeiAddWithCommuntiyId:[CommonModel sharedModel].currentCommunityId parentId:@0 content:self.contentEidtV.text images:imgs address:self.locationName remoteBlock:^(BOOL isSuccess, NSError *error){
        _strong(self);
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
            [UserPointHandler addUserPointWithType:WeiCommentAdd showInfo:YES];
            [self performSegueWithIdentifier:@"UnSegue_WeiCommentEditer_List" sender:@(YES)];
            return;
        }
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)_inputViewDone {
    [self.contentEidtV resignFirstResponder];
}

@end