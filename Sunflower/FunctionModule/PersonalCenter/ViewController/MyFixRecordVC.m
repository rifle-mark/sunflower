//
//  MyFixRecordVC.m
//  Sunflower
//
//  Created by makewei on 15/6/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MyFixRecordVC.h"

#import "UserModel.h"
#import "FixIssue.h"
#import "WeiCommentCell.h"
#import "CommonModel.h"
#import "PictureShowVC.h"

@interface MyFixIssueCell : UITableViewCell

@property(nonatomic,strong)UIView           *contentV;
@property(nonatomic,strong)UIButton         *selectBtn;
@property(nonatomic,strong)UIButton         *deleteBtn;
@property(nonatomic,strong)UIView           *showV;
@property(nonatomic,strong)UILabel          *detailL;
@property(nonatomic,strong)UICollectionView *picsV;
@property(nonatomic,strong)UILabel          *timeL;
@property(nonatomic,strong)UILabel          *stateL;

@property(nonatomic,strong)FixIssueInfo     *issue;
@property(nonatomic,assign)BOOL             isIssueEdit;
@property(nonatomic,strong)NSArray          *picUrlVArray;

@property(nonatomic,copy)void(^picShowBlock)(NSArray *picUrlArray, NSInteger index);
@property(nonatomic,copy)void(^issueSelectBlock)(FixIssueInfo *issue, BOOL isSelected);
@property(nonatomic,copy)void(^issueDeleteBlock)(FixIssueInfo *issue);

+ (NSString *)reuseIdentify;
+ (CGFloat)heightOfSelfWithIssue:(FixIssueInfo *)issue;
@end

@implementation MyFixIssueCell

+ (NSString *)reuseIdentify {
    return @"MyFixIssueCellIdentify";
}

+ (CGFloat)heightOfSelfWithIssue:(FixIssueInfo *)issue {
    return [MyFixIssueCell _detailHeightWithIssue:issue]+15+[MyFixIssueCell _picHeightWithIssue:issue]+15+37;
}

