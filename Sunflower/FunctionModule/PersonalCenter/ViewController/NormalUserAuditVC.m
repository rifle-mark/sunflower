//
//  NormalUserInfoEditVC.m
//  Sunflower
//
//  Created by mark on 15/5/9.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "NormalUserAuditVC.h"

#import "UserModel.h"
#import "CommonModel.h"
#import "MKWModelHandler.h"
#import "CommunityBuild.h"
#import "ContractVC.h"
#import "APIGenerator.h"
#import "ServerProxy.h"

@interface AuditTelNumCell : UICollectionViewCell

@property(nonatomic,strong)UILabel      *numL;
@property(nonatomic,strong)UITextView   *numT;
@property(nonatomic,assign)BOOL         shouldEdit;
@property(nonatomic,strong)NSString     *telNum;

@property(nonatomic,copy)void(^didEndEditBlock)();

+ (NSString *)reuseIdentify;

@end

@implementation AuditTelNumCell

+ (NSString *)reuseIdentify {
    return @"AuditTelNumCellIdentify";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _weak(self);
        self.numT = [[UITextView alloc] init];
        self.numT.textColor = k_COLOR_GALLERY_F;
        self.numT.font = [UIFont boldSystemFontOfSize:20];
        self.numT.textContainerInset = UIEdgeInsetsMake(15, 0, 17, 0);
        self.numT.textAlignment = NSTextAlignmentCenter;
        self.numT.keyboardType = UIKeyboardTypeNumberPad;
        self.numT.backgroundColor = k_COLOR_CLEAR;
        self.numT.scrollEnabled = NO;
        self.numT.showsHorizontalScrollIndicator = NO;
        self.numT.showsVerticalScrollIndicator = NO;
        [self.numT withBlockForDidBeginEditing:^(UITextView *view) {
            _strong(self);
            self.numT.text = @"";
        }];
        [self.numT withBlockForDidChanged:^(UITextView *view) {
            if (![MKWStringHelper isNilEmptyOrBlankString:[MKWStringHelper trimWithStr:self.numT.text]]) {
                [self.numT resignFirstResponder];
            }
        }];
        [self.numT withBlockForDidEndEditing:^(UITextView *view) {
            GCBlockInvoke(self.didEndEditBlock);
        }];
        [self.contentView addSubview:self.numT];
        [self.numT mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
        
        self.numL = [[UILabel alloc] init];
        self.numL.font = [UIFont boldSystemFontOfSize:20];
        self.numL.textColor = k_COLOR_GALLERY_F;
        self.numL.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.numL];
        [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
        
        self.shouldEdit = NO;
        [self _setupObserver];
    }
    return self;
}

- (BOOL)becomeFirstResponder {
    if (self.shouldEdit) {
        return [self.numT becomeFirstResponder];
    }
    return NO;
}

- (BOOL)resignFirstResponder {
    if (self.shouldEdit) {
        return [self.numT resignFirstResponder];
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder {
    if (self.shouldEdit) {
        return YES;
    }
    return NO;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"shouldEdit" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.shouldEdit) {
            [self.numL setHidden:YES];
            [self.numT setHidden:NO];
        }
        else {
            [self.numL setHidden:NO];
            [self.numT setHidden:YES];
        }
    }];
}

- (NSString *)telNum {
    if (self.shouldEdit) {
        return [MKWStringHelper trimWithStr:self.numT.text];
    }
    else {
        return [MKWStringHelper trimWithStr:self.numL.text];
    }
}

- (void)setTelNum:(NSString *)telNum {
    if (self.shouldEdit) {
        self.numT.text = telNum;
    }
    else {
        self.numL.text = telNum;
    }
}
@end

@interface NormalUserAuditVC () <UITextFieldDelegate>

@property(nonatomic,strong)UIScrollView     *contentScrollV;
@property(nonatomic,strong)UIView           *contentV;
@property(nonatomic,strong)UIView           *userInfoV;
@property(nonatomic,strong)UIImageView      *avatarV;
@property(nonatomic,strong)UILabel          *nickNameL;
@property(nonatomic,strong)UILabel          *userIdL;
@property(nonatomic,strong)UIImageView      *arrawV;

@property(nonatomic,strong)UIView           *confirmNoteV;
@property(nonatomic,strong)UIImageView      *confirmIconV;
@property(nonatomic,strong)UILabel          *confirmTitleL;
@property(nonatomic,strong)UILabel          *confirmSubL;

@property(nonatomic,strong)UIView           *confirmInfoV;
@property(nonatomic,strong)UILabel          *confirmInfoL;
@property(nonatomic,strong)UILabel          *nameL;
@property(nonatomic,strong)UILabel          *sexL;
@property(nonatomic,strong)UILabel          *telL;
@property(nonatomic,strong)UILabel          *communityL;
@property(nonatomic,strong)UILabel          *buildL;
@property(nonatomic,strong)UILabel          *unitL;
@property(nonatomic,strong)UILabel          *roomL;
@property(nonatomic,strong)UILabel          *roleL;
@property(nonatomic,strong)UILabel          *relationShipL;
@property(nonatomic,strong)UILabel          *inviteNOL;
@property(nonatomic,strong)UIButton         *confirmModifyBtn;

@property(nonatomic,strong)UIScrollView     *confirmScrollV;
@property(nonatomic,strong)UIView           *confirmContentV;
@property(nonatomic,strong)UIView           *confirmStep1V;
@property(nonatomic,strong)UIButton         *builtBtn;
@property(nonatomic,strong)UIButton         *unitBtn;
@property(nonatomic,strong)UIButton         *roomBtn;
@property(nonatomic,strong)UIButton         *auditCheckBoxBtn;

@property(nonatomic,strong)UIView           *confirmStep2V;
@property(nonatomic,strong)UILabel          *telTL;
@property(nonatomic,strong)UIButton         *telRefreshBtn;
@property(nonatomic,strong)UICollectionView *telCollectV;
@property(nonatomic,strong)UITextField      *inviteCodeT;
@property(nonatomic,strong)UILabel          *stepInfo1L;
@property(nonatomic,strong)UILabel          *stepInfo2L;
@property(nonatomic,strong)UIButton         *roleBtn;
@property(nonatomic,strong)UIButton         *ownHouseBtn;
@property(nonatomic,strong)UIButton         *ownerFamilyBtn;
@property(nonatomic,strong)UIButton         *rentHouseBtn;

@property(nonatomic,strong)UIView           *confirmStep3V;
@property(nonatomic,strong)UITextField      *auditNameT;
@property(nonatomic,strong)UIButton         *auditSexBtn;
@property(nonatomic,strong)UITextField      *auditTelT;
@property(nonatomic,strong)UITextField      *auditVerifyT;
@property(nonatomic,strong)UIButton         *getVerifyBtn;

@property(nonatomic,strong)UITableView      *selectionView;
@property(nonatomic,weak)UIView             *focusedT;

@property(nonatomic,strong)NSString         *selectedBuild;
@property(nonatomic,strong)NSString         *selectedUnit;
@property(nonatomic,strong)NSString         *selectedRoom;
@property(nonatomic,strong)NSArray          *buildings;
@property(nonatomic,strong)NSArray          *auditTelNums;
@property(nonatomic,assign)NSUInteger       currentTelIdx;
@property(nonatomic,strong)NSArray          *selectionArray;
@property(nonatomic,strong)NSString         *roleInFamily;
@property(nonatomic,strong)NSString         *ownerShipOfHouse;
@property(nonatomic,strong)NSNumber         *auditSex;
@property(nonatomic,strong)NSString         *checkCode;
@property(nonatomic,strong)NSString         *inviteCode;
@property(nonatomic,assign)BOOL             isInviteAudit;


@end

@implementation NormalUserAuditVC

- (NSString *)umengPageName {
    return @"业主认证";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_NormalUserAudit";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self _layoutCodingViews];
    FixesViewDidLayoutSubviewsiOS7Error;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_PCAudit_Contract"]) {
        ((ContractVC*)segue.destinationViewController).url = [NSURL URLWithString:[APIGenerator apiAddressWithSuffix:k_API_USER_ANNOUNCE]];
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}


