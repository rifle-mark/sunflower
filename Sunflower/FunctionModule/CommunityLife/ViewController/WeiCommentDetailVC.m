//
//  WeiCommentDetailVC.m
//  Sunflower
//
//  Created by makewei on 15/6/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "WeiCommentDetailVC.h"
#import "WeiCommentCell.h"
#import "WeiSubCommentCell.h"
#import "WeiSubCommentView.h"
#import "PictureShowVC.h"

#import "CommunityLifeModel.h"
#import "CommonModel.h"
#import "UserModel.h"

@interface WeiCommentDetailVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;
@property(nonatomic,strong)UITableView      *commentDetailTableV;
@property(nonatomic,strong)WeiSubCommentView *commentV;
@property(nonatomic,strong)UIImageView      *actionV;
@property(nonatomic,strong)UIImageView      *deleteActionV;

@property(nonatomic,strong)NSArray          *commentList;
@property(nonatomic,strong)NSNumber         *currentPage;

@end

@implementation WeiCommentDetailVC

- (NSString *)umengPageName {
    return @"微社区帖子详情";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_WeiCommentDetail";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    [self _refreshCommentList];
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
    FixesViewDidLayoutSubviewsiOS7Error;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"Segue_WeiCommentInfo_PictureShow"]) {
        PictureShowVC *vc = (PictureShowVC*)segue.destinationViewController;
        NSDictionary *info = (NSDictionary*)sender;
        vc.picUrlArray = [info objectForKey:@"dataArray"];
        vc.currentIndex = [[info objectForKey:@"Index"] unsignedIntegerValue];
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Coding View

- (void)_loadCodingViews {
    if (!self.commentDetailTableV) {
        self.commentDetailTableV = ({
            UITableView *v = [[UITableView alloc] init];
            [v registerClass:[WeiCommentCell class] forCellReuseIdentifier:[WeiCommentCell reuseIdentify]];
            [v registerClass:[WeiSubCommentCell class] forCellReuseIdentifier:[WeiSubCommentCell reuseIdentify]];
            v.showsHorizontalScrollIndicator = NO;
            v.showsVerticalScrollIndicator = NO;
            v.separatorStyle = UITableViewCellSeparatorStyleNone;
            v.allowsSelection = NO;
            _weak(self);
            [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
                _strong(self);
                return [self.commentList count] + 1;
            }];
            
            [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
                _strong(self);
                if (path.row == 0) {
                    return [WeiCommentCell heightWithComment:self.comment screenWidth:V_W_(self.view)];
                }
                
                else {
                    return [WeiSubCommentCell heightWithComment:self.commentList[path.row-1] screenWidth:V_W_(self.view)];
                }
            }];
            
            [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
                _strong(self);
                if (path.row == 0) {
                    WeiCommentCell *cell = [view dequeueReusableCellWithIdentifier:[WeiCommentCell reuseIdentify]];
                    if (!cell) {
                        cell = [[WeiCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WeiCommentCell reuseIdentify]];
                    }
                    cell.comment = self.comment;
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
                        if (![[UserModel sharedModel] isNormalLogined]) {
                            [SVProgressHUD showErrorWithStatus:@"请先登录"];
                            return;
                        }
                        _strong(self);
                        [self _showCommentViewWithComment:comment];
                    };
                    cell.picShowBlock = ^(NSArray *picUrlArray, NSInteger index) {
                        _strong(self);
                        [self performSegueWithIdentifier:@"Segue_WeiCommentInfo_PictureShow" sender:@{@"dataArray":picUrlArray, @"Index":@(index)}];
                    };
                    cell.actionBlock = ^(WeiCommentCell *cell) {
                        if (([UserModel sharedModel].isNormalLogined && [cell.comment.userId integerValue] == [[UserModel sharedModel].currentNormalUser.userId integerValue])) {
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
                    return cell;
                }
                else {
                    WeiSubCommentCell *cell = [view dequeueReusableCellWithIdentifier:[WeiSubCommentCell reuseIdentify]];
                    if (!cell) {
                        cell = [[WeiSubCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WeiSubCommentCell reuseIdentify]];
                    }
                    
                    cell.comment = self.commentList[path.row - 1];
                    _weak(cell);
                    cell.longTapBlock = ^(WeiCommentInfo *comment) {
                        _strong(cell);
                        _strong(self);
                        UIMenuController *menu = (UIMenuController*)[UIMenuController sharedMenuController];
                        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyComment:)];
                        UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteComment:)];
                        if ([comment.userId integerValue] == [[UserModel sharedModel].currentNormalUser.userId integerValue]) {
                            [menu setMenuItems:@[copy, delete]];
                        }
                        else {
                            [menu setMenuItems:@[copy]];
                        }
                        
                        menu.userInfo = @{@"Comment":comment};
                        
                        [menu setTargetRect:[cell convertRect:cell.bounds toView:self.view] inView:self.view];
                        [menu setMenuVisible:YES animated:YES];
                    };
                    return cell;
                }
            }];
            v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _strong(self);
                [self _refreshCommentList];
            }];
            v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _strong(self);
                [self _loadMoreComment];
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
            if (!self.comment) {
                return;
            }
            [[CommunityLifeModel sharedModel] asyncWeiDeleteWithCommentId:self.comment.commentId remoteBlock:^(BOOL isSuccess, NSError *error) {
                _strong(self);
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [self performSegueWithIdentifier:@"UnSegue_WeiCommentDetail" sender:nil];
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
            if (!self.comment) {
                return;
            }
            [[CommunityLifeModel sharedModel] asyncWeiUnlikeWithCommentId:self.comment.commentId remoteBlock:^(BOOL isSuccess, NSError *error) {
                
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
            if (!self.comment) {
                return;
            }
            [[CommunityLifeModel sharedModel] asyncWeiReportWithCommentId:self.comment.commentId remoteBlock:^(BOOL isSuccess, NSError *error) {
                
            }];
        }];
    }
    
    if (!self.commentV) {
        self.commentV = ({
            _weak(self);
            WeiSubCommentView* view = [[WeiSubCommentView alloc] init];
            [view withSubmitAction:^(NSString *commentContent, NSNumber *rootCommentID) {
                _strong(self);
                [self.commentV resignFirstResponder];
                [self.commentV clearContent];
                [[CommunityLifeModel sharedModel] asyncWeiAddWithCommuntiyId:[CommonModel sharedModel].currentCommunityId parentId:rootCommentID content:commentContent images:@"" address:@"" remoteBlock:^(BOOL isSuccess, NSError *error) {
                    _strong(self);
                    if (isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                        [UserPointHandler addUserPointWithType:WeiCommentSubComment showInfo:NO];
                        [self _refreshCommentList];
                        return;
                    }
                    [SVProgressHUD showErrorWithStatus:error.domain];
                }];
            }];
            view;
        });
        self.commentV.hidden = YES;
    }
}
-(BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)copyComment:(id)sender {
    NSDictionary *userInfo = [sender userInfo];
    WeiCommentInfo *comment = (WeiCommentInfo*)[userInfo objectForKey:@"Comment"];
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:comment.content];
}

