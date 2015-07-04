//
//  PropertyFixVC.m
//  Sunflower
//
//  Created by makewei on 15/5/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyFixVC.h"
#import "EYImagePickerViewController.h"

#import "MKWTextField.h"

#import "PropertyServiceModel.h"
#import "UserModel.h"
#import "CommonModel.h"
#import "Community.h"
#import "WeiCommentCell.h"
#import "PictureShowVC.h"


#pragma mark - FixEditPicCell
@interface FixEditPicCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView      *imgV;
@property(nonatomic,strong)UIButton         *deleteBtn;
@property(nonatomic,strong)UIButton         *pickBtn;

@property(nonatomic,strong)NSString         *imgUrl;

@property(nonatomic,copy)void(^imageDeleteBlock)(NSString *imgUrl, UIImage *img);
@property(nonatomic,copy)void(^imagePickBlock)(FixEditPicCell *cell);

+ (NSString *)reuseIdentify;

@end

@implementation FixEditPicCell

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
    return @"FixEditPicCellIdentify";
}

@end

#pragma mark - FixTelCell
@interface FixTelCell : UITableViewCell

@property(nonatomic,copy)void(^callBlock)();

+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelf;
@end

@implementation FixTelCell

+ (NSString *)reuseIdentify {
    return @"FixTelCellIdentify";
}
+ (CGFloat)heightOfSelf {
    return 380/2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = k_COLOR_GRAY_BG;
        
        _weak(self);
        UIButton *callBtn = [[UIButton alloc] init];
        [callBtn setBackgroundImage:[UIImage imageNamed:@"fix_call_btn"] forState:UIControlStateNormal];
        [callBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.callBlock);
        }];
        
        [self.contentView addSubview:callBtn];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.width.height.equalTo(@153);
        }];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = k_COLOR_BLUE;
        titleL.text = @"物业维修服务电话";
        titleL.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:titleL];
        _weak(callBtn);
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(callBtn);
            make.top.equalTo(callBtn).with.offset(48);
            make.left.equalTo(callBtn.mas_right);
            make.height.equalTo(@17);
            make.right.equalTo(self.contentView).with.offset(-27);
        }];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = k_COLOR_GALLERY_F;
        [self.contentView addSubview:lineV];
        _weak(titleL);
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(titleL);
            _strong(callBtn);
            make.top.equalTo(titleL.mas_bottom).with.offset(9);
            make.left.equalTo(callBtn.mas_right);
            make.width.equalTo(@1);
            make.height.equalTo(@27);
        }];
        
        UILabel *subL1 = [[UILabel alloc] init];
        subL1.textColor = k_COLOR_GALLERY_F;
        subL1.font = [UIFont boldSystemFontOfSize:12];
        subL1.text = @"如果需要维修服务，";
        [self.contentView addSubview:subL1];
        _weak(lineV);
        [subL1 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(lineV);
            _strong(self);
            make.top.equalTo(lineV);
            make.left.equalTo(lineV.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-27);
            make.height.equalTo(@12);
        }];
        
        UILabel *subL2 = [[UILabel alloc] init];
        subL2.textColor = k_COLOR_GALLERY_F;
        subL2.font = [UIFont boldSystemFontOfSize:12];
        subL2.text = @"请点击“一键呼叫”与我们取得联系";
        [self.contentView addSubview:subL2];
        _weak(subL1);
        [subL2 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(subL1);
            _strong(self);
            make.top.equalTo(subL1.mas_bottom).with.offset(3);
            make.left.equalTo(lineV.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-27);
            make.height.equalTo(@12);
        }];
    }
    return self;
}
@end


#pragma mark - FixTelEditCell
@interface FixTelEditCell : UITableViewCell

@property(nonatomic,strong)MKWTextField *telT;
@property(nonatomic,strong)UILabel      *telL;
@property(nonatomic,strong)UIButton     *saveBtn;
@property(nonatomic,strong)UIButton     *editBtn;

+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelf;
@end

@implementation FixTelEditCell