#pragma mark - Business Logic
- (void)_setupObserver {
    _weak(self);
    
    [self addObserverForNotificationName:k_NOTIFY_NAME_USER_INFO_UPDATE usingBlock:^(NSNotification *notification) {
        _strong(self);
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        [self.avatarV sd_setImageWithURL:[APIGenerator urlOfPictureWith:screenWidth==320?80:106 height:screenWidth==320?80:106 urlString:[UserModel sharedModel].currentNormalUser.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.nickNameL.text = [UserModel sharedModel].currentNormalUser.nickName;
    }];
    [self startObserveObject:self forKeyPath:@"selectedBuild" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        if (![[change objectForKeyedSubscript:NSKeyValueChangeNewKey] isEqualToString:[change objectForKeyedSubscript:NSKeyValueChangeOldKey]]) {
            _strong(self);
            [self _updateSelectedUnit:nil];
            [self _updateSelectedRoom:nil];
            [self.unitBtn setTitle:@"请选择单元" forState:UIControlStateNormal];
            [self.roomBtn setTitle:@"请选择房间号" forState:UIControlStateNormal];
        }
    }];
    [self startObserveObject:self forKeyPath:@"selectedUnit" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        if (![[change objectForKeyedSubscript:NSKeyValueChangeNewKey] isEqualToString:[change objectForKeyedSubscript:NSKeyValueChangeOldKey]]) {
            _strong(self);
            [self _updateSelectedRoom:nil];
            [self.roomBtn setTitle:@"请选择房间号" forState:UIControlStateNormal];
        }
    }];
    [self startObserveObject:self forKeyPath:@"isInviteAudit" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        self.telTL.text = (self.isInviteAudit?@"请输入业主邀请码:":@"请补全房屋业主预留手机号:");
        [self.telCollectV setHidden:self.isInviteAudit];
        [self.inviteCodeT setHidden:!self.isInviteAudit];
        [self.telRefreshBtn setHidden:self.isInviteAudit];
        self.stepInfo1L.text = (self.isInviteAudit?@"如果你没有邀请码，请向业主索取":@"如已更换手机号码,需要业主前往物业管理中心更新");
        self.stepInfo2L.text = (self.isInviteAudit?@"如果无法获取业主邀请码，可返回使用业主手机号认证":@"如已无法获取业主手机号,可返回使用业主邀请码认证");
    }];
}

- (void)_confirm {
    
}

- (void)_updateSelectedUnit:(NSString *)unit {
    _selectedUnit = unit;
}
- (void)_updateSelectedRoom:(NSString *)room {
    _selectedRoom = room;
}

