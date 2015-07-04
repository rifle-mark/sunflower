//
//  CommunityChooseVC.m
//  Sunflower
//
//  Created by mark on 15/4/22.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Masonry.h>
#import "GCExtension.h"

#import "CSSettingModel.h"

#import "CSTableViewCell.h"
#import "MKWColorHelper.h"
#import "MKWStringHelper.h"
#import "CommunityChooseVC.h"

@interface CommunityChooseVC ()

@property(nonatomic,strong)NSArray          *communityArray;

@property(nonatomic,strong)UITableView      *communityTableView;

@end

@implementation CommunityChooseVC

- (NSString *)umengPageName {
    return @"选择小区";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.okBtn setEnabled:NO];
    [self _setupCommunityTableView];
    _weak(self);
    [self.communityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-70);
    }];
    
    [self _setupObserver];
    
    // 获取城市区域列表
    [[CSSettingModel sharedModel] asyncCommunityWithCity:self.city area:self.area keyWords:@"" pageIndex:@1 pageSize:@20 cacheBlock:^(NSArray *communityArray) {
        _strong(self);
        self.communityArray = communityArray;
    } remoteBlock:^(NSArray *communityArray, NSError *error) {
        _strong(self);
        if (!error) {
            self.communityArray = communityArray;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private method
- (void)_setupObserver {
    [self startObserveObject:self forKeyPath:@"communityArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        [self.communityTableView reloadData];
    }];
}

- (void)_setupCommunityTableView {
    self.communityTableView = ({
        _weak(self);
        UITableView *v = [[UITableView alloc] init];
        [v registerNib:[UINib nibWithNibName:@"CSTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GSCommunityTableCell"];
        v.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.communityArray count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 50;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            CSTableViewCell *cell = [view dequeueReusableCellWithIdentifier:@"GSCommunityTableCell" forIndexPath:path];
            cell.type = Community;
            cell.titleText = [(OpendCommunityInfo*)self.communityArray[path.row] name];
            
            return cell;
        }];
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            [self _selectedCommunity:[self.communityArray objectAtIndex:path.row]];
        }];
        v;
    });
    
    [self.view addSubview:self.communityTableView];
}

- (void)_selectedCommunity:(OpendCommunityInfo*)community {
    _community = community;
    
    [self.okBtn setEnabled:YES];
}
@end