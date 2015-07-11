//
//  WeCommentListVC.m
//  Sunflower
//
//  Created by makewei on 15/6/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "WeCommentListVC.h"
#import "WeiCommentDetailVC.h"
#import "WeiCommentCell.h"
#import "PictureShowVC.h"

#import "CommunityLifeModel.h"
#import "CommonModel.h"
#import "UserModel.h"

#import "WeiCommentAction.h"
#import "MKWModelHandler.h"

@interface WeCommentListVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;
@property(nonatomic,strong)UITableView      *commentTableV;
@property(nonatomic,strong)UIImageView      *actionV;
@property(nonatomic,strong)UIImageView      *deleteActionV;

@property(nonatomic,strong)NSArray          *commentList;
@property(nonatomic,strong)NSNumber         *currentPage;
@property(nonatomic,strong)WeiCommentInfo   *actionComment;

@end

@implementation WeCommentListVC

- (NSString *)umengPageName {
    if (self.isMine) {
        return @"我的微社区";
    }
    return @"微社区列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_WeCommentList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = @0;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.commentTableV.header beginRefreshing];
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
    if ([segue.identifier isEqualToString:@"Segue_WeiComment_Detail"]) {
        ((WeiCommentDetailVC*)segue.destinationViewController).comment = ((WeiCommentCell*)sender).comment;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_WeiCommentList_PictureShow"]) {
        PictureShowVC *vc = (PictureShowVC*)segue.destinationViewController;
        NSDictionary *info = (NSDictionary*)sender;
        vc.picUrlArray = [info objectForKey:@"dataArray"];
        vc.currentIndex = [[info objectForKey:@"Index"] unsignedIntegerValue];
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"UnSegue_WeiCommentEditer_List"]) {
        if (self.needRefresh) {
            [self _refreshCommentList];
        }
    }
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (!self.commentTableV) {
        self.commentTableV = ({
            UITableView *v = [[UITableView alloc] init];
            [v registerClass:[WeiCommentCell class] forCellReuseIdentifier:[WeiCommentCell reuseIdentify]];
            v.separatorStyle = UITableViewCellSeparatorStyleNone;
            v.showsVerticalScrollIndicator = NO;
            v.showsHorizontalScrollIndicator = NO;
            
            _weak(self);
            v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _strong(self);
                [self _refreshCommentList];
            }];
            v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _strong(self);
                [self _loadMoreComment];
            }];
            
            [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
                _strong(self);
                return [self.commentList count];
            }];
            
            [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
                _strong(self);
                return [WeiCommentCell heightWithComment:self.commentList[path.row] screenWidth:V_W_(self.view)];
            }];
            
            [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
                _strong(self);
                WeiCommentCell *cell = [view dequeueReusableCellWithIdentifier:[WeiCommentCell reuseIdentify]];
                if (!cell) {
                    cell = [[WeiCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WeiCommentCell reuseIdentify]];
                }
                cell.comment = self.commentList[path.row];
                cell.isUped = [[CommunityLifeModel sharedModel] isWeiCommentUpWithCommentId:(cell.comment.commentId)];
                _weak(cell);
                cell.likeActionBlock = ^(WeiCommentInfo *comment){
                    if (![[UserModel sharedModel] isNormalLogined]) {
                        [SVProgressHUD showErrorWithStatus:@"请先登录"];
                        return;
                    }
                    [[CommunityLifeModel sharedModel] asyncWeiUpWithCommentId:comment.commentId remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                        _strong(cell);
                        if (isSuccess) {
                            [UserPointHandler addUserPointWithType:ActionUp showInfo:NO];
                            cell.isUped = YES;
                            [cell addUpCount];
                            return;
                        }
                        [SVProgressHUD showErrorWithStatus:@"操作失败"];
                    }];
                };
                cell.commentActionBlock = ^(WeiCommentInfo *comment) {
                    _strong(cell);
                    [self performSegueWithIdentifier:@"Segue_WeiComment_Detail" sender:cell];
                };
                cell.actionBlock = ^(WeiCommentCell *cell) {
                    self.actionComment = cell.comment;
                    if (self.isMine || ([UserModel sharedModel].isNormalLogined && [cell.comment.userId integerValue] == [[UserModel sharedModel].currentNormalUser.userId integerValue])) {
                        if ([self.deleteActionV isHidden]) {
                            [self.deleteActionV mas_remakeConstraints:^(MASConstraintMaker *make) {
                                _strong(self);
                                CGRect cellRect = [cell convertRect:cell.bounds toView:self.contentV];
                                make.top.equalTo(@(cellRect.origin.y+39));
                                make.right.equalTo(self.contentV).with.offset(-8);
                                make.width.equalTo(@77);
                                make.height.equalTo(@39);
                            }];
                        }
                        [self.deleteActionV setHidden:!self.deleteActionV.isHidden];
                    }
                    else {
                        if ([self.actionV isHidden]) {
                            [self.actionV mas_remakeConstraints:^(MASConstraintMaker *make) {
                                _strong(self);
                                CGRect cellRect = [cell convertRect:cell.bounds toView:self.contentV];
                                make.top.equalTo(@(cellRect.origin.y+39));
                                make.right.equalTo(self.contentV).with.offset(-8);
                                make.width.equalTo(@77);
                                make.height.equalTo(@69);
                            }];
                        }
                        [self.actionV setHidden:!self.actionV.isHidden];
                    }
                };
                cell.picShowBlock = ^(NSArray *picUrlArray, NSInteger index) {
                    _strong(self);
                    [self performSegueWithIdentifier:@"Segue_WeiCommentList_PictureShow" sender:@{@"dataArray":picUrlArray, @"Index":@(index)}];
                };
                return cell;
            }];
            
            [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
                _strong(self);
                if (path.row >= [self.commentList count]) {
                    return;
                }
                
                [self performSegueWithIdentifier:@"Segue_WeiComment_Detail" sender:[view cellForRowAtIndexPath:path]];
            }];
            
            [v withBlockForFooterHeight:^CGFloat(UITableView *view, NSInteger section) {
                return (CGFloat)55;
            }];
            
            [v withBlockForFooterView:^UIView *(UITableView *view, NSInteger section) {
                UIView *footer = [[UIView alloc] init];
                UIButton *addBtn = [[UIButton alloc] init];
                addBtn.backgroundColor = k_COLOR_BLUE;
                addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                addBtn.layer.cornerRadius = 15;
                [addBtn setTitle:@"我要说点啥" forState:UIControlStateNormal];
                [addBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
                [addBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
                [addBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                    _strong(self);
                    if ([[UserModel sharedModel] isNormalLogined]) {
                        [self performSegueWithIdentifier:@"Segue_WeiComment_Edit" sender:nil];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:@"请先登录"];
                    }
                }];
                [footer addSubview:addBtn];
                _weak(footer);
                [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    _strong(footer);
                    make.top.equalTo(footer).with.offset(10);
                    make.bottom.equalTo(footer).with.offset(-15);
                    make.centerX.equalTo(footer);
                    make.width.equalTo(@180);
                }];
                footer.backgroundColor = [k_COLOR_MINE_SHAFT colorWithAlphaComponent:0.7];
                return footer;
            }];
            v;
        });
    }
    
    if (!self.deleteActionV) {
        self.deleteActionV = [[UIImageView alloc] init];
        self.deleteActionV.userInteractionEnabled = YES;
        self.deleteActionV.image = [UIImage imageNamed:@"p_weicomment_action_btn"];
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [deleteBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [deleteBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateHighlighted];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteActionV addSubview:deleteBtn];
        _weak(self);
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.deleteActionV);
        }];
        [deleteBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.deleteActionV setHidden:YES];
            if (![[UserModel sharedModel] isNormalLogined]) {
                [SVProgressHUD showErrorWithStatus:@"请先登录"];
                return;
            }
            if (!self.actionComment) {
                return;
            }
            [[CommunityLifeModel sharedModel] asyncWeiDeleteWithCommentId:self.actionComment.commentId remoteBlock:^(BOOL isSuccess, NSError *error) {
                _strong(self);
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [self _refreshCommentList];
                }
            }];
        }];
    }
    
    if (!self.actionV) {
        self.actionV = [[UIImageView alloc] init];
        self.actionV.userInteractionEnabled = YES;
        self.actionV.image = [UIImage imageNamed:@"cl_weicomment_action"];
        UIButton *unlikeBtn = [[UIButton alloc] init];
        unlikeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [unlikeBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [unlikeBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateHighlighted];
        [unlikeBtn setTitle:@"不感兴趣" forState:UIControlStateNormal];
        [self.actionV addSubview:unlikeBtn];
        _weak(self);
        [unlikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.equalTo(self.actionV);
            make.top.equalTo(self.actionV).with.offset(6);
            make.height.equalTo(@32);
        }];
        [unlikeBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.actionV setHidden:YES];
            if (![[UserModel sharedModel] isNormalLogined]) {
                [SVProgressHUD showErrorWithStatus:@"请先登录"];
                return;
            }
            if (!self.actionComment) {
                return;
            }
            [[CommunityLifeModel sharedModel] asyncWeiUnlikeWithCommentId:self.actionComment.commentId remoteBlock:^(BOOL isSuccess, NSError *error) {
                
            }];
        }];
        
        UIButton *reportBtn = [[UIButton alloc] init];
        reportBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [reportBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [reportBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateHighlighted];
        [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
        [self.actionV addSubview:reportBtn];
        [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.equalTo(self.actionV);
            make.top.equalTo(self.actionV).with.offset(38);
            make.height.equalTo(@32);
        }];
        [reportBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.actionV setHidden:YES];
            if (![[UserModel sharedModel] isNormalLogined]) {
                [SVProgressHUD showErrorWithStatus:@"请先登录"];
                return;
            }
            if (!self.actionComment) {
                return;
            }
            [[CommunityLifeModel sharedModel] asyncWeiReportWithCommentId:self.actionComment.commentId remoteBlock:^(BOOL isSuccess, NSError *error) {
                
            }];
        }];
    }
}

