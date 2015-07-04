//
//  MyPaymentRecorderVC.m
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MyPaymentRecorderVC.h"
#import "PropertyPayCell.h"

#import "UserModel.h"

@interface MyPaymentRecorderVC ()

@property(nonatomic,strong)UITableView      *paymentTableV;
@property(nonatomic,strong)NSArray          *paymentList;

@property(nonatomic,strong)NSNumber         *currentPage;
@property(nonatomic,strong)NSNumber         *pageSize;
@end

@implementation MyPaymentRecorderVC

- (NSString *)umengPageName {
    return @"我的缴费记录";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_MyPaymentRecorder";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentPage = @1;
    self.pageSize = @20;
    
    [self _setupObserver];
    [self _refreshPaymentList];
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
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Coding Views

- (void)_loadCodingViews {
    if (self.paymentTableV) {
        return;
    }
    
    self.paymentTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        
        [v registerClass:[PropertyPayCell class] forCellReuseIdentifier:[PropertyPayCell reuseIdentify]];
        
        _weak(self);
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _refreshPaymentList];
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMorePaymentList];
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.paymentList count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 101;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            PropertyPayCell *cell = [view dequeueReusableCellWithIdentifier:[PropertyPayCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[PropertyPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PropertyPayCell reuseIdentify]];
            }
            
            cell.payment = self.paymentList[path.row];
            return cell;
        }];
        v;
    });
}

- (void)_layoutCodingViews {
    if ([self.paymentTableV superview]) {
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
    
    _weak(topTmp);
    _weak(botTmp);
    [self.view addSubview:self.paymentTableV];
    [self.paymentTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(botTmp);
        _strong(topTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"paymentList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.paymentTableV reloadData];
    }];
}

#pragma mark - Data
- (void)_refreshPaymentList {
    [self _loadPaymentListAtPage:@1 pageSize:self.pageSize];
}

- (void)_loadMorePaymentList {
    [self _loadPaymentListAtPage:@([self.currentPage integerValue]+1) pageSize:self.pageSize];
}

- (void)_loadPaymentListAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[UserModel sharedModel] asyncChargeRecordListWithPage:page pageSize:pageSize remoteBlock:^(NSArray *list, NSNumber *page, NSError *error) {
        _strong(self);
        if (self.paymentTableV.header.isRefreshing) {
            [self.paymentTableV.header endRefreshing];
        }
        if (self.paymentTableV.footer.isRefreshing) {
            [self.paymentTableV.footer endRefreshing];
        }
        
        if (!error) {
            if ([page integerValue] == 1) {
                self.currentPage = page;
                self.paymentList = list;
            }
            else {
                if ([list count] > 0) {
                    self.currentPage = page;
                    NSMutableArray *tmp = [self.paymentList mutableCopy];
                    [tmp addObjectsFromArray:list];
                    self.paymentList = tmp;
                }
            }
        }
    }];
}

@end