+ (NSString *)reuseIdentify {
    return @"FixTelEditCellIdentify";
}
+ (CGFloat)heightOfSelf {
    return 666/2;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = k_COLOR_GRAY_BG;
        
        _weak(self);
        UIImageView *callBtn = [[UIImageView alloc] init];
        callBtn.image = [UIImage imageNamed:@"fix_call_btn"];
        
        [self.contentView addSubview:callBtn];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(20);
            make.left.equalTo(self.contentView);
            make.width.height.equalTo(@153);
        }];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = k_COLOR_BLUE;
        titleL.text = @"物业维修服务电话";
        titleL.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:titleL];
        _weak(callBtn);
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(callBtn);
            make.top.equalTo(callBtn).with.offset(48);
            make.left.equalTo(callBtn.mas_right);
            make.height.equalTo(@17);
            make.right.equalTo(self.contentView).with.offset(-27);
        }];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = k_COLOR_GALLERY_F;
        [self.contentView addSubview:lineV];
        _weak(titleL);
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(titleL);
            _strong(callBtn);
            make.top.equalTo(titleL.mas_bottom).with.offset(9);
            make.left.equalTo(callBtn.mas_right);
            make.width.equalTo(@1);
            make.height.equalTo(@27);
        }];
        
        UILabel *subL1 = [[UILabel alloc] init];
        subL1.textColor = k_COLOR_GALLERY_F;
        subL1.font = [UIFont boldSystemFontOfSize:12];
        subL1.text = @"如果需要维修服务，";
        [self.contentView addSubview:subL1];
        _weak(lineV);
        [subL1 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(lineV);
            _strong(self);
            make.top.equalTo(lineV);
            make.left.equalTo(lineV.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-27);
            make.height.equalTo(@12);
        }];
        
        UILabel *subL2 = [[UILabel alloc] init];
        subL2.textColor = k_COLOR_GALLERY_F;
        subL2.font = [UIFont boldSystemFontOfSize:12];
        subL2.text = @"请点击“一键呼叫”与我们取得联系";
        [self.contentView addSubview:subL2];
        _weak(subL1);
        [subL2 mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(subL1);
            _strong(self);
            make.top.equalTo(subL1.mas_bottom).with.offset(3);
            make.left.equalTo(lineV.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-27);
            make.height.equalTo(@12);
        }];
        
        UIView *splitV = [[UIView alloc] init];
        splitV.backgroundColor = RGB(217, 217, 217);
        [self.contentView addSubview:splitV];
        [splitV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(180);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        UILabel *editTitleL = [[UILabel alloc] init];
        editTitleL.font = [UIFont boldSystemFontOfSize:14];
        editTitleL.textColor = k_COLOR_GALLERY_F;
        editTitleL.text = @"维修保养电话";
        [self.contentView addSubview:editTitleL];
        _weak(splitV);
        [editTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(splitV);
            make.top.equalTo(splitV.mas_bottom).with.offset(20);
            make.left.equalTo(self.contentView).with.offset(27);
            make.height.equalTo(@14);
            make.right.equalTo(self.contentView).with.offset(-27);
        }];
        
        self.telT = [[MKWTextField alloc] init];
        self.telT.textEdgeInset = UIEdgeInsetsMake(7, 15, 8, 30);
        self.telT.backgroundColor =  k_COLOR_WHITE;
        self.telT.background = [UIImage imageNamed:@"edit_filed_bg"];
        self.telT.layer.cornerRadius = 3;
        self.telT.text = [CommonModel sharedModel].currentCommunity.tel;
        self.telT.font = [UIFont boldSystemFontOfSize:15];
        self.telT.textColor = k_COLOR_GALLERY_F;
        UIButton *clearBtn =[[UIButton alloc] init];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"edit_clear_btn"] forState:UIControlStateNormal];
        [clearBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            self.telT.text = @"";
        }];
        clearBtn.frame = CGRectMake(0, 0, 30, 30);
        self.telT.rightView = clearBtn;
        self.telT.rightViewMode = UITextFieldViewModeAlways;
        [self.contentView addSubview:self.telT];
        _weak(editTitleL);
        [self.telT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(editTitleL);
            make.top.equalTo(editTitleL.mas_bottom).with.offset(11);
            make.left.equalTo(editTitleL);
            make.right.equalTo(editTitleL);
            make.height.equalTo(@30);
        }];
        [self.telT setHidden:YES];
        
        self.telL = [[UILabel alloc] init];
        self.telL.textColor = k_COLOR_GALLERY_F;
        self.telL.font = [UIFont boldSystemFontOfSize:15];
        self.telL.text = [CommonModel sharedModel].currentCommunity.tel;
        [self.contentView addSubview:self.telL];
        [self.telL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(editTitleL);
            make.top.equalTo(editTitleL.mas_bottom).with.offset(11);
            make.left.equalTo(editTitleL);
            make.right.equalTo(editTitleL);
            make.height.equalTo(@30);
        }];
        
        self.saveBtn = [[UIButton alloc] init];
        self.saveBtn.backgroundColor = k_COLOR_BLUE;
        self.saveBtn.layer.cornerRadius = 4;
        self.saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [self.saveBtn setTitleColor:k_COLOR_GRAY forState:UIControlStateHighlighted];
        [self.saveBtn setTitleColor:k_COLOR_GRAY forState:UIControlStateDisabled];
        [self.saveBtn setEnabled:NO];
        [self.saveBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            CommunityInfo *c = [CommonModel sharedModel].currentCommunity;
            [[PropertyServiceModel sharedModel] asyncUpdateCommunityInfoWithCommunityID:c.communityId name:c.name detail:c.communityDesc image:c.images tel:self.telT.text remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                _strong(self);
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    self.telL.text = [CommonModel sharedModel].currentCommunity.tel;
                    self.telT.text = [CommonModel sharedModel].currentCommunity.tel;
                    [self.contentView bringSubviewToFront:self.telL];
                    [self.telL setHidden:NO];
                    [self.telT setHidden:YES];
                    [self.saveBtn setEnabled:NO];
                    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                }
            }];
        }];
        
        [self.contentView addSubview:self.saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(editTitleL);
            make.top.equalTo(editTitleL.mas_bottom).with.offset(58);
            make.right.equalTo(editTitleL);
            make.left.equalTo(self.contentView.mas_centerX).with.offset(5);
            make.height.equalTo(@43);
        }];
        
        self.editBtn = [[UIButton alloc] init];
        self.editBtn.backgroundColor = k_COLOR_RED;
        self.editBtn.layer.cornerRadius = 4;
        self.editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [self.editBtn setTitleColor:k_COLOR_GRAY_BG forState:UIControlStateHighlighted];
        [self.editBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if (self.telT.isHidden) {
                [self.telT setHidden:NO];
                [self.telL setHidden:YES];
                self.telT.text = [CommonModel sharedModel].currentCommunity.tel;
                [self.contentView bringSubviewToFront:self.telT];
                [self.editBtn setTitle:@"取消" forState:UIControlStateNormal];
                [self.saveBtn setEnabled:YES];
            }
            else
            {
                [self.telT setHidden:YES];
                [self.telL setHidden:NO];
                [self.contentView bringSubviewToFront:self.telL];
                [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                [self.saveBtn setEnabled:NO];
            }
        }];
        [self.contentView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(editTitleL);
            make.top.equalTo(editTitleL.mas_bottom).with.offset(58);
            make.left.equalTo(editTitleL);
            make.right.equalTo(self.contentView.mas_centerX).with.offset(-5);
            make.height.equalTo(@43);
        }];
    }
    return self;
}
@end

#pragma mark - FixIssueEditCell

@interface FixIssueEditCell : UITableViewCell

@property(nonatomic,strong)UIButton     *feedBackBtn;
@property(nonatomic,strong)UIButton     *fixBtn;
@property(nonatomic,strong)MKWTextField *nameT;
@property(nonatomic,strong)MKWTextField *telT;
@property(nonatomic,strong)MKWTextField *addT;
@property(nonatomic,strong)UITextView   *contentT;
@property(nonatomic,strong)UICollectionView *picsV;
@property(nonatomic,weak)UIView         *focusedT;

@property(nonatomic,weak)UIViewController *vc;

@property(nonatomic,strong)NSMutableArray      *picUrlArray;
@property(nonatomic,strong)NSMutableArray      *picArray;

+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelf;
@end

@implementation FixIssueEditCell

