//
//  FeedListVC.m
//  Sunflower
//
//  Created by kelei on 15/7/25.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "FeedListVC.h"
#import "UserModel.h"

#import "FeedInfoVC.h"


@interface FeedCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@end

@implementation FeedCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.textColor = k_COLOR_GALLERY_F;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = k_COLOR_GRAY;
        [self.contentView addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.textLabel.text = title;
}
@end


@interface FeedListVC ()

@property (nonatomic, strong) UIButton    *createFeedB;
@property (nonatomic, strong) UIView      *fixV;
@property (nonatomic, strong) UITableView *tableV;

@property (nonatomic, strong) NSArray     *feedList;
@property (nonatomic, strong) NSNumber    *currentPage;
@property (nonatomic, strong) NSNumber    *pageSize;
@property (nonatomic, strong) NSIndexPath *selectPath;

@end

static NSString *const kCellIdentify = @"MYCELL";

@implementation FeedListVC

- (NSString *)umengPageName {
    return @"帮助与反馈";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_FeedList";
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = @1;
    self.pageSize = @20;
    
    [self _setupObserver];
    [self _refreshList];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.selectPath) {
        [self.tableV deselectRowAtIndexPath:self.selectPath animated:YES];
        self.selectPath = nil;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[FeedInfoVC class]]) {
        ((FeedInfoVC *)segue.destinationViewController).feed = sender;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
}

#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (!self.fixV) {
        self.fixV = [[UIView alloc] init];
        [self.view addSubview:self.fixV];
    }
    if (!self.createFeedB) {
        self.createFeedB = [UIButton buttonWithType:UIButtonTypeSystem];
        self.createFeedB.frame = CGRectMake(0, 0, 70, 25);
        self.createFeedB.layer.borderColor = k_COLOR_WHITE.CGColor;
        self.createFeedB.layer.borderWidth = 1;
        self.createFeedB.layer.cornerRadius = 4;
        [self.createFeedB setTitle:@"意见反馈" forState:UIControlStateNormal];
        [self.createFeedB setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        [self.createFeedB addTarget:self action:@selector(_createFeedAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *createFeedItem = [[UIBarButtonItem alloc] initWithCustomView:self.createFeedB];
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[fixedItem, createFeedItem];
    }
    
    if (!self.tableV) {
        self.tableV = ({
            UITableView *v = [[UITableView alloc] init];
            v.separatorStyle = UITableViewCellSeparatorStyleNone;
            v.showsHorizontalScrollIndicator = NO;
            v.showsVerticalScrollIndicator = NO;
            
            [v registerClass:[FeedCell class] forCellReuseIdentifier:kCellIdentify];
            
            _weak(self);
            v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _strong(self);
                [self _refreshList];
            }];
            v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _strong(self);
                [self _loadMoreList];
            }];
            
            [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
                _strong(self);
                return [self.feedList count];
            }];
            [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
                _strong(self);
                FeedCell *cell = [view dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:path];
                FeedInfo *feed = self.feedList[path.row];
                cell.title = feed.title;
                return cell;
            }];
            [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
                _strong(self);
                self.selectPath = path;
                FeedInfo *feed = self.feedList[path.row];
                [self performSegueWithIdentifier:@"Segue_FeedList_FeedInfo" sender:feed];
            }];
            v;
        });
    }
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"feedList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.tableV reloadData];
    }];
}

- (void)_layoutCodingViews {
    _weak(self);
    if (![self.tableV superview]) {
        [self.view addSubview:self.tableV];
        [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0));
        }];
    }
}

- (void)_createFeedAction {
    [self performSegueWithIdentifier:@"Segue_FeedList_FeedEdit" sender:nil];
}

#pragma mark - Data
- (void)_refreshList {
    [self _loadListAtPage:@1 pageSize:self.pageSize];
}

- (void)_loadMoreList {
    [self _loadListAtPage:@([self.currentPage integerValue]+1) pageSize:self.pageSize];
}

- (void)_loadListAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[UserModel sharedModel] asyncFeedListWithWithPage:page pageSize:pageSize remoteBlock:^(NSArray *list, NSNumber *page, NSError *error) {
        _strong(self);
        if (self.tableV.header.isRefreshing) {
            [self.tableV.header endRefreshing];
        }
        if (self.tableV.footer.isRefreshing) {
            [self.tableV.footer endRefreshing];
        }
        if (error) {
            return;
        }
        if ([page integerValue] == 1) {
            self.currentPage = page;
            self.feedList = list;
        }
        else if ([list count] > 0) {
            self.currentPage = page;
            self.feedList = [self.feedList arrayByAddingObjectsFromArray:list];
        }
        if (list.count < pageSize.integerValue) {
            self.tableV.footer.hidden = YES;
        }
    }];
}

@end
