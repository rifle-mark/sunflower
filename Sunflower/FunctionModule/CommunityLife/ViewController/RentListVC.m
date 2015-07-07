//
//  RentListVC.m
//  Sunflower
//
//  Created by mark on 15/5/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIImageView+AFNetworking.h>
#import "GCExtension.h"

#import "NSNumber+MKWDate.h"
#import "CommonModel.h"

#import "RentListVC.h"
#import "RentOutSaleTableCell.h"
#import "RentInTableCell.h"
#import "RentSaleOutVC.h"
#import "RentInVC.h"

static NSArray *normalImages;
static NSArray *hilightImages;

@interface RentListVC () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)NSArray          *rentHouseArray;
@property(nonatomic,strong)NSNumber         *currentPage;
@property(nonatomic,strong)NSNumber         *pageSize;

@property(nonatomic,weak)IBOutlet UITableView   *rentHouseTableView;

@end

@implementation RentListVC

- (NSString *)umengPageName {
    return @"租凭信息列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_RentList";
}

+ (void)initialize {
    normalImages = @[@"rent_out_btn",
                     @"rent_sale_btn",
                     @"rent_in_btn"];
    
    hilightImages = @[@"rent_out_btn_h",
                      @"rent_sale_btn_h",
                      @"rent_in_btn_h"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentPage = @1;
    self.pageSize = @20;
    
    self.rentHouseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self _reloadRentList];
    }];
    self.rentHouseTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self _loadMoreRentList];
    }];
    
    [self _setupObserver];
    [self _reloadRentList];
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _refreshTypeBtns];
}

#pragma mark - IBAction
- (IBAction)rentTypeBtnTap:(id)sender {
    RentType idx = (RentType)([(UIButton*)sender tag] - 120000);
    if (self.type != idx) {
        self.type = idx;
        [self _refreshTypeBtns];
        [self _reloadRentList];
    }
}

#pragma mark - private
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"rentHouseArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.rentHouseTableView reloadData];
    }];
}

- (void)_refreshTypeBtns {
    for (NSInteger i = 1; i<4; i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:(120000+i)];
        if (i == self.type) {
            [btn setSelected:YES];
        }
        else {
            [btn setSelected:NO];
        }
    }
}

- (void)_reloadRentList {
    [self _loadRentListAtPage:@1 pageSize:self.pageSize];
}
- (void)_loadMoreRentList {
    [self _loadRentListAtPage:@([self.currentPage integerValue]+1) pageSize:self.pageSize];
}
- (void)_loadRentListAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncRentListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] type:self.type pageIndex:page pageSize:pageSize cacheBlock:nil remoteBlock:^(NSArray *list, NSInteger cPage, NSError *error) {
        _strong(self);
        if ([self.rentHouseTableView.header isRefreshing]) {
            [self.rentHouseTableView.header endRefreshing];
        }
        if ([self.rentHouseTableView.footer isRefreshing]) {
            [self.rentHouseTableView.footer endRefreshing];
        }
        if (!error) {
            if ([page integerValue] == 1) {
                self.currentPage = page;
                if ([list count] > 0) {
                    self.rentHouseArray = list;
                }
            }
            else {
                if ([list count] > 0) {
                    self.currentPage = page;
                    NSMutableArray *tmp = [self.rentHouseArray mutableCopy];
                    [tmp addObjectsFromArray:list];
                    self.rentHouseArray = tmp;
                }
            }
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"Segue_House_Out"]) {
        ((RentSaleOutVC *)segue.destinationViewController).houseId = ((RentOutSaleTableCell*)sender).houseId;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_House_In"]) {
        ((RentInVC *)segue.destinationViewController).houseId = ((RentInTableCell*)sender).houseId;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}

#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == Rent_In) {
        return 75;
    }
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rentHouseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == Rent_Sale || self.type == Rent_Out) {
        RentOutSaleTableCell *cell = [self.rentHouseTableView dequeueReusableCellWithIdentifier:[RentOutSaleTableCell reuseIdentify] forIndexPath:indexPath];
        RentListInfo *house = self.rentHouseArray[indexPath.row];
        [cell.imageV setImageWithURL:[NSURL URLWithString:house.image] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        cell.titleL.text = house.title;
        cell.roomFixL.text = [NSString stringWithFormat:@"%@室%@厅%@卫 %@", house.room, house.hall, house.toilet, house.fix];
        NSString *price = nil;
        if (self.type == Rent_Sale) {
            price = [NSString stringWithFormat:@"%@万元", house.price ?: @(0)];
        }
        else {
            price = [NSString stringWithFormat:@"%@元/月", house.price ?: @(0)];
        }
        cell.priceL.text = price;
        cell.houseId = house.houseId;
        return cell;
    }
    else {
        RentInTableCell *cell = [self.rentHouseTableView dequeueReusableCellWithIdentifier:[RentInTableCell reuseIdentify] forIndexPath:indexPath];
        RentListInfo *house = self.rentHouseArray[indexPath.row];
        cell.titleL.text = house.title;
        cell.timeL.text = [house.crateDate dateSplitByChinese];
        cell.houseId = house.houseId;
        return cell;
    }
}

@end