+ (NSString *)reuseIdentify {
    return @"FixIssueEditCellIdentify";
}
+ (CGFloat)heightOfSelf {
    return 930/2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.picArray = [@[] mutableCopy];
        self.picUrlArray = [@[] mutableCopy];
        _weak(self);
        UILabel *(^titleLabelBlock)(NSString *txt) = ^(NSString *txt){
            UILabel *l = [[UILabel alloc] init];
            l.font = [UIFont boldSystemFontOfSize:14];
            l.textColor = k_COLOR_GALLERY_F;
            l.text = txt;
            return l;
        };
        
        MKWTextField *(^textFiledBlock)(NSString *txt) = ^(NSString *txt){
            MKWTextField *t = [[MKWTextField alloc] init];
            t.background = [UIImage imageNamed:@"edit_filed_bg"];
            t.font = [UIFont boldSystemFontOfSize:14];
            t.textColor = k_COLOR_GALLERY_F;
            t.textEdgeInset = UIEdgeInsetsMake(8, 15, 0, 15);
            t.text = txt;
            [t withBlockForDidBeginEditing:^(UITextField *view) {
                _strong(self);
                self.focusedT = view;
            }];
            [t withBlockForShouldReturn:^BOOL(UITextField *view) {
                [self resignFirstResponder];
                self.focusedT = nil;
                return YES;
            }];
            return t;
        };
        
        
        UILabel *typeL = titleLabelBlock(@"类型:");
        [self.contentView addSubview:typeL];
        [typeL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(27);
            make.width.equalTo(@57);
            make.height.equalTo(@44);
        }];
        
        self.feedBackBtn = [[UIButton alloc] init];
        [self.feedBackBtn setImage:[UIImage imageNamed:@"rent_edit_choose"] forState:UIControlStateNormal];
        [self.feedBackBtn setImage:[UIImage imageNamed:@"rent_edit_choose_h"] forState:UIControlStateHighlighted];
        [self.feedBackBtn setImage:[UIImage imageNamed:@"rent_edit_choose_h"] forState:UIControlStateSelected];
        self.feedBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.feedBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.feedBackBtn setTitle:@"意见反馈" forState:UIControlStateNormal];
        [self.feedBackBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [self.feedBackBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        self.feedBackBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.feedBackBtn setSelected:YES];
        [self.feedBackBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if ([self.feedBackBtn isSelected]) {
                return;
            }
            
            [self.feedBackBtn setSelected:YES];
            [self.fixBtn setSelected:NO];
        }];
        _weak(typeL);
        [self.contentView addSubview:self.feedBackBtn];
        [self.feedBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(typeL);
            make.top.equalTo(self.contentView);
            make.left.equalTo(typeL.mas_right);
            make.width.equalTo(@89);
            make.height.equalTo(typeL);
        }];
        
        self.fixBtn = [[UIButton alloc] init];
        [self.fixBtn setImage:[UIImage imageNamed:@"rent_edit_choose"] forState:UIControlStateNormal];
        [self.fixBtn setImage:[UIImage imageNamed:@"rent_edit_choose_h"] forState:UIControlStateHighlighted];
        [self.fixBtn setImage:[UIImage imageNamed:@"rent_edit_choose_h"] forState:UIControlStateSelected];
        self.fixBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.fixBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.fixBtn setTitle:@"日常保修" forState:UIControlStateNormal];
        [self.fixBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [self.fixBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        self.fixBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.fixBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            if ([self.fixBtn isSelected]) {
                return;
            }
            
            [self.fixBtn setSelected:YES];
            [self.feedBackBtn setSelected:NO];
        }];
        [self.contentView addSubview:self.fixBtn];
        [self.fixBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(typeL);
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.feedBackBtn.mas_right).with.offset(10);
            make.width.equalTo(@89);
            make.height.equalTo(typeL);
        }];
        
        UILabel *nameL = titleLabelBlock(@"姓名:");
        [self.contentView addSubview:nameL];
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(typeL);
            make.top.equalTo(self.feedBackBtn.mas_bottom).with.offset(4);
            make.left.right.height.equalTo(typeL);
        }];
        self.nameT = textFiledBlock(@"");
        _weak(nameL);
        [self.contentView addSubview:self.nameT];
        [self.nameT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(nameL);
            make.top.equalTo(nameL);
            make.left.equalTo(nameL.mas_right);
            make.right.equalTo(self.contentView).with.offset(-27);
            make.height.equalTo(nameL);
        }];
        UILabel *telL = titleLabelBlock(@"手机:");
        [self.contentView addSubview:telL];
        [telL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(typeL);
            make.top.equalTo(self.nameT.mas_bottom).with.offset(4);
            make.left.right.height.equalTo(typeL);
        }];
        self.telT = textFiledBlock(@"");
        [self.contentView addSubview:self.telT];
        _weak(telL);
        [self.telT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(telL);
            make.top.bottom.equalTo(telL);
            make.left.right.equalTo(self.nameT);
        }];
        UILabel *addL = titleLabelBlock(@"地址:");
        [self.contentView addSubview:addL];
        [addL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(typeL);
            make.top.equalTo(self.telT.mas_bottom).with.offset(4);
            make.left.right.height.equalTo(typeL);
        }];
        self.addT = textFiledBlock(@"");
        [self.contentView addSubview:self.addT];
        _weak(addL);
        [self.addT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(addL);
            make.top.bottom.equalTo(addL);
            make.left.right.equalTo(self.nameT);
        }];
        UILabel *contentL = titleLabelBlock(@"反馈内容:");
        [self.contentView addSubview:contentL];
        [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(typeL);
            make.left.equalTo(typeL);
            make.top.equalTo(self.addT.mas_bottom).with.offset(4);
            make.right.equalTo(self.nameT);
            make.height.equalTo(@34);
        }];
        self.contentT = [[UITextView alloc] init];
        self.contentT.layer.borderColor = [RGB(97, 97, 97) CGColor];
        self.contentT.layer.borderWidth = 1;
        self.contentT.layer.cornerRadius = 3;
        self.contentT.textColor = k_COLOR_GALLERY_F;
        self.contentT.font = [UIFont boldSystemFontOfSize:14];
        self.contentT.textContainerInset = UIEdgeInsetsMake(8, 15, 8, 15);
        [self.contentT withBlockForDidBeginEditing:^(UITextView *view) {
            _strong(self);
            self.focusedT = view;
        }];
        [self.contentView addSubview:self.contentT];
        _weak(contentL);
        [self.contentT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(typeL);
            _strong(contentL);
            make.left.equalTo(typeL);
            make.top.equalTo(contentL.mas_bottom).with.offset(4);
            make.right.equalTo(self.nameT);
            make.height.equalTo(@80);
        }];
        
        UILabel *picL = titleLabelBlock(@"问题快照:");
        [self.contentView addSubview:picL];
        [picL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(typeL);
            make.left.equalTo(typeL);
            make.top.equalTo(self.contentT.mas_bottom).with.offset(13);
            make.height.equalTo(@14);
            make.width.equalTo(@78);
        }];
        UILabel *picsubL = titleLabelBlock(@"可以将您遇到的问题拍照给我们，以便更快速解决问题");
        picsubL.font = [UIFont boldSystemFontOfSize:11];
        [self.contentView addSubview:picsubL];
        _weak(picL);
        [picsubL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(picL);
            make.bottom.equalTo(picL);
            make.left.equalTo(picL.mas_right);
            make.right.equalTo(self.nameT);
            make.height.equalTo(@11);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 2;
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 10, 0);
        CGFloat picWH = ([[UIScreen mainScreen] bounds].size.width-50)/5;
        layout.itemSize = ccs(picWH, picWH);
        self.picsV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.picsV.backgroundColor = k_COLOR_CLEAR;
        [self.picsV registerClass:[FixEditPicCell class] forCellWithReuseIdentifier:[FixEditPicCell reuseIdentify]];
        self.picsV.scrollEnabled = NO;
        self.picsV.showsHorizontalScrollIndicator = NO;
        self.picsV.showsVerticalScrollIndicator = NO;
        [self.picsV withBlockForSectionNumber:^NSInteger(UICollectionView *view) {
            return 1;
        }];
        [self.picsV withBlockForItemNumber:^NSInteger(UICollectionView *view, NSInteger section) {
            _strong(self);
            if ([self.picUrlArray count] == 5) {
                return 5;
            }
            return [self.picUrlArray count]+1;
        }];
        [self.picsV withBlockForItemCell:^UICollectionViewCell *(UICollectionView *view, NSIndexPath *path) {
            _strong(self);
            FixEditPicCell *cell = [view dequeueReusableCellWithReuseIdentifier:[FixEditPicCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[FixEditPicCell alloc] init];
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
            cell.imagePickBlock = ^(FixEditPicCell *cell) {
                void (^SetupEYImagePicker)(EYImagePickerViewController* picker) =
                ^(EYImagePickerViewController* picker) {
                    _strong(self);
                    picker.dismissBlock = ^(NSDictionary* userInfo) {
                        _strong(self);
                        [self.vc dismissViewControllerAnimated:YES completion:nil];
                    };
                    [picker withBlockForDidFinishPickingMediaUsingFilePath:^(EYImagePickerViewController *picker, UIImage *thumbnail, NSString *filePath) {
                        _strong(self);
                        [self.vc dismissViewControllerAnimated:NO completion:^{
                            [SVProgressHUD showWithStatus:@"正在上传图片" maskType:SVProgressHUDMaskTypeClear];
                            UIImage *newImage = [thumbnail adjustedToStandardSize];
                            [[CommonModel sharedModel] uploadImage:newImage path:filePath progress:nil remoteBlock:^(NSString *url, NSError *error) {
                                _strong(self);
                                if (!error) {
                                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                    [self.picUrlArray addObject:url];
                                    [self.picArray addObject:thumbnail];
                                    [self _refreshPicView];
                                }
                                else {
                                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
                                }
                            }];
                            
                        }];
                    }];
                    [self.vc presentViewController:picker animated:YES completion:nil];
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
                [as showInView:self.vc.view];
            };
            return cell;
        }];
        [self.contentView addSubview:self.picsV];
        [self.picsV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(picL);
            make.top.equalTo(picL.mas_bottom).with.offset(4);
            make.left.equalTo(picL);
            make.right.equalTo(self.nameT);
            make.height.equalTo(@72);
        }];
        
        UIButton *submitBtn = [[UIButton alloc] init];
        submitBtn.backgroundColor = k_COLOR_BLUE;
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [submitBtn setTitle:@"立即提交" forState:UIControlStateNormal];
        [submitBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [submitBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
        submitBtn.layer.cornerRadius = 4;
        [submitBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            NSString *name = [MKWStringHelper trimWithStr:self.nameT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:name]) {
                [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
                return;
            }
            NSString *phone = [MKWStringHelper trimWithStr:self.telT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:phone]) {
                [SVProgressHUD showErrorWithStatus:@"请输入电话号码"];
                return;
            }
            NSString *address = [MKWStringHelper trimWithStr:self.addT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:address]) {
                [SVProgressHUD showErrorWithStatus:@"请输入地址"];
                return;
            }
            NSString *content = [MKWStringHelper trimWithStr:self.contentT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:content]) {
                [SVProgressHUD showErrorWithStatus:@"请输入内容"];
                return;
            }
            NSMutableString *images = [@"" mutableCopy];
            for (NSString *url in self.picUrlArray) {
                [images appendFormat:@"%@,", url];
            }
            NSString *imagesSubmit = [images stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            [[PropertyServiceModel sharedModel] asyncAddFixIssueWithCommunityId:[CommonModel sharedModel].currentCommunityId type:(self.feedBackBtn.isSelected?@(1):@(2)) name:name tel:phone add:address content:content images:imagesSubmit remoteBlock:^(BOOL isSuccess, NSError *error) {
                if (!isSuccess) {
                    [SVProgressHUD showErrorWithStatus:error.domain];
                    return;
                }
                [UserPointHandler addUserPointWithType:FixAdd showInfo:NO];
                [SVProgressHUD showSuccessWithStatus:@"提交成功,可到个人中心查看"];
                [self _cleanContent];
            }];
        }];
        
        [self.contentView addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.picsV.mas_bottom).with.offset(5);
            make.left.right.equalTo(self.picsV);
            make.height.equalTo(@43);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
            if (self.focusedT && [self.focusedT isFirstResponder]) {
                [self.focusedT resignFirstResponder];
            }
            
            return NO;
        }];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)_refreshPicView {
    if ([self.picUrlArray count] < 5) {
        [self.picsV reloadData];
        return;
    }
}

