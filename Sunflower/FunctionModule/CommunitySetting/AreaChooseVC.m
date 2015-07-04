//
//  AreaChooseVC.m
//  Sunflower
//
//  Created by mark on 15/4/22.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Masonry.h>
#import "GCExtension.h"

#import "CSSettingModel.h"

#import "AreaChooseVC.h"
#import "CSTableViewCell.h"
#import "MKWColorHelper.h"
#import "MKWStringHelper.h"

@interface AreaChooseVC ()

@property(nonatomic,strong)NSArray          *areaArray;

@property(nonatomic,strong)UITableView      *areaTableView;

@end

@implementation AreaChooseVC

- (NSString *)umengPageName {
    return @"选择区域";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.okBtn setEnabled:NO];
    [self _setupAreaTableView];
    _weak(self);
    [self.areaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-70);
    }];
    
    [self _setupObserver];
    
    // 获取城市区域列表
    [[CSSettingModel sharedModel] asyncAreaWithCity:self.city cacheBlock:^(NSArray *areaArray) {
        _strong(self);
        self.areaArray = areaArray;
    } remoteBlock:^(NSArray *areaArray, NSError *error) {
        _strong(self);
        if (!error) {
            self.areaArray = areaArray;
            [[CSSettingModel sharedModel] refreshLocalAreasWithCity:self.city areaArray:areaArray];
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
    [self startObserveObject:self forKeyPath:@"areaArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        [self.areaTableView reloadData];
    }];
}

- (void)_setupAreaTableView {
    self.areaTableView = ({
        _weak(self);
        UITableView *v = [[UITableView alloc] init];
        [v registerNib:[UINib nibWithNibName:@"CSCityAreaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GSNoIconTableCell"];
        v.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.areaArray count];;
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 50;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            CSTableViewCell *cell = [view dequeueReusableCellWithIdentifier:@"GSNoIconTableCell" forIndexPath:path];
            cell.type = Area;
            cell.titleText = [(OpendAreaInfo*)self.areaArray[path.row] area];
            
            return cell;
        }];
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            [self _selectedArea:[self.areaArray objectAtIndex:path.row]];
        }];
        v;
    });
    
    [self.view addSubview:self.areaTableView];
}

- (void)_selectedArea:(OpendAreaInfo*)area {
    _area = area;
    
    [self.okBtn setEnabled:YES];
}

@end