+ (CGFloat)_detailHeightWithIssue:(FixIssueInfo *)issue {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 40;
    return [[MyFixIssueCell _detailAttributedStringWithIssue:issue] boundingRectWithSize:ccs(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

+ (NSAttributedString *)_detailAttributedStringWithIssue:(FixIssueInfo *)issue {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = NSTextAlignmentLeft;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.lineHeightMultiple = 1;
    ps.lineSpacing = 4;
    NSDictionary *att = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps};
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:issue.content attributes:att];
    return str;
}

+ (CGFloat)_picHeightWithIssue:(FixIssueInfo *)issue {
    if ([MKWStringHelper isNilEmptyOrBlankString:issue.images]) {
        return 0;
    }
    CGFloat totalwidth = [UIScreen mainScreen].bounds.size.width - 100;
    return totalwidth / 3;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _isIssueEdit = NO;
        _weak(self);
        self.contentV = [[UIView alloc] init];
        self.contentV.clipsToBounds = YES;
        [self.contentView addSubview:self.contentV];
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(13);
            make.right.equalTo(self.contentView).with.offset(-13);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.selectBtn = [[UIButton alloc] init];
        [self.selectBtn setImage:[UIImage imageNamed:@"mycell_select_btn_n"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"mycell_select_btn_h"] forState:UIControlStateHighlighted];
        [self.selectBtn setImage:[UIImage imageNamed:@"mycell_select_btn_s"] forState:UIControlStateSelected];
        [self.contentV addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.bottom.equalTo(self.contentV);
            make.width.equalTo(@37);
        }];
        [self.selectBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.selectBtn setSelected:!self.selectBtn.isSelected];
            GCBlockInvoke(self.issueSelectBlock, self.issue, self.selectBtn.isSelected);
        }];
        
        self.deleteBtn = [[UIButton alloc] init];
        self.deleteBtn.backgroundColor = RGB(255, 153, 153);
        [self.deleteBtn setImage:[UIImage imageNamed:@"mycell_delete_btn"] forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        self.deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-22, 15, 0, 0);
        self.deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(22, -15, 0, 0);
        self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.contentV addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.top.bottom.equalTo(self.contentV);
            make.width.equalTo(@50);
        }];
        [self.deleteBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.issueDeleteBlock, self.issue);
        }];
        
        self.showV = [[UIView alloc] init];
        self.showV.backgroundColor = k_COLOR_WHITE;
        [self.contentV addSubview:self.showV];
        [self.showV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentV);
        }];
        
        self.detailL = [[UILabel alloc] init];
        
        UICollectionViewFlowLayout *picLayout = [[UICollectionViewFlowLayout alloc] init];
        picLayout.minimumLineSpacing = 5;
        picLayout.minimumInteritemSpacing = 5;
        picLayout.headerReferenceSize = ccs(0, 0);
        picLayout.footerReferenceSize = ccs(0, 0);
        picLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat totalwidth = [UIScreen mainScreen].bounds.size.width - 100;
        CGFloat picWH = totalwidth / 3;
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
            
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:self.picUrlVArray[path.row]] placeholderImage:[UIImage imageNamed:@"default_avatar"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _strong(cell);
                if (!error) {
                    cell.imgV.image = image;
                }
            }];
            
            return cell;
        }];
        [self.picsV withBlockForItemDidSelect:^(UICollectionView *view, NSIndexPath *path) {
            _strong(self);
            GCBlockInvoke(self.picShowBlock, self.picUrlVArray, path.item);
        }];
        
        self.timeL = [[UILabel alloc] init];
        self.timeL.textColor = k_COLOR_GALLERY_F;
        self.timeL.font = [UIFont boldSystemFontOfSize:12];
        self.timeL.textAlignment = NSTextAlignmentRight;
        
        self.stateL = [[UILabel alloc] init];
        self.stateL.font = [UIFont boldSystemFontOfSize:12];
        
        [self.showV addSubview:self.detailL];
        [self.showV addSubview:self.picsV];
        [self.showV addSubview:self.timeL];
        [self.showV addSubview:self.stateL];
        
        UISwipeGestureRecognizer *lswip = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            if (self.isIssueEdit) {
                return;
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    _strong(self);
                    make.left.equalTo(self.contentV).with.offset(-50);
                    make.top.bottom.equalTo(self.contentV);
                    make.width.equalTo(self.contentV);
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }];
        lswip.numberOfTouchesRequired = 1;
        lswip.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.showV addGestureRecognizer:lswip];
        
        UISwipeGestureRecognizer *rswip = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            if (self.isIssueEdit) {
                return;
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    _strong(self);
                    make.left.equalTo(self.contentV).with.offset(0);
                    make.top.bottom.equalTo(self.contentV);
                    make.width.equalTo(self.contentV);
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }];
        rswip.numberOfTouchesRequired = 1;
        rswip.direction = UISwipeGestureRecognizerDirectionRight;
        [self.showV addGestureRecognizer:rswip];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = k_COLOR_GALLERY;
        [self.contentV addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.bottom.right.equalTo(self.contentV);
            make.height.equalTo(@1);
        }];
        
        [self _setupObserver];
    }
    
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"issue" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        self.timeL.text = [self.issue.createDate dateSplitBySplash];
        self.detailL.attributedText = [[self class] _detailAttributedStringWithIssue:self.issue];
        if (![MKWStringHelper isNilEmptyOrBlankString:self.issue.images]) {
            self.picUrlVArray = [self.issue.images componentsSeparatedByString:@","];
        }
        self.stateL.text = [self.issue.hasDeleted boolValue]?@"已处理":@"等待处理中...";
        self.stateL.textColor = [self.issue.hasDeleted boolValue]?k_COLOR_RED:k_COLOR_BLUE;
        [self.picsV reloadData];
        
        [self.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.showV).with.offset(15);
            make.left.equalTo(self.showV).with.offset(20);
            make.right.equalTo(self.showV).with.offset(-20);
            make.height.equalTo(@([[self class] _detailHeightWithIssue:self.issue]));
        }];
        
        [self.picsV mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.detailL.mas_bottom).with.offset(5);
            make.left.right.equalTo(self.detailL);
            if ([self.picUrlVArray count] > 0) {
                make.height.equalTo(@([[self class] _picHeightWithIssue:self.issue]));
            }
            else {
                make.height.equalTo(@0);
            }
        }];
        
        [self.timeL mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.picsV.mas_bottom).with.offset(10);
            make.right.equalTo(self.detailL);
            make.height.equalTo(@12);
            make.width.equalTo(@150);
        }];
        
        [self.stateL mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.timeL);
            make.left.equalTo(self.detailL);
            make.right.equalTo(self.timeL.mas_left);
            make.height.equalTo(self.timeL);
        }];
        
        [self layoutIfNeeded];
    }];
    
    [self startObserveObject:self forKeyPath:@"isIssueEdit" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _strong(self);
            [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentV).with.offset(self.isIssueEdit?37:0);
                make.top.bottom.width.equalTo(self.contentV);
            }];
            
            [self layoutIfNeeded];
        }];
    }];
}