- (void)_cleanContent {
    [self.feedBackBtn setSelected:YES];
    [self.fixBtn setSelected:NO];
    self.contentT.text = @"";
    [self.picUrlArray removeAllObjects];
    [self.picArray removeAllObjects];
    [self.picsV reloadData];
}
@end

#pragma mark - FixIssueCell

@interface FixIssueCell : UITableViewCell

@property(nonatomic,strong)UIView       *contentV;
@property(nonatomic,strong)UILabel      *infoL;
@property(nonatomic,strong)UILabel      *timeL;
@property(nonatomic,strong)UICollectionView *picsV;

@property(nonatomic,strong)FixIssueInfo *fixIssue;
@property(nonatomic,strong)NSArray      *picUrlVArray;
@property(nonatomic,copy)void(^actionBlock)(FixIssueCell *cell);
@property(nonatomic,copy)void(^picShowBlock)(NSArray *picUrlArray, NSInteger index);

+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelf;
@end

@implementation FixIssueCell

+ (NSString *)reuseIdentify {
    return @"FixIssueCellIdentify";
}
+ (CGFloat)heightOfSelf {
    return 370/2;
}

+ (CGFloat)_picHeightWithScreenWidth:(CGFloat)width {
    CGFloat totalwidth = width - 110;
    return totalwidth / 3;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _weak(self);
        self.contentV = [[UIView alloc] init];
        self.contentV.layer.borderColor = [RGB(176, 176, 176) CGColor];
        self.contentV.layer.borderWidth = 1;
        [self.contentView addSubview:self.contentV];
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(5);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(20);
            make.right.equalTo(self.contentView).with.offset(-20);
        }];
        
        self.infoL = [[UILabel alloc] init];
        self.infoL.numberOfLines = 0;
        [self.contentV addSubview:self.infoL];
        
        UIButton *actionBtn = [[UIButton alloc] init];
        [actionBtn setBackgroundImage:[UIImage imageNamed:@"cl_weicomment_action_btn"] forState:UIControlStateNormal];
        [actionBtn setBackgroundImage:[UIImage imageNamed:@"cl_weicomment_action_btn"] forState:UIControlStateHighlighted];
        [actionBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.actionBlock, self);
        }];
        
        [self.contentV addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentV).with.offset(5);
            make.right.equalTo(self.contentV);
            make.width.equalTo(@34);
            make.height.equalTo(@19);
        }];
        
        self.timeL = [[UILabel alloc] init];
        self.timeL.textColor = RGB(176, 176, 176);
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.font = [UIFont boldSystemFontOfSize:12];
        [self.contentV addSubview:self.timeL];
        _weak(actionBtn);
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(actionBtn);
            make.top.bottom.equalTo(actionBtn);
            make.right.equalTo(actionBtn.mas_left).with.offset(2);
            make.width.equalTo(@100);
        }];
        
        UICollectionViewFlowLayout *picLayout = [[UICollectionViewFlowLayout alloc] init];
        picLayout.minimumLineSpacing = 5;
        picLayout.minimumInteritemSpacing = 5;
        picLayout.headerReferenceSize = ccs(0, 0);
        picLayout.footerReferenceSize = ccs(0, 0);
        picLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat picWH = [[self class] _picHeightWithScreenWidth:[[UIScreen mainScreen] bounds].size.width];
        picLayout.itemSize = ccs(picWH, picWH);
        self.picsV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:picLayout];
        [self.picsV registerClass:[WeiCommentPicCell class] forCellWithReuseIdentifier:[WeiCommentPicCell reuseIdentify]];
        self.picsV.showsHorizontalScrollIndicator = NO;
        self.picsV.showsVerticalScrollIndicator = NO;
        [self.picsV setScrollEnabled:NO];
        self.picsV.backgroundColor = k_COLOR_WHITE;
        
        [self.picsV withBlockForSectionNumber:^NSInteger(UICollectionView *view) {
            return 1;
        }];
        [self.picsV withBlockForItemNumber:^NSInteger(UICollectionView *view, NSInteger section) {
            _strong(self);
            return [self.picUrlVArray count];
        }];
        [self.picsV withBlockForItemCell:^UICollectionViewCell *(UICollectionView *view, NSIndexPath *path) {
            _strong(self);
            WeiCommentPicCell *cell = [view dequeueReusableCellWithReuseIdentifier:[WeiCommentPicCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[WeiCommentPicCell alloc] init];
            }
            _weak(cell);
            [cell.imgV setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.picUrlVArray[path.row]]] placeholderImage:[UIImage imageNamed:@"default_placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                _strong(cell);
                cell.imgV.contentMode = UIViewContentModeScaleToFill;
                cell.imgV.image = image;
            } failure:nil];
            
            return cell;
        }];
        [self.picsV withBlockForItemDidSelect:^(UICollectionView *view, NSIndexPath *path) {
            _strong(self);
            GCBlockInvoke(self.picShowBlock, self.picUrlVArray, path.item);
        }];
        [self.contentV addSubview:self.picsV];
        
        [self _setupObserver];
        
    }
    return self;
}

