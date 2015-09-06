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

@property(nonatomic,copy)NSString           *searchKey;

@end

@implementation CommunityChooseVC

- (NSString *)umengPageName {
    return @"选择小区";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.okBtn setEnabled:NO];
    [self _setupCommunityTableView];

    
    [self _setupObserver];
    
    [self _getCommunityList];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    _weak(self);
    [self.communityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.view).with.offset(self.topLayoutGuide.length);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-70);
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
    _weak(self);
    [self startObserveObject:self forKeyPath:@"communityArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.communityTableView reloadData];
    }];
}

- (void)_setupCommunityTableView {
    self.communityTableView = ({
        _weak(self);
        UITableView *v = [[UITableView alloc] init];
        [v registerNib:[UINib nibWithNibName:@"CSTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GSCommunityTableCell"];
        v.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [v withBlockForHeaderHeight:^CGFloat(UITableView *view, NSInteger section) {
            return 64;
        }];
        [v withBlockForHeaderView:^UIView *(UITableView *view, NSInteger section) {
            _strong(self);
            UIView *ret = [[UIView alloc] init];
            ret.backgroundColor = RGB(243, 243, 243);
            
            UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bg"]];
            
            UITextField *t = [[UITextField alloc] init];
            t.backgroundColor = k_COLOR_CLEAR;
            t.textColor = k_COLOR_GALLERY_F;
            t.font = [UIFont systemFontOfSize:14];
            t.placeholder = @"搜索小区";
            t.returnKeyType = UIReturnKeySearch;
            t.text = self.searchKey;
            _weak(t);
            
            void(^searchAction)() = ^(){
                _strong(self);
                self.searchKey = [MKWStringHelper trimWithStr:t.text];
                [self _getCommunityList];
            };
            [t withBlockForShouldReturn:^BOOL(UITextField *view) {
                [view resignFirstResponder];
                searchAction();
                return NO;
            }];
            [t withBlockForDidEndEditing:^(UITextField *view) {
                _strong(t);
                [t resignFirstResponder];
            }];
            
            UIButton *searchBtn = [[UIButton alloc] init];
            
            [searchBtn setImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateNormal];
            [searchBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                _strong(t);
                [t resignFirstResponder];
                searchAction();
            }];
            
            [ret addSubview:bgImageView];
            [ret addSubview:t];
            [ret addSubview:searchBtn];
            [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ret);
                make.left.equalTo(ret).with.offset(16);
                make.right.equalTo(ret).with.offset(-16);
            }];
            [t mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgImageView);
                make.left.equalTo(bgImageView).with.offset(16);
                make.right.equalTo(searchBtn.mas_left);
                make.height.equalTo(bgImageView);
            }];
            [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(bgImageView);
                make.width.equalTo(@40);
            }];
            
            return ret;
        }];
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

- (void)_getCommunityList {
    _weak(self);
    // 获取城市区域列表
    [[CSSettingModel sharedModel] asyncCommunityWithCity:self.city area:self.area keyWords:(self.searchKey ?: @"") pageIndex:@1 pageSize:@20 cacheBlock:^(NSArray *communityArray) {
        _strong(self);
        self.communityArray = communityArray;
    } remoteBlock:^(NSArray *communityArray, NSError *error) {
        _strong(self);
        if (!error) {
            self.communityArray = communityArray;
        }
    }];
}

@end