- (void)_layoutCodingViews {
    if ([self.commentTableV superview]) {
        return;
    }
    _weak(self);
    UIView *tmp = [[UIView alloc] init];
    tmp.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:tmp];
    [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(-1);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    UIView *tmpb = [[UIView alloc] init];
    tmpb.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:tmpb];
    [tmpb mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.bottom.equalTo(self.contentV).with.offset(1);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    [self.contentV addSubview:self.commentTableV];
    [self.commentTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.bottom.equalTo(self.contentV);
    }];
    
    [self.contentV addSubview:self.actionV];
    [self.actionV setHidden:YES];
    [self.contentV addSubview:self.deleteActionV];
    [self.deleteActionV setHidden:YES];
    
    [self _setupTapGestureRecognizer];
}

- (void)_setupTapGestureRecognizer {
    _weak(self);
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
    [tap withBlockForShouldReceiveTouch:^BOOL(UIGestureRecognizer *gesture, UITouch *touch) {
        _strong(self);
        if (!CGRectContainsPoint(self.actionV.frame, [touch locationInView:self.contentV])) {
            [self.actionV setHidden:YES];
        }
        if (!CGRectContainsPoint(self.deleteActionV.frame, [touch locationInView:self.deleteActionV])) {
            [self.deleteActionV setHidden:YES];
        }
        return NO;
    }];
    [self.contentV addGestureRecognizer:tap];
}