- (void)deleteComment:(id)sender {
    _weak(self);
    NSDictionary *userInfo = [sender userInfo];
    WeiCommentInfo *comment = (WeiCommentInfo*)[userInfo objectForKey:@"Comment"];
    [[CommunityLifeModel sharedModel] asyncWeiDeleteWithCommentId:comment.commentId remoteBlock:^(BOOL isSuccess, NSError *error) {
        _strong(self);
        if (!error) {
            [self _refreshCommentList];
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)_layoutCodingViews {
    _weak(self);
    if (![self.commentDetailTableV superview]) {
        
        UIView *tmp = [[UIView alloc] init];
        tmp.backgroundColor = k_COLOR_CLEAR;
        [self.contentV addSubview:tmp];
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentV).with.offset(-1);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@1);
        }];
        
        [self.contentV addSubview:self.commentDetailTableV];
        [self.commentDetailTableV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentV);
        }];
    }
    
    if (![self.commentV superview]) {
        [self.contentV addSubview:self.commentV];
        [self.commentV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@50);
            make.bottom.equalTo(self.contentV);
        }];
    }
    [self.contentV addSubview:self.actionV];
    [self.actionV setHidden:YES];
    [self.contentV addSubview:self.deleteActionV];
    [self.deleteActionV setHidden:YES];
    
    [self _setupTapGestureRecognizer];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"commentList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.commentDetailTableV reloadData];
    }];
    
    [self addObserverForNotificationName:UIKeyboardWillShowNotification usingBlock:^(NSNotification *noti) {
        _strong(self);
        NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView animateWithDuration:[duration doubleValue] delay:0.0f options:[curve integerValue]<<16 animations:^(){
            [self.commentV mas_remakeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                CGRect keyboardBounds = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                CGFloat keyboardHeight = keyboardBounds.size.height;
                make.left.right.equalTo(self.contentV);
                make.height.equalTo(@50);
                make.bottom.equalTo(self.contentV).with.offset(keyboardHeight<=self.bottomLayoutGuide.length?(-self.bottomLayoutGuide.length):(-keyboardHeight));
            }];
            [self.view layoutIfNeeded];
        } completion:nil];
    }];
    
    [self addObserverForNotificationName:UIKeyboardWillHideNotification usingBlock:^(NSNotification *noti) {
        _strong(self);
        NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        self.commentV.comment = nil;
        
        [UIView animateWithDuration:[duration doubleValue] delay:0.0f options:[curve integerValue]<<16 animations:^(){
            [self.commentV mas_remakeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.left.right.equalTo(self.contentV);
                make.height.equalTo(@50);
                make.bottom.equalTo(self.contentV);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished){
            _strong(self);
            [self.commentV setHidden:YES];
        }];
    }];
}