+ (CGFloat)heightWithIssue:(FixIssueInfo *)issue screenWidth:(CGFloat)width {
    
    NSInteger picRowNumber = [FixIssueCell _picRowNumberWithIssue:issue];
    CGFloat picHeight = [FixIssueCell _picHeightWithScreenWidth:width];
    NSInteger retHeight = (NSInteger)(picRowNumber==0?0:picRowNumber*(5+picHeight)+15)+25+[FixIssueCell _contentHeightWithIssue:issue screenWidth:width] +1;
    return retHeight;
}

+ (CGFloat)_contentHeightWithIssue:(FixIssueInfo *)issue screenWidth:(CGFloat)width {
    NSAttributedString *contentStr = [FixIssueCell _contentAttributeStringWithIssue:issue];
    CGRect contentRect = [contentStr boundingRectWithSize:ccs(width-70, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return contentRect.size.height;
}

+ (NSInteger)_picRowNumberWithIssue:(FixIssueInfo *)issue {
    if ([MKWStringHelper isNilEmptyOrBlankString:issue.images]) {
        return 0;
    }
    NSArray *images = [FixIssueCell _picUrlArrayWithIssue:issue];
    if ([images count] <= 0) {
        return 0;
    }
    
    NSInteger columCount = 3;
    NSUInteger imageCount = [images count];
    NSInteger rowCount = 1;
    while (imageCount > columCount) {
        rowCount += 1;
        imageCount -= 3;
    }
    return rowCount;
}

+ (NSArray*)_picUrlArrayWithIssue:(FixIssueInfo *)issue {
    return [[MKWStringHelper trimWithStr:issue.images] componentsSeparatedByString:@","];
}

+ (NSAttributedString *)_contentAttributeStringWithIssue:(FixIssueInfo *)issue {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = NSTextAlignmentLeft;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.lineHeightMultiple = 1;
    NSDictionary *att = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps};
    NSMutableString *infoStr = [@"" mutableCopy];
    [infoStr appendFormat:@"姓名：%@\n",issue.userName];
    [infoStr appendFormat:@"手机：%@\n",issue.userPhone];
    [infoStr appendFormat:@"地址：%@\n",issue.address];
    [infoStr appendFormat:@"描述：%@",issue.content];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:infoStr attributes:att];
    return str;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"fixIssue" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        self.infoL.attributedText = [[self class] _contentAttributeStringWithIssue:self.fixIssue];
        [self.infoL mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentV).with.offset(10);
            make.left.equalTo(self.contentV).with.offset(15);
            make.right.equalTo(self.contentV).with.offset(-15);
            make.height.equalTo(@((int)[[self class] _contentHeightWithIssue:self.fixIssue screenWidth:V_W_(self)]+1));
        }];
        
        self.picUrlVArray = [[self class] _picUrlArrayWithIssue:self.fixIssue];
        [self.picsV reloadData];
        [self.picsV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.infoL.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentV).with.offset(50);
            make.right.equalTo(self.contentV).with.offset(-10);
            NSInteger picRowNumber = [FixIssueCell _picRowNumberWithIssue:self.fixIssue];
            CGFloat picHeight = [FixIssueCell _picHeightWithScreenWidth:V_W_(self)];
            NSInteger retHeight = (NSInteger)(picRowNumber==0?0:picRowNumber*(5+picHeight)+15);
            make.height.equalTo(@(retHeight));
        }];
        
    }];
}

