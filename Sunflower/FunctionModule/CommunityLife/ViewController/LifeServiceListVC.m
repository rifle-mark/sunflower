//
//  LifeServiceListVC.m
//  Sunflower
//
//  Created by mark on 15/5/2.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIImageView+AFNetworking.h>
#import "GCExtension.h"

#import "CommunityLifeModel.h"
#import "CommonModel.h"

#import "LifeServiceListVC.h"
#import "LifeServerTableCell.h"
#import "LifeServiceInfoVC.h"

@interface LifeServiceListVC () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView   *serverTableView;

@property(nonatomic,strong)NSArray              *serverArray;
@property(nonatomic,strong)NSNumber             *currentPage;

@end

@implementation LifeServiceListVC
- (NSString *)umengPageName {
    return @"生活服务列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_LifeServiceList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    
    _weak(self);
    [[CommunityLifeModel sharedModel] asyncLifeServerListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] pageIndex:@1 pageSize:@20 cacheBlock:nil remoteBlock:^(NSArray *list, NSInteger page, NSError *error) {
        _strong(self);
        self.serverArray = list;
        self.currentPage = @(page);
        for (LifeServerInfo *info in self.serverArray) {
            [info saveToDb];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_LifeServer_Detail"]) {
        LifeServerTableCell *cell = (LifeServerTableCell*)sender;
        ((LifeServiceInfoVC*)segue.destinationViewController).lifeServer = cell.info;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    
}


- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"serverArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.serverTableView reloadData];
    }];
}


#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.serverArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LifeServerTableCell *cell = [self.serverTableView dequeueReusableCellWithIdentifier:[LifeServerTableCell reuseIdentify] forIndexPath:indexPath];
    LifeServerInfo *server = self.serverArray[indexPath.row];
    cell.logoV.contentMode = UIViewContentModeScaleToFill;
    cell.logoV.clipsToBounds = YES;
    [cell.logoV sd_setImageWithURL:[APIGenerator urlOfPictureWith:77 height:77 urlString:server.image] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    cell.nameL.text = server.title;
    cell.subTitleL.text = server.subTitle;
    cell.telL.text = server.tel;
    cell.info = server;
    return cell;
}
@end