- (void)_showCommentViewWithComment:(WeiCommentInfo*)comment {
    if (![self.commentV isHidden]) {
        return;
    }
    self.commentV.comment = comment;
    _weak(self);
    [self.commentV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.contentV);
    }];
    self.commentV.hidden = NO;
    [self.commentV becomeFirstResponder];
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
        
        if (!CGRectContainsPoint(self.commentV.frame, [touch locationInView:self.contentV])) {
            [self.commentV resignFirstResponder];
        }
        return NO;
    }];
    [self.contentV addGestureRecognizer:tap];
}
#pragma mark - Data



- (void)_refreshCommentList {
    if (!self.comment) {
        return;
    }
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncWeiListWithCommunityId:[CommonModel sharedModel].currentCommunityId parentId:self.comment.commentId page:@1 pageSize:@10 cacheBlock:nil remoteBlock:^(NSArray *commentList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if ([self.commentDetailTableV.header isRefreshing]) {
            [self.commentDetailTableV.header endRefreshing];
        }
        if ([self.commentDetailTableV.footer isRefreshing]) {
            [self.commentDetailTableV.footer endRefreshing];
        }
        if (!error) {
            self.currentPage = @1;
            self.commentList = commentList;
        }
    }];
}

- (void)_loadMoreComment {
    if (!self.comment) {
        return;
    }
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncWeiListWithCommunityId:[CommonModel sharedModel].currentCommunityId parentId:self.comment.commentId page:@([self.currentPage integerValue]+1) pageSize:@10 cacheBlock:nil remoteBlock:^(NSArray *commentList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if ([self.commentDetailTableV.header isRefreshing]) {
            [self.commentDetailTableV.header endRefreshing];
        }
        if ([self.commentDetailTableV.footer isRefreshing]) {
            [self.commentDetailTableV.footer endRefreshing];
        }
        if (!error) {
            self.currentPage = cPage;
            NSMutableArray *tmp = [self.commentList mutableCopy];
            [tmp addObjectsFromArray:commentList];
            self.commentList = tmp;
        }
    }];
}

@end