@end

#pragma mark - FixOtherSuggestCell

@interface FixOtherSuggestCell : UITableViewCell

@property(nonatomic,strong)UIImageView  *iconV;
@property(nonatomic,strong)UILabel      *titleL;
@property(nonatomic,strong)UILabel      *subTitleL;
@property(nonatomic,strong)UILabel      *telL;

@property(nonatomic,strong)FixSuggestInfo   *suggest;

+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelf;
@end

@implementation FixOtherSuggestCell

+ (NSString *)reuseIdentify {
    return @"FixOtherSuggestCellIdentify";
}
+ (CGFloat)heightOfSelf {
    return 192/2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _weak(self);
        self.iconV = [[UIImageView alloc] init];
        self.iconV.layer.borderColor = [RGB(223, 223, 223) CGColor];
        self.iconV.layer.borderWidth = 1;
        [self.contentView addSubview:self.iconV];
        [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(14);
            make.left.equalTo(self.contentView).with.offset(26);
            make.width.height.equalTo(@69);
        }];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.textColor = k_COLOR_GALLERY_F;
        self.titleL.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(23);
            make.left.equalTo(self.iconV.mas_right).with.offset(19);
            make.height.equalTo(@18);
            make.width.equalTo(self.contentView).with.offset(-49);
        }];
        
        self.subTitleL = [[UILabel alloc] init];
        self.subTitleL.textColor = k_COLOR_GALLERY_F;
        self.subTitleL.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.subTitleL];
        [self.subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.titleL.mas_bottom).with.offset(5);
            make.left.right.equalTo(self.titleL);
            make.height.equalTo(@12);
        }];
        
        self.telL = [[UILabel alloc] init];
        self.telL.textColor = k_COLOR_BLUE;
        self.telL.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.telL];
        [self.telL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.subTitleL.mas_bottom).with.offset(5);
            make.left.right.equalTo(self.titleL);
            make.height.equalTo(@15);
        }];
        
        UIImageView *arrawV = [[UIImageView alloc] init];
        arrawV.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:arrawV];
        [arrawV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-32);
            make.width.equalTo(@10);
            make.height.equalTo(@15);
        }];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = RGB(226, 226, 226);
        [self.contentView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"suggest" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.iconV setImageWithURL:[NSURL URLWithString:self.suggest.image] placeholderImage:[UIImage imageNamed:@"default_placeholder"]];
        self.titleL.text = self.suggest.title;
        self.subTitleL.text = self.suggest.subTitle;
        self.telL.text = self.suggest.tel;
    }];
}
@end


@interface PropertyFixVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;
@property(nonatomic,strong)UITableView      *fixTableV;
@property(nonatomic,strong)UIImageView      *actionV;

@property(nonatomic,strong)NSArray          *fixIssueList;
@property(nonatomic,strong)NSArray          *fixSuggestList;
@property(nonatomic,weak)FixIssueInfo       *actionIssue;
@property(nonatomic,strong)NSNumber         *currentPage;
@property(nonatomic,strong)NSNumber         *pageSize;

@end

@implementation PropertyFixVC