#pragma mark - data
- (void)_loadUserAuditInfo {
    UserInfo *cUser = [UserModel sharedModel].currentNormalUser;
    self.nameL.text = cUser.trueName;
    self.sexL.text = [cUser.sex integerValue] == 1?@"男":@"女";
    self.telL.text = cUser.userName;
    self.userIdL.text = [cUser.userId stringValue];
    self.communityL.text = cUser.communityName;
    self.buildL.text = cUser.building;
    self.unitL.text = cUser.unit;
    self.roomL.text = cUser.room;
    self.roleL.text = cUser.roleName;
    self.relationShipL.text = cUser.roomProperty;
    self.inviteNOL.text = cUser.invitationNum;
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (!self.contentScrollV) {
        self.contentScrollV = [[UIScrollView alloc] init];
        self.contentScrollV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.contentScrollV.showsHorizontalScrollIndicator = NO;
        self.contentScrollV.showsVerticalScrollIndicator = NO;
        self.contentV = [[UIView alloc] init];
        [self.contentScrollV addSubview:self.contentV];
        
        [self _loadUserInfoView];
        [self _loadConfirmNoteView];
        [self _loadConfirmInfoView];
        [self _loadConfirmModifyView];
        [self _loadSelectionView];
        
        [self _setupTapGuester];
    }
}
- (void)_setupTapGuester {
    _weak(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        _strong(self);
        if ([self.selectionView superview] && !CGRectContainsPoint(self.selectionView.frame, [touch locationInView:[self.selectionView superview]])) {
            [self.selectionView removeFromSuperview];
        }
        if (self.focusedT && [self.focusedT isFirstResponder]) {
            [self.focusedT resignFirstResponder];
        }
        return NO;
    }];
    [self.confirmContentV addGestureRecognizer:tap];
}
- (void)_loadSelectionView {
    self.selectionView = ({
        UITableView *v = [[UITableView alloc] init];
        [v setShowsHorizontalScrollIndicator:NO];
        [v setShowsVerticalScrollIndicator:NO];
        [v registerClass:[UITableViewCell class] forCellReuseIdentifier:@"selectionCell"];
        [v setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        v.layer.borderColor = [k_COLOR_GALLERY_F CGColor];
        v.layer.borderWidth = 1;
        v.layer.cornerRadius = 4;
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            return [self.selectionArray count];
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:@"selectionCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectionCell"];
            }
            NSString *selection = [self.selectionArray objectAtIndex:path.row];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = k_COLOR_GALLERY_F;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = selection;
            return cell;
        }];
        [v withBlockForSectionNumber:^NSInteger(UITableView *view) {
            return 1;
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 30;
        }];
        v;
    });
}
- (void)_showSelectionView:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _weak(self);
    _weak(btn);
    void (^showSelectionBlock)() = ^{
        [self.selectionView withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            _strong(btn);
            UITableViewCell *cell = [view cellForRowAtIndexPath:path];
            [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
            [btn setTitle:cell.textLabel.text forState:UIControlStateHighlighted];
            if ([btn isEqual:self.builtBtn]) {
                self.selectedBuild = btn.titleLabel.text;
            }
            if ([btn isEqual:self.unitBtn]) {
                self.selectedUnit = btn.titleLabel.text;
            }
            if ([btn isEqual:self.roomBtn]) {
                self.selectedRoom = btn.titleLabel.text;
            }
            if ([btn isEqual:self.roleBtn]) {
                self.roleInFamily = btn.titleLabel.text;
            }
            if ([btn isEqual:self.auditSexBtn]) {
                if ([self.auditSexBtn.titleLabel.text isEqualToString:@"男"]) {
                    self.auditSex = @(1);
                }
                else if ([self.auditSexBtn.titleLabel.text isEqualToString:@"女"]) {
                    self.auditSex = @(2);
                }
                else {
                    self.auditSex = @(0);
                }
            }
            [self.selectionView removeFromSuperview];
        }];
        
        if (![self.selectionView superview]) {
            [[btn superview] addSubview:self.selectionView];
        }
        [self.selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(btn);
            CGRect rect = [btn convertRect:btn.bounds toView:[btn superview]];
            make.left.equalTo(btn);
            make.right.equalTo(btn);
            if (rect.origin.y+rect.size.height + 90 > V_H_(self.view)-50) {
                make.bottom.equalTo(btn.mas_top);
            }
            else {
                make.top.equalTo(btn.mas_bottom);
            }
            make.height.equalTo(@90);
        }];
        [[btn superview] bringSubviewToFront:self.selectionView];
    };
    
    self.selectionArray = @[];
    if ([btn isEqual:self.builtBtn]) {
        NSArray *builds = [[MKWModelHandler defaultHandler] queryObjectsForEntity:@"CommunityBuild" predicate:[NSPredicate predicateWithFormat:@"communityId=%@", [CommonModel sharedModel].currentCommunityId]];
        NSMutableArray *choiceBuilds = [@[] mutableCopy];
        for (CommunityBuild *b in builds) {
            BOOL has = NO;
            for (int i = 0; i < [choiceBuilds count]; i++) {
                if ([choiceBuilds[i] integerValue] == [b.build integerValue]) {
                    has = YES;
                    break;
                }
            }
            if (has) {
                continue;
            }
            [choiceBuilds addObject:b.build];
        }
        
        NSMutableArray *selects = [[NSMutableArray alloc] initWithCapacity:choiceBuilds.count];
        for (NSNumber *c in choiceBuilds) {
            [selects addObject:[NSString stringWithFormat:@"%@号楼", c]];
        }
        
        self.selectionArray = selects;
    }
    
    if ([btn isEqual:self.unitBtn]) {
        NSInteger choosedbuild = [self.selectedBuild integerValue];
        NSArray *units = [[MKWModelHandler defaultHandler] queryObjectsForEntity:@"CommunityBuild" predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND build=%@",[CommonModel sharedModel].currentCommunityId,  @(choosedbuild)]];
        NSMutableArray *selects = [[NSMutableArray alloc] initWithCapacity:units.count];
        for (CommunityBuild *b in units) {
            [selects addObject:[NSString stringWithFormat:@"%@单元",b.units]];
        }
        
        self.selectionArray = selects;
    }
    
    if ([btn isEqual:self.roomBtn]) {
        NSInteger choosedbuild = [self.selectedBuild integerValue];
        NSInteger chooseunit = [self.selectedUnit integerValue];
        CommunityBuild *b = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:@"CommunityBuild" predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND build=%@ AND units=%@", [CommonModel sharedModel].currentCommunityId, @(choosedbuild), @(chooseunit)]] firstObject];
        if (!b) {
            return;
        }
        NSMutableArray *selects = [[NSMutableArray alloc] initWithCapacity:([b.floors integerValue]*[b.houses integerValue])];
        for (NSInteger i = 1; i <= [b.floors integerValue]; i++) {
            for (NSInteger j = 1; j <= [b.houses integerValue]; j++) {
                [selects addObject:[NSString stringWithFormat:@"%@%@%@", @(i), j>9?@"":@"0", @(j)]];
            }
        }
        
        self.selectionArray = selects;
    }
    
    if ([btn isEqual:self.roleBtn]) {
        self.selectionArray = @[@"男主人",@"女主人",@"儿子",@"女儿",@"亲戚",@"住户"];
    }
    
    if ([btn isEqual:self.auditSexBtn]) {
        self.selectionArray = @[@"男", @"女"];
    }
    
    [self.selectionView reloadData];
    [self.selectionView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    showSelectionBlock();
}
- (void)_loadUserInfoView {
    _weak(self);
    UserInfo *cUser = [UserModel sharedModel].currentNormalUser;
    self.userInfoV = [[UIView alloc] init];
    self.userInfoV.backgroundColor = RGB(225, 225, 225);
    [self.contentV addSubview:self.userInfoV];
    [self.userInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.equalTo(self.contentV);
        make.height.equalTo(@129);
    }];
    self.avatarV = [[UIImageView alloc] init];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.avatarV.layer.cornerRadius = screenWidth==320?40:53;
    self.avatarV.clipsToBounds = YES;
    [self.avatarV sd_setImageWithURL:[APIGenerator urlOfPictureWith:screenWidth==320?80:106 height:screenWidth==320?80:106 urlString:cUser.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    [self.userInfoV addSubview:self.avatarV];
    [self.avatarV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.userInfoV).with.offset(12);
        make.centerY.equalTo(self.userInfoV);
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        make.width.height.equalTo(screenWidth==320?@(80):@(106));
    }];
    self.arrawV = [[UIImageView alloc] init];
    self.arrawV.image = [UIImage imageNamed:@"pc_more"];
    [self.userInfoV addSubview:self.arrawV];
    [self.arrawV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.right.equalTo(self.userInfoV).with.offset(-12);
        make.top.equalTo(self.userInfoV).with.offset(45);
        make.width.equalTo(@8);
        make.height.equalTo(@15);
    }];
    UILabel *nameTitleL = [[UILabel alloc] init];
    nameTitleL.text = @"昵  称:";
    nameTitleL.font = [UIFont boldSystemFontOfSize:15];
    nameTitleL.textColor = k_COLOR_GALLERY_F;
    [self.userInfoV addSubview:nameTitleL];
    [nameTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.avatarV.mas_right).with.offset(13);
        make.top.equalTo(self.arrawV);
        make.width.equalTo(@50);
        make.height.equalTo(@15);
    }];
    self.nickNameL = [[UILabel alloc] init];
    self.nickNameL.textColor = k_COLOR_GALLERY_F;
    self.nickNameL.font = [UIFont boldSystemFontOfSize:15];
    self.nickNameL.text = [UserModel sharedModel].currentNormalUser.nickName;
    [self.userInfoV addSubview:self.nickNameL];
    [self.nickNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.avatarV.mas_right).with.offset(65);
        make.right.equalTo(self.arrawV.mas_left).with.offset(-4);
        make.top.equalTo(self.arrawV);
        make.height.equalTo(@15);
    }];
    UILabel *idTitleL = [[UILabel alloc] init];
    idTitleL.text = @"邻里号:";
    idTitleL.font = [UIFont boldSystemFontOfSize:15];
    idTitleL.textColor = k_COLOR_GALLERY_F;
    [self.userInfoV addSubview:idTitleL];
    [idTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.avatarV.mas_right).with.offset(13);
        make.top.equalTo(self.nickNameL.mas_bottom).with.offset(12);
        make.width.equalTo(@50);
        make.height.equalTo(@15);
    }];
    self.userIdL = [[UILabel alloc] init];
    self.userIdL.textColor = k_COLOR_GALLERY_F;
    self.userIdL.font = [UIFont boldSystemFontOfSize:15];
    self.userIdL.text = [[UserModel sharedModel].currentNormalUser.userId stringValue];
    [self.userInfoV addSubview:self.userIdL];
    [self.userIdL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.avatarV.mas_right).with.offset(65);
        make.right.equalTo(self.arrawV.mas_left).with.offset(-4);
        make.top.equalTo(self.nickNameL.mas_bottom).with.offset(12);
        make.height.equalTo(@15);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
        _strong(self);
        [self performSegueWithIdentifier:@"Segue_PCInfo_NickName" sender:nil];
    }];
    [self.userInfoV addGestureRecognizer:tap];
}
- (void)_loadConfirmNoteView {
    _weak(self);
    self.confirmNoteV = [[UIView alloc] init];
    self.confirmNoteV.backgroundColor = k_COLOR_WHITE;
    [self.contentV addSubview:self.confirmNoteV];
    [self.confirmNoteV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.top.equalTo(self.userInfoV.mas_bottom);
        make.height.equalTo(@58);
    }];
    self.confirmIconV = [[UIImageView alloc] init];
    self.confirmIconV.image = [UIImage imageNamed:@"pc_edit_yezhu"];
    [self.confirmNoteV addSubview:self.confirmIconV];
    [self.confirmIconV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.confirmNoteV).with.offset(24);
        make.centerY.equalTo(self.confirmNoteV);
        make.width.height.equalTo(@27);
    }];
    self.confirmTitleL = [[UILabel alloc] init];
    self.confirmTitleL.font = [UIFont boldSystemFontOfSize:16];
    self.confirmTitleL.textColor = k_COLOR_BLUE;
    self.confirmTitleL.text = @"业主认证";
    [self.confirmNoteV addSubview:self.confirmTitleL];
    [self.confirmTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.centerY.equalTo(self.confirmNoteV);
        make.height.equalTo(@16);
        make.width.equalTo(@79);
        make.left.equalTo(self.confirmIconV.mas_right).with.offset(8);
    }];
    
    self.confirmSubL = [[UILabel alloc] init];
    self.confirmSubL.font = [UIFont boldSystemFontOfSize:12];
    self.confirmSubL.textColor = k_COLOR_GALLERY_F;
    self.confirmSubL.text = @"通过业主认证可获得5000积分";
    self.confirmSubL.textAlignment = NSTextAlignmentRight;
    [self.confirmNoteV addSubview:self.confirmSubL];
    [self.confirmSubL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.centerY.equalTo(self.confirmNoteV);
        make.left.equalTo(self.confirmTitleL.mas_right);
        make.right.equalTo(self.confirmNoteV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    if ([[UserModel sharedModel].currentNormalUser.isAudit boolValue]) {
        [self.confirmSubL setHidden:YES];
    }
    
    UIView *splitV = [[UIView alloc] init];
    splitV.backgroundColor = k_COLOR_GALLERY;
    [self.confirmNoteV addSubview:splitV];
    [splitV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.bottom.equalTo(self.confirmNoteV);
        make.height.equalTo(@1);
    }];
}
- (void)_loadConfirmInfoView {
    _weak(self);
    self.confirmInfoV = [[UIView alloc] init];
    self.confirmInfoV.backgroundColor = k_COLOR_WHITE;
    [self.contentV addSubview:self.confirmInfoV];
    [self.confirmInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.top.equalTo(self.confirmNoteV.mas_bottom);
        make.height.equalTo(@311);
    }];
    
    UILabel *(^labelBlock)(NSString *str, CGFloat fontsize) = ^(NSString *str, CGFloat fontsize) {
        UILabel * l = [[UILabel alloc] init];
        l.textColor = k_COLOR_GALLERY_F;
        l.font = [UIFont boldSystemFontOfSize:fontsize];
        l.text = str;
        return l;
    };
    UserInfo *cUser = [UserModel sharedModel].currentNormalUser;
    self.confirmInfoL = labelBlock(@"您已经完成业主认证，认证信息如下：", 15);
    [self.confirmInfoV addSubview:self.confirmInfoL];
    [self.confirmInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.confirmInfoV).with.offset(18);
        make.left.equalTo(self.confirmInfoV).with.offset(27);
        make.right.equalTo(self.confirmInfoV);
        make.height.equalTo(@15);
    }];
    UILabel *nameTL = labelBlock(@"姓名:", 12);
    [self.confirmInfoV addSubview:nameTL];
    [nameTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.top.equalTo(self.confirmInfoL.mas_bottom).with.offset(15);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    _weak(nameTL);
    self.nameL = labelBlock(cUser?cUser.trueName:@"", 12);
    [self.confirmInfoV addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(nameTL);
        make.top.bottom.equalTo(nameTL);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
    }];
    UILabel *sexTL = labelBlock(@"性别:", 12);
    [self.confirmInfoV addSubview:sexTL];
    [sexTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nameL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.sexL = labelBlock(cUser?([cUser.sex integerValue]==1?@"男":@"女"):@"", 12);
    [self.confirmInfoV addSubview:self.sexL];
    [self.sexL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nameL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    UILabel *telTL = labelBlock(@"手机号:", 12);
    [self.confirmInfoV addSubview:telTL];
    [telTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.sexL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.telL = labelBlock(cUser?cUser.userName:@"", 12);
    [self.confirmInfoV addSubview:self.telL];
    [self.telL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.sexL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    UILabel *communityTL = labelBlock(@"小区:", 12);
    [self.confirmInfoV addSubview:communityTL];
    [communityTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.telL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.communityL = labelBlock(cUser?cUser.communityName:@"", 12);
    [self.confirmInfoV addSubview:self.communityL];
    [self.communityL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.telL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    UILabel *buildTL = labelBlock(@"楼栋:", 12);
    [self.confirmInfoV addSubview:buildTL];
    [buildTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.communityL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.buildL = labelBlock(cUser?cUser.building:@"", 12);
    [self.confirmInfoV addSubview:self.buildL];
    [self.buildL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.communityL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    UILabel *unitTL = labelBlock(@"单元:", 12);
    [self.confirmInfoV addSubview:unitTL];
    [unitTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.buildL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.unitL = labelBlock(cUser?cUser.unit:@"", 12);
    [self.confirmInfoV addSubview:self.unitL];
    [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.buildL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    UILabel *roomTL = labelBlock(@"房间号:", 12);
    [self.confirmInfoV addSubview:roomTL];
    [roomTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.unitL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.roomL = labelBlock(cUser?cUser.room:@"", 12);
    [self.confirmInfoV addSubview:self.roomL];
    [self.roomL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.unitL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    UILabel *roleTL = labelBlock(@"家庭角色:", 12);
    [self.confirmInfoV addSubview:roleTL];
    [roleTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.roomL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.roleL = labelBlock(cUser?cUser.roleName:@"", 12);
    [self.confirmInfoV addSubview:self.roleL];
    [self.roleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.roomL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    UILabel *relationTL = labelBlock(@"关系:", 12);
    [self.confirmInfoV addSubview:relationTL];
    [relationTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.roleL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.relationShipL = labelBlock(cUser?cUser.roomProperty:@"", 12);
    [self.confirmInfoV addSubview:self.relationShipL];
    [self.relationShipL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.roleL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    UILabel *inviteTL = labelBlock(@"邀请码:", 12);
    [self.confirmInfoV addSubview:inviteTL];
    [inviteTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.relationShipL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(42);
        make.width.equalTo(@77);
        make.height.equalTo(@12);
    }];
    self.inviteNOL = labelBlock(cUser?cUser.invitationNum:@"", 12);
    [self.confirmInfoV addSubview:self.inviteNOL];
    [self.inviteNOL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.relationShipL.mas_bottom).with.offset(9);
        make.left.equalTo(self.confirmInfoV).with.offset(120);
        make.right.equalTo(self.confirmInfoV).with.offset(-13);
        make.height.equalTo(@12);
    }];
    
    self.confirmModifyBtn = [[UIButton alloc] init];
    self.confirmModifyBtn.backgroundColor = k_COLOR_BLUE;
    self.confirmModifyBtn.layer.cornerRadius = 4;
    [self.confirmModifyBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [self.confirmModifyBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [self.confirmModifyBtn setTitle:@"编辑认证信息" forState:UIControlStateNormal];
    [self.confirmModifyBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self.contentV bringSubviewToFront:self.confirmScrollV];
        [self.confirmInfoV setHidden:YES];
        [self.confirmScrollV setHidden:NO];
        [self.contentV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentScrollV);
            make.width.equalTo(self.view);
            make.height.equalTo(@594);
        }];
        [self.view layoutIfNeeded];
    }];
    [self.confirmInfoV addSubview:self.confirmModifyBtn];
    [self.confirmModifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.inviteNOL.mas_bottom).with.offset(13);
        make.left.equalTo(self.confirmInfoV).with.offset(22);
        make.right.equalTo(self.confirmInfoV).with.offset(-22);
        make.height.equalTo(@42);
    }];
}

- (void)_loadConfirmModifyView {
    self.confirmScrollV = [[UIScrollView alloc] init];
    self.confirmScrollV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.confirmScrollV.showsHorizontalScrollIndicator = NO;
    self.confirmScrollV.showsVerticalScrollIndicator = NO;
    self.confirmScrollV.pagingEnabled = YES;
    self.confirmScrollV.scrollEnabled = NO;
    _weak(self);
    [self.contentV addSubview:self.confirmScrollV];
    [self.confirmScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.top.equalTo(self.confirmNoteV.mas_bottom);
        make.height.equalTo(@407);
    }];
    
    self.confirmContentV = [[UIView alloc] init];
    [self.confirmScrollV addSubview:self.confirmContentV];
    [self.confirmContentV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.bottom.equalTo(self.confirmScrollV);
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        make.width.equalTo(@(width*3));
        make.height.equalTo(@407);
    }];
    
    self.confirmStep1V = [[UIView alloc] init];
    [self.confirmContentV addSubview:self.confirmStep1V];
    [self.confirmStep1V mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.bottom.equalTo(self.confirmContentV);
        make.width.equalTo(@([[UIScreen mainScreen] bounds].size.width));
    }];
    [self _loadConfirmStep1View];
    
    self.confirmStep2V = [[UIView alloc] init];
    [self.confirmContentV addSubview:self.confirmStep2V];
    [self.confirmStep2V mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.bottom.equalTo(self.confirmContentV);
        make.left.equalTo(self.confirmStep1V.mas_right);
        make.width.equalTo(@([[UIScreen mainScreen] bounds].size.width));
    }];
    [self _loadConfirmStep2View];
    
    self.confirmStep3V = [[UIView alloc] init];
    [self.confirmContentV addSubview:self.confirmStep3V];
    [self.confirmStep3V mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.bottom.equalTo(self.confirmContentV);
        make.left.equalTo(self.confirmStep2V.mas_right);
        make.width.equalTo(@([[UIScreen mainScreen] bounds].size.width));
    }];
    [self _loadConfirmStep3View];
}

- (void)_loadConfirmStep1View {
    _weak(self);
    UIImageView *stepImgV = [[UIImageView alloc] init];
    stepImgV.image = [UIImage imageNamed:@"pc_audit_step1"];
    [self.confirmStep1V addSubview:stepImgV];
    [stepImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.confirmStep1V);
        make.centerX.equalTo(self.confirmStep1V);
        make.width.equalTo(@300);
        make.height.equalTo(@45);
    }];
    
    UILabel *(^labelBlock)(NSString *str, CGFloat fontsize) = ^(NSString *str, CGFloat fontsize) {
        UILabel * l = [[UILabel alloc] init];
        l.textColor = k_COLOR_GALLERY_F;
        l.font = [UIFont boldSystemFontOfSize:fontsize];
        l.text = str;
        return l;
    };
    UILabel *buildTL = labelBlock(@"楼栋:", 15);
    _weak(stepImgV);
    [self.confirmStep1V addSubview:buildTL];
    [buildTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(stepImgV);
        make.top.equalTo(stepImgV.mas_bottom);
        make.left.equalTo(self.confirmStep1V).with.offset(23);
        make.width.equalTo(@63);
        make.height.equalTo(@34);
    }];
    _weak(buildTL);
    self.builtBtn = [[UIButton alloc] init];
    [self.builtBtn setBackgroundImage:[UIImage imageNamed:@"edit_select_btn"] forState:UIControlStateNormal];
    [self.builtBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
    [self.builtBtn setTitle:@"请选择楼栋" forState:UIControlStateNormal];
    self.builtBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.builtBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.builtBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.builtBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self _showSelectionView:self.builtBtn];
    }];
    [self.confirmStep1V addSubview:self.builtBtn];
    [self.builtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(buildTL);
        make.top.bottom.equalTo(buildTL);
        make.left.equalTo(buildTL.mas_right).with.offset(5);
        make.right.equalTo(self.confirmStep1V).with.offset(-23);
    }];
    
    UILabel *unitTL = labelBlock(@"单元:", 15);
    [self.confirmStep1V addSubview:unitTL];
    [unitTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(buildTL);
        make.top.equalTo(buildTL.mas_bottom).with.offset(5);
        make.left.equalTo(self.confirmStep1V).with.offset(23);
        make.width.equalTo(@63);
        make.height.equalTo(@34);
    }];
    _weak(unitTL);
    self.unitBtn = [[UIButton alloc] init];
    [self.unitBtn setBackgroundImage:[UIImage imageNamed:@"edit_select_btn"] forState:UIControlStateNormal];
    [self.unitBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
    [self.unitBtn setTitle:@"请选择单元" forState:UIControlStateNormal];
    self.unitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.unitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.unitBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.unitBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self _showSelectionView:self.unitBtn];
    }];
    [self.confirmStep1V addSubview:self.unitBtn];
    [self.unitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(unitTL);
        make.top.bottom.equalTo(unitTL);
        make.left.equalTo(unitTL.mas_right).with.offset(5);
        make.right.equalTo(self.confirmStep1V).with.offset(-23);
    }];
    UILabel *roomTL = labelBlock(@"房间号:", 15);
    [self.confirmStep1V addSubview:roomTL];
    [roomTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(unitTL);
        make.top.equalTo(unitTL.mas_bottom).with.offset(5);
        make.left.equalTo(self.confirmStep1V).with.offset(23);
        make.width.equalTo(@63);
        make.height.equalTo(@34);
    }];
    _weak(roomTL);
    self.roomBtn = [[UIButton alloc] init];
    [self.roomBtn setBackgroundImage:[UIImage imageNamed:@"edit_select_btn"] forState:UIControlStateNormal];
    [self.roomBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
    [self.roomBtn setTitle:@"请选择房间号" forState:UIControlStateNormal];
    self.roomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.roomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.roomBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.roomBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self _showSelectionView:self.roomBtn];
    }];
    [self.confirmStep1V addSubview:self.roomBtn];
    [self.roomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(roomTL);
        make.top.bottom.equalTo(roomTL);
        make.left.equalTo(roomTL.mas_right).with.offset(5);
        make.right.equalTo(self.confirmStep1V).with.offset(-23);
    }];
    self.auditCheckBoxBtn = [[UIButton alloc] init];
    [self.auditCheckBoxBtn setImage:[UIImage imageNamed:@"pc_audit_checkbox_n"] forState:UIControlStateNormal];
    [self.auditCheckBoxBtn setImage:[UIImage imageNamed:@"pc_audit_checkbox_s"] forState:UIControlStateSelected];
    [self.confirmStep1V addSubview:self.auditCheckBoxBtn];
    
    [self.auditCheckBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(roomTL);
        make.left.equalTo(self.confirmStep1V).with.offset(20);
        make.top.equalTo(roomTL.mas_bottom).with.offset(8);
        make.width.height.equalTo(@38);
    }];
    [self.auditCheckBoxBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self.auditCheckBoxBtn setSelected:!self.auditCheckBoxBtn.isSelected];
    }];
    
    UILabel *readL = labelBlock(@"我已经阅读并同意", 12);
    [self.confirmStep1V addSubview:readL];
    [readL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.bottom.equalTo(self.auditCheckBoxBtn);
        make.left.equalTo(self.auditCheckBoxBtn.mas_right);
        make.width.equalTo(@97);
    }];
    
    UIButton *contractBtn = [[UIButton alloc] init];
    [contractBtn setTitleColor:k_COLOR_BLUE forState:UIControlStateNormal];
    [contractBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [contractBtn setTitle:@"《向日葵智慧社区服务条款》" forState:UIControlStateNormal];
    contractBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [contractBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self performSegueWithIdentifier:@"Segue_PCAudit_Contract" sender:nil];
    }];
    [self.confirmStep1V addSubview:contractBtn];
    _weak(readL);
    [contractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(readL);
        make.top.bottom.equalTo(self.auditCheckBoxBtn);
        make.left.equalTo(readL.mas_right);
        make.right.equalTo(self.builtBtn);
    }];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.backgroundColor = k_COLOR_BLUE;
    nextBtn.layer.cornerRadius = 4;
    [nextBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [nextBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.confirmStep1V addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.confirmStep1V).with.offset(23);
        make.right.equalTo(self.confirmStep1V).with.offset(-23);
        make.top.equalTo(self.auditCheckBoxBtn.mas_bottom).with.offset(10);
        make.height.equalTo(@43);
    }];
    [nextBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if ([MKWStringHelper isNilEmptyOrBlankString:self.selectedBuild]) {
            [SVProgressHUD showErrorWithStatus:@"请选择楼栋"];
            return;
        }
        if ([MKWStringHelper isNilEmptyOrBlankString:self.selectedUnit]) {
            [SVProgressHUD showErrorWithStatus:@"请选择单元"];
            return;
        }
        if ([MKWStringHelper isNilEmptyOrBlankString:self.selectedRoom]) {
            [SVProgressHUD showErrorWithStatus:@"请选择房间号"];
            return;
        }
        if (![self.auditCheckBoxBtn isSelected]) {
            [SVProgressHUD showErrorWithStatus:@"请先同意服务条款"];
            return;
        }
        [SVProgressHUD showInfoWithStatus:@"获取预留手机号码"];
        [[UserModel sharedModel] asyncGetUserAuditTelNumbersWithCommunityId:[CommonModel sharedModel].currentCommunityId build:self.selectedBuild unit:self.selectedUnit room:self.selectedRoom remote:^(NSArray *telNums, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error && [telNums count] > 0) {
                self.isInviteAudit = NO;
                [self.confirmScrollV setContentOffset:ccp(V_W_(self.view), 0) animated:YES];
                self.auditTelNums = telNums;
                self.currentTelIdx = 0;
                [self.telCollectV reloadData];
                return;
            }
            
            GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"获取业主预留手机号失败" andMessage:@"业主无预留手机号码，或是网络出错无法获取。请返回并选择邀请码认证或重试"];
            [alert setCancelButtonWithTitle:@"知道了" actionBlock:nil];
            [alert show];
        }];
    }];
    
    _weak(nextBtn);
    UIButton *inviteBtn = [[UIButton alloc] init];
    inviteBtn.backgroundColor = RGB(83, 137, 209);
    inviteBtn.layer.cornerRadius = 4;
    [inviteBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [inviteBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    inviteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [inviteBtn setTitle:@"邀请码认证" forState:UIControlStateNormal];
    [self.confirmStep1V addSubview:inviteBtn];
    [inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(nextBtn);
        make.left.equalTo(self.confirmStep1V).with.offset(23);
        make.right.equalTo(self.confirmStep1V).with.offset(-23);
        make.top.equalTo(nextBtn.mas_bottom).with.offset(10);
        make.height.equalTo(@43);
    }];
    [inviteBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        self.isInviteAudit = YES;
        [self.confirmScrollV setContentOffset:ccp(V_W_(self.view), 0) animated:YES];
    }];
}

