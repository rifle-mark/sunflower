//
//  GuanJiaListVC.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Masonry.h>
#import "GCExtension.h"
#import <UIImageView+AFNetworking.h>

#import "PropertyServiceModel.h"
#import "CommonModel.h"
#import "UserModel.h"

#import "GuanJiaListVC.h"
#import "GuanJiaTableViewCell.h"
#import "GuanJiaEditVC.h"

#import "UserGuanjia.h"
#import "MKWModelHandler.h"

@interface GuanJiaListVC ()

@property(nonatomic,strong)NSArray      *guanjiaArray;
@property(nonatomic,strong)NSNumber     *currentPage;
@property(nonatomic,strong)NSNumber     *pageSize;

@property(nonatomic,strong)UITableView  *guanjiaTableview;
@property(nonatomic,strong)UIButton     *addBtn;

@end

@implementation GuanJiaListVC

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_Property_GuanjiaList";
}

- (NSString *)umengPageName {
    return @"管家列表";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentPage = @1;
    self.pageSize = @20;
    
    
    [self _setupObserver];
    [self.guanjiaTableview.header beginRefreshing];
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
    if (self.guanjiaTableview) {
        return;
    }
    _weak(self);
    self.guanjiaTableview = ({
        UITableView *v = [[UITableView alloc] init];
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.delaysContentTouches = NO;
        v.clipsToBounds = YES;
        
        [v registerClass:[GuanJiaTableViewCell class] forCellReuseIdentifier:[GuanJiaTableViewCell reuseIdentify]];
        
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _refreshGuanJiaList];
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMoreGuanJiaList];
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            return [self.guanjiaArray count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 107;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            GuanJiaTableViewCell *cell = [v dequeueReusableCellWithIdentifier:[GuanJiaTableViewCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[GuanJiaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[GuanJiaTableViewCell reuseIdentify]];
            }
            GuanjiaInfo *guanjia = (GuanjiaInfo*)self.guanjiaArray[path.row];
            cell.guanjia = guanjia;
            if ([UserModel sharedModel].isNormalLogined) {
                UserGuanjia *guanjiaAction = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_USERGUANJIA predicate:[NSPredicate predicateWithFormat:@"userId=%@ AND guanJiaId=%@",[UserModel sharedModel].currentNormalUser.userId, guanjia.guanjiaId]] firstObject];
                if (guanjiaAction) {
                    cell.isUped = [guanjiaAction.isUped boolValue];
                }
            }
            else {
                cell.isUped = NO;
            }
            _weak(guanjia);
            _weak(cell);
            cell.upActionBlock = ^(){
                if (![UserModel sharedModel].isNormalLogined) {
                    [SVProgressHUD showErrorWithStatus:@"请先登录"];
                    return;
                }
                
                _strong(guanjia);
                UserGuanjia *guanjiaAction = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_USERGUANJIA predicate:[NSPredicate predicateWithFormat:@"userId=%@ AND guanJiaId=%@",[UserModel sharedModel].currentNormalUser.userId, guanjia.guanjiaId]] firstObject];
                if (!guanjiaAction) {
                    guanjiaAction = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_USERGUANJIA];
                    guanjiaAction.userId = [UserModel sharedModel].currentNormalUser.userId;
                    guanjiaAction.guanJiaId = guanjia.guanjiaId;
                }
                _weak(guanjiaAction);
                [[PropertyServiceModel sharedModel] asyncUpGuanJiaWithGuanjiaId:guanjia.guanjiaId remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                    _strong(cell);
                    _strong(guanjiaAction);
                    if (isSuccess) {
                        guanjiaAction.isUped = @YES;
                        cell.isUped = YES;
                        [cell updateUpState];
                        [UserPointHandler addUserPointWithType:ActionUp showInfo:NO];
                    }
                }];
            };
            return cell;
        }];
        
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if ([UserModel sharedModel].isPropertyAdminLogined && [[UserModel sharedModel].currentAdminUser.communityId integerValue] == [[CommonModel sharedModel].currentCommunityId integerValue]) {
                GuanJiaTableViewCell *cell = (GuanJiaTableViewCell*)[view cellForRowAtIndexPath:path];
                [self performSegueWithIdentifier:@"Segue_GuanJIaList_GuanJiaEdit" sender:cell.guanjia];
            }
        }];
        v;
    });
    
    if (!self.addBtn) {
        self.addBtn = [[UIButton alloc] init];
        self.addBtn.backgroundColor = k_COLOR_BLUE;
        self.addBtn.layer.cornerRadius = 4;
        self.addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.addBtn setTitle:@"添加新管家" forState:UIControlStateNormal];
        [self.addBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [self.addBtn setTitleColor:k_COLOR_GRAY_BG forState:UIControlStateHighlighted];
        [self.addBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self performSegueWithIdentifier:@"Segue_GuanJIaList_GuanJiaEdit" sender:nil];
        }];
    }
}