- (NSString *)umengPageName {
    return @"维修保修";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_PropertyFix";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = @1;
    self.pageSize = @20;
    
    [self _setupObserver];
    
    [self.fixTableV.header beginRefreshing];
    [self _setupTapGestureRecognizer];
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

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (self.fixTableV) {
        return;
    }
    
    _weak(self);
    self.fixTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        v.delaysContentTouches = YES;
        
        [v registerClass:[FixTelCell class] forCellReuseIdentifier:[FixTelCell reuseIdentify]];
        [v registerClass:[FixTelEditCell class] forCellReuseIdentifier:[FixTelEditCell reuseIdentify]];
        [v registerClass:[FixTelEditCell class] forCellReuseIdentifier:[FixTelEditCell reuseIdentify]];
        [v registerClass:[FixIssueCell class] forCellReuseIdentifier:[FixIssueCell reuseIdentify]];
        [v registerClass:[FixOtherSuggestCell class] forCellReuseIdentifier:[FixOtherSuggestCell reuseIdentify]];
        
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            if ([UserModel sharedModel].isPropertyAdminLogined) {
                [self _refreshIssueList];
            }
            else {
                [self _refreshSuggestList];
            }
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            if ([UserModel sharedModel].isPropertyAdminLogined) {
                [self _loadMoreIssueList];
            }
            else {
                [self _loadMoreSuggestList];
            }
        }];
        
        [v withBlockForSectionNumber:^NSInteger(UITableView *view) {
            if ([UserModel sharedModel].isPropertyAdminLogined) {
                return 2;
            }
            else {
                return 3;
            }
        }];
        
        [v withBlockForHeaderView:^UIView *(UITableView *view, NSInteger section) {
            if (section == 0) {
                return nil;
            }
            
            UIView *ret = [[UIView alloc] init];
            ret.backgroundColor = k_COLOR_WHITE;
            UIView *leftL = [[UIView alloc] init];
            leftL.backgroundColor = RGB(176, 176, 176);
            UIView *rightL = [[UIView alloc] init];
            rightL.backgroundColor = RGB(176, 176, 176);
            UILabel *titleL = [[UILabel alloc] init];
            titleL.font = [UIFont boldSystemFontOfSize:17];
            titleL.textColor = k_COLOR_BLUE;
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.text = (section == 1?@"信息提交":@"其它推荐");
            UILabel *subtitleL = [[UILabel alloc] init];
            subtitleL.textColor = k_COLOR_GALLERY_F;
            subtitleL.font = [UIFont boldSystemFontOfSize:12];
            subtitleL.textAlignment = NSTextAlignmentCenter;
            subtitleL.text = (section == 1?([UserModel sharedModel].isPropertyAdminLogined?@"以下是客户提出的维修事件，请及时处理":@"提交您的维修信息，我们会尽及时与您联系"):@"我们为您提供其他的维修产品体验");
            [ret addSubview:titleL];
            _weak(ret);
            [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(ret);
                make.top.equalTo(ret).with.offset(12);
                make.centerX.equalTo(ret);
                make.width.equalTo(@88);
                make.height.equalTo(@17);
            }];
            [ret addSubview:leftL];
            _weak(titleL);
            [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(ret);
                _strong(titleL);
                make.centerY.equalTo(titleL);
                make.left.equalTo(ret).with.offset(27);
                make.right.equalTo(titleL.mas_left);
                make.height.equalTo(@1);
            }];
            [ret addSubview:rightL];
            [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(ret);
                _strong(titleL);
                make.centerY.equalTo(titleL);
                make.left.equalTo(titleL.mas_right);
                make.right.equalTo(ret).with.offset(-27);
                make.height.equalTo(@1);
            }];
            [ret addSubview:subtitleL];
            [subtitleL mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(titleL);
                make.centerX.equalTo(titleL);
                make.top.equalTo(titleL.mas_bottom).with.offset(4);
                make.width.equalTo(ret);
                make.height.equalTo(@12);
            }];
            return ret;
        }];
        [v withBlockForHeaderHeight:^CGFloat(UITableView *view, NSInteger section) {
            if (section == 0) {
                return 0;
            }
            
            if (section == 1) {
                return 57;
            }
            
            if (section == 2) {
                return 57;
            }
            return 0;
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            if (section == 0) {
                return 1;
            }
            if (section == 1) {
                if ([UserModel sharedModel].isPropertyAdminLogined) {
                    return [self.fixIssueList count];
                }
                else {
                    return 1;
                }
            }
            if (section == 2) {
                if ([UserModel sharedModel].isPropertyAdminLogined) {
                    return 0;
                }
                else {
                    return [self.fixSuggestList count];
                }
            }
            return 0;
        }];
        
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if (path.section == 0) {
                if ([UserModel sharedModel].isPropertyAdminLogined) {
                    FixTelEditCell *cell = [view dequeueReusableCellWithIdentifier:[FixTelEditCell reuseIdentify]];
                    if (!cell) {
                        cell = [[FixTelEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FixTelEditCell reuseIdentify]];
                    }
                    
                    return cell;
                }
                else {
                    FixTelCell *cell = [view dequeueReusableCellWithIdentifier:[FixTelCell reuseIdentify]];
                    if (!cell) {
                        cell = [[FixTelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FixTelCell reuseIdentify]];
                    }
                    cell.callBlock = ^(){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [CommonModel sharedModel].currentCommunity.tel]]];
                    };
                    return cell;
                }
            }
            else if (path.section == 1) {
                if ([UserModel sharedModel].isPropertyAdminLogined) {
                    FixIssueCell *cell = [view dequeueReusableCellWithIdentifier:[FixIssueCell reuseIdentify] forIndexPath:path];
                    if (!cell) {
                        cell = [[FixIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FixIssueCell reuseIdentify]];
                    }
                    
                    cell.fixIssue = self.fixIssueList[path.row];
                    cell.picShowBlock = ^(NSArray *picUrlArray, NSInteger index){
                        if (picUrlArray)
                            [self performSegueWithIdentifier:@"Segue_PropertyFix_PictureShow" sender:@[picUrlArray, @(index)]];
                    };
                    cell.actionBlock = ^(FixIssueCell *cell){
                        if ([UserModel sharedModel].isPropertyAdminLogined) {
                            _strong(self);
                            if ([self.actionV isHidden]) {
                                self.actionIssue = cell.fixIssue;
                                [self.actionV mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    _strong(self);
                                    CGRect cellRect = [cell convertRect:cell.bounds toView:self.contentV];
                                    make.top.equalTo(@(cellRect.origin.y+28));
                                    make.right.equalTo(self.contentV).with.offset(-28);
                                    make.width.equalTo(@77);
                                    make.height.equalTo(@39);
                                }];
                            }
                            [self.actionV setHidden:!self.actionV.isHidden];
                        }
                    };
                    return cell;
                }
                else {
                    FixIssueEditCell *cell = [view dequeueReusableCellWithIdentifier:[FixIssueEditCell reuseIdentify]];
                    if (!cell) {
                        cell = [[FixIssueEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FixIssueEditCell reuseIdentify]];
                    }
                    cell.vc = self;
                    return cell;
                }
            }
            else {
                if ([UserModel sharedModel].isPropertyAdminLogined) {
                    return nil;
                }
                else {
                    FixOtherSuggestCell *cell = [view dequeueReusableCellWithIdentifier:[FixOtherSuggestCell reuseIdentify] forIndexPath:path];
                    if (!cell) {
                        cell = [[FixOtherSuggestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FixOtherSuggestCell reuseIdentify]];
                    }
                    cell.suggest = self.fixSuggestList[path.row];
                    return cell;
                }
            }
        }];
        
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            if (path.section == 0) {
                if ([UserModel sharedModel].isPropertyAdminLogined) {
                    return [FixTelEditCell heightOfSelf];
                }
                else {
                    return [FixTelCell heightOfSelf];
                }
            }
            else if (path.section == 1) {
                if ([UserModel sharedModel].isPropertyAdminLogined) {
                    return [FixIssueCell heightWithIssue:self.fixIssueList[path.row] screenWidth:V_W_(self.view)];
                }
                else {
                    return [FixIssueEditCell heightOfSelf];
                }
            }
            else {
                if ([UserModel sharedModel].isPropertyAdminLogined) {
                    return 0;
                }
                else {
                    return [FixOtherSuggestCell heightOfSelf];
                }
            }
        }];
        
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            if (path.section == 2) {
                _strong(self);
                FixSuggestInfo *info = self.fixSuggestList[path.row];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", info.tel]]];
            }
        }];
        v;
    });
    
    self.actionV = [[UIImageView alloc] init];
    self.actionV.userInteractionEnabled = YES;
    self.actionV.image = [UIImage imageNamed:@"p_weicomment_action_btn"];
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [deleteBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [deleteBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateHighlighted];
    [deleteBtn setTitle:@"已处理" forState:UIControlStateNormal];
    [self.actionV addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.bottom.equalTo(self.actionV);
    }];
    [deleteBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self.actionV setHidden:YES];
        if (![[UserModel sharedModel] isPropertyAdminLogined]) {
            [SVProgressHUD showErrorWithStatus:@"请先登录"];
            return;
        }
        if (!self.actionIssue) {
            return;
        }
        [[PropertyServiceModel sharedModel] asyncFixIssueDoneWithIssueId:self.actionIssue.issueId remoteBlock:^(BOOL isSuccess, NSError *error) {
            _strong(self);
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"操作成功"];
                [self _refreshIssueList];
            }
        }];
    }];
}