- (void)_loadConfirmStep2View {
    _weak(self);
    UIImageView *stepImgV = [[UIImageView alloc] init];
    stepImgV.image = [UIImage imageNamed:@"pc_audit_step2"];
    [self.confirmStep2V addSubview:stepImgV];
    [stepImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.confirmStep2V);
        make.centerX.equalTo(self.confirmStep2V);
        make.width.equalTo(@300);
        make.height.equalTo(@45);
    }];
    
    UILabel *(^labelBlock)(NSString *str, CGFloat fontsize) = ^(NSString *str, CGFloat fontsize) {
        UILabel * l = [[UILabel alloc] init];
        l.textColor = k_COLOR_GALLERY_F;
        l.font = [UIFont boldSystemFontOfSize:fontsize];
        l.text = str;
        return l;
    };
    _weak(stepImgV);
    self.telRefreshBtn = [[UIButton alloc] init];
    [self.telRefreshBtn setBackgroundImage:[UIImage imageNamed:@"pc_audit_refresh_btn"] forState:UIControlStateNormal];
    [self.confirmStep2V addSubview:self.telRefreshBtn];
    [self.telRefreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(stepImgV);
        make.right.equalTo(self.confirmStep2V).with.offset(-26);
        make.top.equalTo(stepImgV.mas_bottom).with.offset(5);
        make.width.equalTo(@74);
        make.height.equalTo(@25);
    }];
    [self.telRefreshBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        self.currentTelIdx++;
        if (self.currentTelIdx >= [self.auditTelNums count]) {
            self.currentTelIdx = 0;
        }
        [self.telCollectV reloadData];
    }];
    self.telTL = labelBlock(@"请补全房屋业主预留手机号:", 12);
    [self.confirmStep2V addSubview:self.telTL];
    [self.telTL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.telRefreshBtn);
        make.left.equalTo(self.confirmStep2V).with.offset(25);
        make.right.equalTo(self.telRefreshBtn.mas_left);
        make.height.equalTo(self.telRefreshBtn);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(1, 2, 1, 2);
    CGFloat itemWidth = ([[UIScreen mainScreen]bounds].size.width - 66)/11;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = ccs(itemWidth, 55);
    self.telCollectV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.telCollectV registerClass:[AuditTelNumCell class] forCellWithReuseIdentifier:[AuditTelNumCell reuseIdentify]];
    self.telCollectV.scrollEnabled = NO;
    self.telCollectV.showsVerticalScrollIndicator = NO;
    self.telCollectV.showsHorizontalScrollIndicator = NO;
    self.telCollectV.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pc_audit_tel_bg"]];
    [self.telCollectV withBlockForItemNumber:^NSInteger(UICollectionView *view, NSInteger section) {
        return 11;
    }];
    [self.telCollectV withBlockForItemCell:^UICollectionViewCell *(UICollectionView *view, NSIndexPath *path) {
        AuditTelNumCell *cell = [view dequeueReusableCellWithReuseIdentifier:[AuditTelNumCell reuseIdentify] forIndexPath:path];
        if (!cell) {
            cell = [[AuditTelNumCell alloc] init];
        }
        cell.didEndEditBlock = ^(){
            if (path.row<8) {
                AuditTelNumCell *cell = (AuditTelNumCell*)[view cellForItemAtIndexPath:[NSIndexPath indexPathForItem:path.row+1 inSection:0]];
                [cell becomeFirstResponder];
            }
        };
        if ([self.auditTelNums count] <= 0 || self.currentTelIdx >= [self.auditTelNums count]) {
            cell.shouldEdit = NO;
            return cell;
        }
        
        if (path.row>=5&&path.row<=8) {
            cell.shouldEdit = YES;
        }
        else {
            cell.shouldEdit = NO;
            cell.telNum = [[self.auditTelNums[self.currentTelIdx] substringFromIndex:path.row] substringToIndex:1];
        }
        
        return cell;
    }];
    
    [self.confirmStep2V addSubview:self.telCollectV];
    [self.telCollectV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.telRefreshBtn.mas_bottom).with.offset(5);
        make.left.equalTo(self.confirmStep2V).with.offset(26);
        make.right.equalTo(self.confirmStep2V).with.offset(-26);
        make.height.equalTo(@55);
    }];
    
    self.inviteCodeT = [[UITextField alloc] init];
    self.inviteCodeT.font = [UIFont boldSystemFontOfSize:20];
    self.inviteCodeT.textColor = k_COLOR_GALLERY_F;
    self.inviteCodeT.background = [UIImage imageNamed:@"edit_filed_bg"];
    self.inviteCodeT.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.inviteCodeT.textAlignment = NSTextAlignmentCenter;
    [self.inviteCodeT  withBlockForShouldReturn:^BOOL(UITextField *view) {
        [view resignFirstResponder];
        return YES;
    }];
    [self.inviteCodeT  withBlockForDidBeginEditing:^(UITextField *view) {
        _strong(self);
        self.focusedT = view;
    }];
    [self.confirmStep2V addSubview:self.inviteCodeT];
    [self.inviteCodeT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.telRefreshBtn.mas_bottom).with.offset(5);
        make.left.equalTo(self.confirmStep2V).with.offset(26);
        make.right.equalTo(self.confirmStep2V).with.offset(-26);
        make.height.equalTo(@55);
    }];
    
    self.stepInfo1L = labelBlock(@"如已更换手机号码,需要业主前往物业管理中心更新", 12);
    self.stepInfo1L.textAlignment = NSTextAlignmentCenter;
    self.stepInfo2L = labelBlock(@"如已无法获取业主手机号,可返回使用业主邀请码认证", 12);
    self.stepInfo2L.textAlignment = NSTextAlignmentCenter;
    [self.confirmStep2V addSubview:self.stepInfo1L];
    [self.stepInfo1L mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.telCollectV.mas_bottom).with.offset(5);
        make.left.equalTo(self.confirmStep2V).with.offset(26);
        make.right.equalTo(self.confirmStep2V).with.offset(-26);
        make.height.equalTo(@12);
    }];
    [self.confirmStep2V addSubview:self.stepInfo2L];
    [self.stepInfo2L mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.stepInfo1L.mas_bottom).with.offset(2);
        make.left.right.height.equalTo(self.stepInfo1L);
    }];
    
    UILabel *roleL = labelBlock(@"您在家庭中的角色:", 15);
    [self.confirmStep2V addSubview:roleL];
    [roleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.stepInfo2L.mas_bottom).with.offset(10);
        make.left.equalTo(self.telCollectV);
        make.width.equalTo(@130);
        make.height.equalTo(@34);
    }];
    
    self.roleBtn = [[UIButton alloc] init];
    [self.roleBtn setBackgroundImage:[UIImage imageNamed:@"edit_select_btn"] forState:UIControlStateNormal];
    [self.roleBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
    [self.roleBtn setTitle:@"请选择角色" forState:UIControlStateNormal];
    self.roleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.roleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.roleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.roleBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self _showSelectionView:self.roleBtn];
    }];
    _weak(roleL);
    [self.confirmStep2V addSubview:self.roleBtn];
    [self.roleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(roleL);
        make.top.bottom.equalTo(roleL);
        make.left.equalTo(roleL.mas_right).with.offset(5);
        make.right.equalTo(self.telCollectV);
    }];
    
    UIButton *(^ownershipBtnBlock)(NSString *title) = ^(NSString *title){
        UIButton *b = [[UIButton alloc] init];
        [b setImage:[UIImage imageNamed:@"pc_audit_owner_btn_n"] forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:@"pc_audit_owner_btn_s"] forState:UIControlStateSelected];
        [b setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
        [b setTitle:title forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        b.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        b.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        return b;
    };
    self.ownHouseBtn = ownershipBtnBlock(@"房产证在我名下");
    [self.ownHouseBtn setSelected:YES];
    self.ownerShipOfHouse = @"房产证在我名下";
    [self.ownHouseBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        self.ownerShipOfHouse = self.ownHouseBtn.titleLabel.text;
        if ([self.ownHouseBtn isSelected]) {
            return;
        }
        
        [self.ownHouseBtn setSelected:YES];
        [self.ownerFamilyBtn setSelected:NO];
        [self.rentHouseBtn setSelected:NO];
    }];
    [self.confirmStep2V addSubview:self.ownHouseBtn];
    [self.ownHouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.telCollectV);
        make.top.equalTo(self.roleBtn.mas_bottom).with.offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@150);
    }];
    
    self.ownerFamilyBtn = ownershipBtnBlock(@"我是业主家属");
    [self.ownerFamilyBtn setSelected:NO];
    [self.ownerFamilyBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        self.ownerShipOfHouse = self.ownerFamilyBtn.titleLabel.text;
        if ([self.ownerFamilyBtn isSelected]) {
            return;
        }
        
        [self.ownHouseBtn setSelected:NO];
        [self.ownerFamilyBtn setSelected:YES];
        [self.rentHouseBtn setSelected:NO];
    }];
    [self.confirmStep2V addSubview:self.ownerFamilyBtn];
    [self.ownerFamilyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.telCollectV);
        make.top.equalTo(self.ownHouseBtn.mas_bottom).with.offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@150);
    }];
    
    self.rentHouseBtn = ownershipBtnBlock(@"我是住户");
    [self.rentHouseBtn setSelected:NO];
    [self.rentHouseBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        self.ownerShipOfHouse = self.rentHouseBtn.titleLabel.text;
        if ([self.rentHouseBtn isSelected]) {
            return;
        }
        
        [self.ownHouseBtn setSelected:NO];
        [self.ownerFamilyBtn setSelected:NO];
        [self.rentHouseBtn setSelected:YES];
    }];
    [self.confirmStep2V addSubview:self.rentHouseBtn];
    [self.rentHouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.telCollectV);
        make.top.equalTo(self.ownerFamilyBtn.mas_bottom).with.offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@150);
    }];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.backgroundColor = k_COLOR_BLUE;
    nextBtn.layer.cornerRadius = 4;
    [nextBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if (self.isInviteAudit) {
            self.inviteCode = [MKWStringHelper trimWithStr:self.inviteCodeT.text];
            if ([MKWStringHelper isNilEmptyOrBlankString:self.inviteCode]) {
                [SVProgressHUD showErrorWithStatus:@"请输入邀请码"];
                return;
            }
        }
        else {
            NSMutableString *telNum = [@"" mutableCopy];
            for (NSInteger i = 0; i < 11; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
                AuditTelNumCell *cell = (AuditTelNumCell*)[self.telCollectV cellForItemAtIndexPath:path];
                [telNum appendString:cell.telNum];
            }
            if (![telNum isEqualToString:self.auditTelNums[self.currentTelIdx]]) {
                [SVProgressHUD showErrorWithStatus:@"预留手机号码不正确"];
                return;
            }
        }
        
        if ([MKWStringHelper isNilEmptyOrBlankString:self.roleInFamily]) {
            [SVProgressHUD showErrorWithStatus:@"请选择家庭角色"];
            return;
        }
        
        [self.confirmScrollV setContentOffset:ccp(2*V_W_(self.view), 0) animated:YES];
    }];
    [self.confirmStep2V addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.rentHouseBtn.mas_bottom).with.offset(10);
        make.left.right.equalTo(self.telCollectV);
        make.height.equalTo(@43);
    }];
    
    UIButton *preBtn = [[UIButton alloc] init];
    preBtn.backgroundColor = RGB(83, 137, 209);
    preBtn.layer.cornerRadius = 4;
    [preBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [preBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [preBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self.confirmScrollV setContentOffset:ccp(0, 0) animated:YES];
    }];
    [self.confirmStep2V addSubview:preBtn];
    _weak(nextBtn);
    [preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(nextBtn);
        make.top.equalTo(nextBtn.mas_bottom).with.offset(5);
        make.left.right.equalTo(self.telCollectV);
        make.height.equalTo(@43);
    }];
}