- (BOOL)isIssueSelected {
    return [self.selectBtn isSelected];
}

- (void)setIsIssueSelected:(BOOL)isHouseSelected {
    [self.selectBtn setSelected:isHouseSelected];
}

@end

@interface MyFixRecordVC ()

@property(nonatomic,strong)UITableView      *fixTableV;

@property(nonatomic,strong)NSArray          *fixList;
@property(nonatomic,strong)NSNumber         *currentPage;
@property(nonatomic,strong)NSNumber         *pageSize;

@property(nonatomic,strong)NSMutableArray       *selectedIssueList;
@property(nonatomic,assign)BOOL                 isEdit;

@end

@implementation MyFixRecordVC

- (NSString *)umengPageName {
    return @"我的维修保养";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_MyFixRecord";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_edit_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(_issueEditTap:)];
    editItem.tintColor = k_COLOR_WHITE;
    self.navigationItem.rightBarButtonItem = editItem;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    self.selectedIssueList = [@[] mutableCopy];
    
    self.pageSize = @20;
    [self _setupObserver];
    
    [self _refreshFixRecord];
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
    if ([segue.identifier isEqualToString:@"Segue_MyFixRecord_PictureShow"]) {
        PictureShowVC *vc = segue.destinationViewController;
        vc.picUrlArray = [sender objectAtIndex:0];
        vc.currentIndex = [[sender objectAtIndex:1] unsignedIntegerValue];
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Coding Views

- (void)_loadCodingViews {
    if (self.fixTableV) {
        return;
    }
    
    self.fixTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        [v registerClass:[MyFixIssueCell class] forCellReuseIdentifier:[MyFixIssueCell reuseIdentify]];
        
        _weak(self);
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _refreshFixRecord];
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMoreFixRecord];
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.fixList count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            _strong(self);
            return [MyFixIssueCell heightOfSelfWithIssue:self.fixList[path.row]];
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            MyFixIssueCell *cell = [view dequeueReusableCellWithIdentifier:[MyFixIssueCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[MyFixIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyFixIssueCell reuseIdentify]];
            }
            
            cell.issue = self.fixList[path.row];
            [cell setIsIssueEdit:self.isEdit];
            cell.picShowBlock = ^(NSArray *picUrlArray, NSInteger index){
                if (picUrlArray)
                    [self performSegueWithIdentifier:@"Segue_MyFixRecord_PictureShow" sender:@[picUrlArray, @(index)]];
            };
            cell.issueDeleteBlock = ^(FixIssueInfo *issue){
                _strong(self);
                [[UserModel sharedModel] asyncFixRecordDeleteWithIdArray:@[issue.issueId] remoteBlock:^(BOOL isSuccess, NSError *error) {
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [self _loadFixRecordAtPage:@1 pageSize:self.pageSize];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:error.domain];
                    }
                }];
            };
            cell.issueSelectBlock = ^(FixIssueInfo *coupon, BOOL isSelected) {
                _strong(self);
                if (isSelected) {
                    [self.selectedIssueList addObject:coupon];
                    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_delete"]];
                }
                else {
                    [self.selectedIssueList removeObject:coupon];
                    if ([self.selectedIssueList count] == 0) {
                        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_cancel"]];
                    }
                }
            };
            return cell;
        }];
        v;
    });
}