- (void)_layoutCodingViews {
    if ([self.fixTableV superview]) {
        return;
    }
    
    _weak(self);
    UIView *topTmp = [[UIView alloc] init];
    topTmp.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:topTmp];
    [topTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(-1);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    UIView *botTmp = [[UIView alloc] init];
    botTmp.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:botTmp];
    [botTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.bottom.equalTo(self.contentV).with.offset(1);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    [self.contentV addSubview:self.fixTableV];
    [self.fixTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.bottom.equalTo(self.contentV);
    }];
    
    [self.contentV addSubview:self.actionV];
    [self.actionV setHidden:YES];
}

- (void)_setupTapGestureRecognizer {
    _weak(self);
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        _strong(self);
        if (!CGRectContainsPoint(self.actionV.frame, [touch locationInView:self.contentV])) {
            [self.actionV setHidden:YES];
        }
        return NO;
    }];
    [self.contentV addGestureRecognizer:tap];
}

#pragma mark - Data
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"fixIssueList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if ([UserModel sharedModel].isPropertyAdminLogined) {
            [self.fixTableV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    [self startObserveObject:self forKeyPath:@"fixSuggestList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (![UserModel sharedModel].isPropertyAdminLogined) {
            [self.fixTableV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)_refreshIssueList {
    [self _loadIssueListAtPage:@1 pageSize:self.pageSize];
}

- (void)_loadMoreIssueList {
    [self _loadIssueListAtPage:@([self.currentPage integerValue]+1) pageSize:self.pageSize];
}

- (void)_refreshSuggestList {
    [self _loadSuggestListAtPage:@1 pageSize:self.pageSize];
}

- (void)_loadMoreSuggestList {
    [self _loadSuggestListAtPage:@([self.currentPage integerValue]+1) pageSize:self.pageSize];
}

- (void)_loadIssueListAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    [[PropertyServiceModel sharedModel] asyncFixIssueQueryWithCommunityId:[CommonModel sharedModel].currentCommunityId isDeleted:@(0) page:page pageSize:pageSize cacheBlock:^(NSArray *issueList, NSNumber *page) {
    } remoteBlock:^(NSArray *issueList, NSNumber *page, NSError *error) {
        if ([self.fixTableV.header isRefreshing]) {
            [self.fixTableV.header endRefreshing];
        }
        if ([self.fixTableV.footer isRefreshing]) {
            [self.fixTableV.footer endRefreshing];
        }
        
        if (!error) {
            self.currentPage = page;
            if ([page integerValue] == 1) {
                self.fixIssueList = issueList;
            }
            else {
                NSMutableArray *tmp = [self.fixIssueList mutableCopy];
                [tmp addObjectsFromArray:issueList];
                self.fixIssueList = tmp;
            }
        }
    }];
}

- (void)_loadSuggestListAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    [[PropertyServiceModel sharedModel] asyncFixSuggestQueryWithCommunityId:[CommonModel sharedModel].currentCommunityId page:page pageSize:pageSize cacheBlock:^(NSArray *seggestList, NSNumber *page) {
    } remoteBlock:^(NSArray *seggestList, NSNumber *page, NSError *error) {
        if ([self.fixTableV.header isRefreshing]) {
            [self.fixTableV.header endRefreshing];
        }
        if ([self.fixTableV.footer isRefreshing]) {
            [self.fixTableV.footer endRefreshing];
        }
        
        if (!error) {
            self.currentPage = page;
            if ([page integerValue] == 1) {
                self.fixSuggestList = seggestList;
            }
            else {
                NSMutableArray *tmp = [self.fixSuggestList mutableCopy];
                [tmp addObjectsFromArray:seggestList];
                self.fixSuggestList = tmp;
            }
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_PropertyFix_PictureShow"]) {
        PictureShowVC *vc = segue.destinationViewController;
        vc.picUrlArray = [sender objectAtIndex:0];
        vc.currentIndex = [[sender objectAtIndex:1] unsignedIntegerValue];
    }
}


@end