- (void)_loadConfirmStep3View {
    _weak(self);
    UIImageView *stepImgV = [[UIImageView alloc] init];
    stepImgV.image = [UIImage imageNamed:@"pc_audit_step3"];
    [self.confirmStep3V addSubview:stepImgV];
    [stepImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.confirmStep3V);
        make.centerX.equalTo(self.confirmStep3V);
        make.width.equalTo(@300);
        make.height.equalTo(@45);
    }];

    UILabel *(^labelBlock)(NSString *str, CGFloat fontsize) = ^(NSString *str, CGFloat fontsize) {
        UILabel * l = [[UILabel alloc] init];
        l.textColor = k_COLOR_GALLERY_F;
        l.font = [UIFont boldSystemFontOfSize:fontsize];
        l.text = str;
        return l;
    };
    
    UITextField *(^textFiledBlock)(NSString *placeholder) = ^(NSString *placeholder){
        UITextField *f = [[UITextField alloc] init];
        f.font = [UIFont boldSystemFontOfSize:14];
        f.textColor = k_COLOR_GALLERY_F;
        f.background = [UIImage imageNamed:@"edit_filed_bg"];
        f.placeholder = placeholder;
        [f withBlockForShouldReturn:^BOOL(UITextField *view) {
            [view resignFirstResponder];
            return YES;
        }];
        [f withBlockForDidBeginEditing:^(UITextField *view) {
            _strong(self);
            self.focusedT = view;
        }];
        return f;
    };
    _weak(stepImgV);
    UILabel *nameL = labelBlock(@"姓名:", 14);
    [self.confirmStep3V addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(stepImgV);
        make.top.equalTo(stepImgV.mas_bottom).with.offset(5);
        make.left.equalTo(self.confirmStep3V).with.offset(25);
        make.width.equalTo(@62);
        make.height.equalTo(@35);
    }];
    self.auditNameT = textFiledBlock([UserModel sharedModel].currentNormalUser.trueName);
    self.auditNameT.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.auditNameT.returnKeyType = UIReturnKeyDone;
    [self.confirmStep3V addSubview:self.auditNameT];
    _weak(nameL);
    [self.auditNameT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(nameL);
        make.top.bottom.equalTo(nameL);
        make.left.equalTo(nameL.mas_right);
        make.right.equalTo(self.confirmStep3V).with.offset(-24);
    }];
    UILabel *sexL = labelBlock(@"性别:", 14);
    [self.confirmStep3V addSubview:sexL];
    [sexL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.auditNameT.mas_bottom).with.offset(5);
        make.left.equalTo(self.confirmStep3V).with.offset(25);
        make.width.equalTo(@62);
        make.height.equalTo(@35);
    }];
    self.auditSexBtn = [[UIButton alloc] init];
    [self.auditSexBtn setBackgroundImage:[UIImage imageNamed:@"edit_select_btn"] forState:UIControlStateNormal];
    [self.auditSexBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
    [self.auditSexBtn setTitle:@"请选择性别" forState:UIControlStateNormal];
    self.auditSexBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.auditSexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.auditSexBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.auditSexBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self _showSelectionView:self.auditSexBtn];
    }];
    _weak(sexL);
    [self.confirmStep3V addSubview:self.auditSexBtn];
    [self.auditSexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(sexL);
        make.top.bottom.equalTo(sexL);
        make.left.right.equalTo(self.auditNameT);
    }];
    UILabel *phoneL = labelBlock(@"手机号:", 14);
    [self.confirmStep3V addSubview:phoneL];
    [phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(sexL);
        make.top.equalTo(sexL.mas_bottom).with.offset(5);
        make.left.equalTo(self.confirmStep3V).with.offset(25);
        make.width.equalTo(@62);
        make.height.equalTo(@35);
    }];
    _weak(phoneL);
    _getVerifyBtn = [[UIButton alloc] init];
    _getVerifyBtn.backgroundColor = k_COLOR_BLUE;
    _getVerifyBtn.layer.cornerRadius = 4;
    [_getVerifyBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [_getVerifyBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [_getVerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerifyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_getVerifyBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        NSString *phoneNum = [MKWStringHelper trimWithStr:self.auditTelT.text];
        if ([MKWStringHelper isNilEmptyOrBlankString:phoneNum]) {
            phoneNum = [UserModel sharedModel].currentNormalUser.userName;
        }
        _weak(self);
        __block NSInteger second = 20;
        if ([MKWStringHelper isVAlidatePhoneNumber:phoneNum]) {
            [[UserModel sharedModel] asyncCheckCodeWithPhoneNumber:phoneNum remoteBlock:^(NSString *code, NSString *msg, NSError *error) {
                _strong(self);
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                    self.checkCode = code;
                    [self.getVerifyBtn setEnabled:NO];
                    [self.getVerifyBtn setTitle:@"(20)秒后再次获取" forState:UIControlStateDisabled];
                    
                    self.getVerifyBtn.backgroundColor = [k_COLOR_BLUE colorWithAlphaComponent:0.8];
                    // start timing after 1 minuts enable again.
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES action:^(NSTimer *timer) {
                        _strong(self);
                        if (second > 0) {
                            [self.getVerifyBtn setTitle:[NSString stringWithFormat:@"(%ld)秒后再次获取", (long)second] forState:UIControlStateDisabled];
                            second -= 1;
                        }
                        else {
                            [self.getVerifyBtn setEnabled:YES];
                            [self.getVerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                            self.getVerifyBtn.backgroundColor = k_COLOR_BLUE;
                            [timer invalidate];
                        }
                    }];
                }
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"手机号码错误"];
        }
    }];
    [self.confirmStep3V addSubview:_getVerifyBtn];
    [_getVerifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(phoneL);
        make.top.bottom.equalTo(phoneL);
        make.right.equalTo(self.auditNameT);
        make.width.equalTo(@94);
    }];
    self.auditTelT = textFiledBlock([UserModel sharedModel].currentNormalUser.userName);
    [self.confirmStep3V addSubview:self.auditTelT];
    [self.auditTelT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(phoneL);
        _strong(self);
        make.top.bottom.equalTo(phoneL);
        make.left.equalTo(phoneL.mas_right);
        make.right.equalTo(self.getVerifyBtn.mas_left).with.offset(-2);
    }];
    
    UILabel *verifyL = labelBlock(@"请输入手机验证码", 14);
    [self.confirmStep3V addSubview:verifyL];
    [verifyL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(phoneL);
        make.right.equalTo(self.auditNameT);
        make.top.equalTo(phoneL.mas_bottom).with.offset(5);
        make.height.equalTo(@35);
        make.width.equalTo(@120);
    }];
    _weak(verifyL);
    self.auditVerifyT = textFiledBlock(@"");
    [self.confirmStep3V addSubview:self.auditVerifyT];
    [self.auditVerifyT mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(verifyL);
        make.top.bottom.equalTo(verifyL);
        make.left.equalTo(self.auditNameT);
        make.right.equalTo(verifyL.mas_left).with.offset(-2);
    }];
    
    UIButton *auditbtn = [[UIButton alloc] init];
    auditbtn.backgroundColor = k_COLOR_BLUE;
    auditbtn.layer.cornerRadius = 4;
    [auditbtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [auditbtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [auditbtn setTitle:@"立即验证" forState:UIControlStateNormal];
    [auditbtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        if ([MKWStringHelper isNilEmptyOrBlankString:self.selectedBuild]) {
            [SVProgressHUD showErrorWithStatus:@"楼栋信息不正确"];
            return;
        }
        if ([MKWStringHelper isNilEmptyOrBlankString:self.selectedUnit]) {
            [SVProgressHUD showErrorWithStatus:@"单元信息不正确"];
            return;
        }
        if ([MKWStringHelper isNilEmptyOrBlankString:self.selectedRoom]) {
            [SVProgressHUD showErrorWithStatus:@"房间号不正确"];
            return;
        }
        if ([MKWStringHelper isNilEmptyOrBlankString:self.roleInFamily]) {
            [SVProgressHUD showErrorWithStatus:@"家庭角色不正确"];
            return;
        }
        if ([MKWStringHelper isNilEmptyOrBlankString:self.ownerShipOfHouse]) {
            [SVProgressHUD showErrorWithStatus:@"房屋所属信息不正确"];
            return;
        }
        if ([self.auditVerifyT.text compare:self.checkCode options:NSCaseInsensitiveSearch] != NSOrderedSame) {
            [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
            return;
        }
        NSString *trueName = [MKWStringHelper trimWithStr:self.auditNameT.text];
        if ([MKWStringHelper isNilEmptyOrBlankString:trueName]) {
            [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
            return;
        }
        if ([self.auditSex integerValue]!=1 && [self.auditSex integerValue]!=2) {
            [SVProgressHUD showErrorWithStatus:@"请选择性别"];
            return;
        }
        
        [[UserModel sharedModel] asyncAuditWithInfoDic:@{@"userInfo":@{@"TrueName":trueName,@"CommunityId":[CommonModel sharedModel].currentCommunityId,@"CommunityName":[[CommonModel sharedModel] currentCommunityName], @"Building":self.selectedBuild, @"Unit":self.selectedUnit,@"Room":self.selectedRoom,@"Sex":self.auditSex,@"RoleName":self.roleInFamily,@"RoomProperty":self.ownerShipOfHouse,@"InvitationNum":(self.isInviteAudit?self.inviteCode:@""),@"AuditPhoneNum":(self.isInviteAudit?@"":self.auditTelNums[self.currentTelIdx])}} remoteBlock:^(UserInfo *user, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
                return;
            }
            [UserPointHandler addUserPointWithType:CommunityAudit showInfo:NO];
            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            [self.confirmInfoV setHidden:NO];
            [self.confirmScrollV setHidden:YES];
            [self.contentV bringSubviewToFront:self.confirmInfoV];
            [self.contentV mas_remakeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.left.top.right.bottom.equalTo(self.contentScrollV);
                make.width.equalTo(self.view);
                make.height.equalTo(@498);
            }];
            [self.view layoutIfNeeded];
            [self _loadUserAuditInfo];
        }];
    }];
    [self.confirmStep3V addSubview:auditbtn];
    [auditbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(nameL);
        make.top.equalTo(self.auditVerifyT.mas_bottom).with.offset(10);
        make.left.equalTo(nameL);
        make.right.equalTo(self.auditNameT);
        make.height.equalTo(@43);
    }];
    
    UIButton *preBtn = [[UIButton alloc] init];
    preBtn.backgroundColor = RGB(83, 137, 209);
    preBtn.layer.cornerRadius = 4;
    [preBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
    [preBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [preBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [preBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        [self.confirmScrollV setContentOffset:ccp(V_W_(self.view), 0) animated:YES];
    }];
    [self.confirmStep3V addSubview:preBtn];
    _weak(auditbtn);
    [preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(auditbtn);
        make.top.equalTo(auditbtn.mas_bottom).with.offset(5);
        make.left.right.height.equalTo(auditbtn);
    }];
}