#pragma mark - Data
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"commentList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.commentTableV reloadData];
        
        if ([UserModel sharedModel].isNormalLogined) {
            UserInfo *cUser = [UserModel sharedModel].currentNormalUser;
            for (WeiCommentInfo *info in self.commentList) {
                WeiCommentAction *action = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_WEICOMMENTACTION predicate:[NSPredicate predicateWithFormat:@"commentId=%@ AND userId=%@", info.commentId, cUser.userId]] firstObject];
                if (!action) {
                    action = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_WEICOMMENTACTION];
                    action.commentId = info.commentId;
                    action.userId = cUser.userId;
                }
                action.isRead = @(YES);
            }
        }
    }];
}

- (void)_loadCommentAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    if (self.isMine) {
        [[CommunityLifeModel sharedModel] asyncMyWeiListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] parentId:@0 page:page pageSize:pageSize cacheBlock:nil remoteBlock:^(NSArray *commentList, NSNumber *cPage, NSError *error) {
            _strong(self);
            if (self.commentTableV.header.isRefreshing) {
                [self.commentTableV.header endRefreshing];
            }
            if (self.commentTableV.footer.isRefreshing) {
                [self.commentTableV.footer endRefreshing];
            }
            if (!error) {
                if ([cPage integerValue] == 1) {
                    self.currentPage = cPage;
                    self.commentList = commentList;
                }
                else if ([commentList count]>0) {
                    self.currentPage = cPage;
                    NSMutableArray *tmp = [self.commentList mutableCopy];
                    [tmp addObjectsFromArray:commentList];
                    self.commentList = tmp;
                }
            }
        }];
    }
    else {
        [[CommunityLifeModel sharedModel] asyncWeiListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] parentId:@0 page:page pageSize:pageSize cacheBlock:nil remoteBlock:^(NSArray *commentList, NSNumber *cPage, NSError *error) {
            _strong(self);
            if (self.commentTableV.header.isRefreshing) {
                [self.commentTableV.header endRefreshing];
            }
            if (self.commentTableV.footer.isRefreshing) {
                [self.commentTableV.footer endRefreshing];
            }
            if (!error) {
                if ([cPage integerValue] == 1) {
                    self.currentPage = cPage;
                    self.commentList = commentList;
                }
                else if ([commentList count]>0) {
                    self.currentPage = cPage;
                    NSMutableArray *tmp = [self.commentList mutableCopy];
                    [tmp addObjectsFromArray:commentList];
                    self.commentList = tmp;
                }
                
                if ([commentList count] > 0 && [UserModel sharedModel].isNormalLogined) {
                    for (WeiCommentInfo *info in commentList) {
                        WeiCommentAction *action = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_WEICOMMENTACTION predicate:[NSPredicate predicateWithFormat:@"commentId=%@", info.commentId]] firstObject];
                        if (!action) {
                            action = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_WEICOMMENTACTION];
                            action.commentId = info.commentId;
                            action.userId = [UserModel sharedModel].currentNormalUser.userId;
                        }
                        action.isRead = @(YES);
                    }
                }
            }
        }];
    }
}

- (void)_refreshCommentList {
    [self _loadCommentAtPage:@1 pageSize:@20];
}

- (void)_loadMoreComment {
    [self _loadCommentAtPage:@([self.currentPage integerValue] + 1) pageSize:@20];
}

@end