- (void)_layoutCodingViews {
    if (![self.guanjiaTableview superview]) {
        _weak(self);
        UIView *toptmp = [[UIView alloc] init];
        toptmp.backgroundColor = k_COLOR_CLEAR;
        [self.view addSubview:toptmp];
        [toptmp mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(self.topLayoutGuide.length));
        }];
        
        UIView *bottmp = [[UIView alloc] init];
        bottmp.backgroundColor = k_COLOR_CLEAR;
        [self.view addSubview:bottmp];
        [bottmp mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.left.right.equalTo(self.view);
            make.height.equalTo(@(self.bottomLayoutGuide.length));
        }];
        _weak(toptmp);
        _weak(bottmp);
        
        if ([UserModel sharedModel].isPropertyAdminLogined && [[UserModel sharedModel].currentAdminUser.communityId integerValue] == [[CommonModel sharedModel].currentCommunityId integerValue]) {
            [self.view addSubview:self.addBtn];
            [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                make.bottom.equalTo(bottmp.mas_top).with.offset(-10);
                make.left.equalTo(self.view).with.offset(13);
                make.right.equalTo(self.view).with.offset(-13);
                make.height.equalTo(@43);
            }];
            [self.view addSubview:self.guanjiaTableview];
            [self.guanjiaTableview mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                _strong(toptmp);
                make.left.right.equalTo(self.view);
                make.top.equalTo(toptmp.mas_bottom);
                make.bottom.equalTo(self.addBtn.mas_top).with.offset(-10);
            }];
        }
        else {
            [self.view addSubview:self.guanjiaTableview];
            [self.guanjiaTableview mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(self);
                _strong(toptmp);
                _strong(bottmp);
                make.left.right.equalTo(self.view);
                make.top.equalTo(toptmp.mas_bottom);
                make.bottom.equalTo(bottmp.mas_top);
            }];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_GuanJIaList_GuanJiaEdit"] && [sender isKindOfClass:[GuanjiaInfo class]]) {
        ((GuanJiaEditVC*)segue.destinationViewController).guanjia = sender;
    }
}
- (void)unwindSegue:(UIStoryboardSegue *)segue {
    [self _refreshGuanJiaList];
}

#pragma mark - Data 
- (void)_refreshGuanJiaList {
    [self _loadGuanJiaListAtPage:@1 pageSize:self.pageSize];
}
- (void)_loadMoreGuanJiaList {
    [self _loadGuanJiaListAtPage:@(([self.currentPage integerValue]+1)) pageSize:self.pageSize];
}
- (void)_loadGuanJiaListAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    [[PropertyServiceModel sharedModel] asyncGuanjiaListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] pageIndex:page pageSize:pageSize cacheBlock:^(NSArray *list, NSNumber *page) {
        self.guanjiaArray = list;
    } remoteBlock:^(NSArray *list, NSNumber *page, NSError *error) {
        
        if (self.guanjiaTableview.header.isRefreshing) {
            [self.guanjiaTableview.header endRefreshing];
        }
        if (self.guanjiaTableview.footer.isRefreshing) {
            [self.guanjiaTableview.footer endRefreshing];
        }
        
        if (!error) {
            if ([page integerValue] == 1) {
                self.currentPage = page;
                self.guanjiaArray = list;
            }
            else {
                if ([list count] > 0) {
                    self.currentPage = page;
                    NSMutableArray *tmp = [self.guanjiaArray mutableCopy];
                    [tmp addObjectsFromArray:list];
                    self.guanjiaArray = tmp;
                }
            }
        }
    }];
}
- (void)_setupObserver {
    [self startObserveObject:self forKeyPath:@"guanjiaArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        
        if ([UserModel sharedModel].isNormalLogined) {
            UserInfo *cUser = [UserModel sharedModel].currentNormalUser;
            for (GuanjiaInfo *guanjia in self.guanjiaArray) {
                UserGuanjia *guanjiaAction = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_USERGUANJIA predicate:[NSPredicate predicateWithFormat:@"userId=%@ AND guanJiaId=%@", cUser.userId, guanjia.guanjiaId]] firstObject];
                if (!guanjiaAction) {
                    guanjiaAction = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_USERGUANJIA];
                    guanjiaAction.userId = cUser.userId;
                    guanjiaAction.guanJiaId = guanjia.guanjiaId;
                    guanjiaAction.isUped = @NO;
                }
            }
        }
        
        [self.guanjiaTableview reloadData];
        
    }];
}

@end