- (void)_layoutCodingViews {
    if (![self.contentScrollV superview]) {
        _weak(self);
        UIView *tmp = [[UIView alloc] init];
        tmp.backgroundColor = k_COLOR_CLEAR;
        [self.view addSubview:tmp];
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@(self.topLayoutGuide.length));
        }];
        
        [self.view addSubview:self.contentScrollV];
        [self.contentScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(self.topLayoutGuide.length);
            make.bottom.equalTo(self.view).with.offset(-self.bottomLayoutGuide.length);
        }];
        
        if ([[UserModel sharedModel].currentNormalUser.isAudit boolValue]) {
            [self.contentV bringSubviewToFront:self.confirmInfoV];
            [self.confirmScrollV setHidden:YES];
            [self.confirmInfoV setHidden:NO];
            [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.left.top.right.bottom.equalTo(self.contentScrollV);
                make.width.equalTo(self.view);
                make.height.equalTo(@498);
            }];
        }
        else {
            [self.contentV bringSubviewToFront:self.confirmScrollV];
            [self.confirmInfoV setHidden:YES];
            [self.confirmScrollV setHidden:NO];
            [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.left.top.right.bottom.equalTo(self.contentScrollV);
                make.width.equalTo(self.view);
                make.height.equalTo(@594);
            }];
        }
        
    }
}


@end