- (void)_layoutCodingViews {
    if ([self.fixTableV superview]) {
        return;
    }
    
    _weak(self);
    UIView *topTmp = [[UIView alloc] init];
    topTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:topTmp];
    [topTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.top.equalTo(self.view);
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
    
    _weak(topTmp);
    _weak(botTmp);
    [self.view addSubview:self.fixTableV];
    [self.fixTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(topTmp);
        _strong(botTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];
}

#pragma mark - data
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"fixList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.fixTableV reloadData];
    }];
}

- (void)_issueEditTap:(id)sender {
    __block BOOL edit = !self.isEdit;
    _weak(self);
    if (!edit && [self.selectedIssueList count] > 0) {
        NSMutableArray *issueIdArray = [[NSMutableArray alloc] initWithCapacity:[self.selectedIssueList count]];
        for (FixIssueInfo *info in self.selectedIssueList) {
            [issueIdArray addObject:info.issueId];
        }
        
        [[UserModel sharedModel] asyncFixRecordDeleteWithIdArray:issueIdArray remoteBlock:^(BOOL isSuccess, NSError *error) {
            _strong(self);
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"成功删除"];
                [self _loadFixRecordAtPage:@1 pageSize:self.pageSize];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"操作失败"];
            }
            [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"navi_edit_btn"]];
            [self _setIssueListEdit:edit];
            self.isEdit = edit;
            [self.selectedIssueList removeAllObjects];
        }];
    }
    else if (!edit) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"navi_edit_btn"]];
        [self _setIssueListEdit:edit];
        self.isEdit = edit;
    }
    
    if (edit) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_cancel"]];
        [self _setIssueListEdit:edit];
        self.isEdit = edit;
    }
}

- (void)_setIssueListEdit:(BOOL)edit {
    for (MyFixIssueCell *cell in [self.fixTableV visibleCells]) {
        cell.isIssueSelected = NO;
        cell.isIssueEdit = edit;
        [self.selectedIssueList removeAllObjects];
    }
}

- (void)_refreshFixRecord {
    [self _loadFixRecordAtPage:@1 pageSize:self.pageSize];
}

- (void)_loadMoreFixRecord {
    [self _loadFixRecordAtPage:@([self.currentPage integerValue]+1) pageSize:self.pageSize];
}

- (void)_loadFixRecordAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    if (![UserModel sharedModel].isNormalLogined) {
        return;
    }
    [[UserModel sharedModel] asyncFixRecordListWithCommunityId:[CommonModel sharedModel].currentCommunityId page:page pageSize:pageSize remoteBlock:^(NSArray *list, NSNumber *cPage, NSError *error) {
        if ([self.fixTableV.header isRefreshing]) {
            [self.fixTableV.header endRefreshing];
        }
        if ([self.fixTableV.footer isRefreshing]) {
            [self.fixTableV.footer endRefreshing];
        }
        
        if (!error) {
            if ([cPage integerValue] == 1) {
                self.currentPage = cPage;
                self.fixList = list;
            }
            else {
                if ([list count] > 0) {
                    self.currentPage = page;
                    NSMutableArray *tmp = [self.fixList mutableCopy];
                    [tmp addObjectsFromArray:list];
                    self.fixList = tmp;
                }
            }
        }
    }];
}

@end
