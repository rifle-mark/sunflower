//
//  LocationChoiceVC.m
//  Sunflower
//
//  Created by makewei on 15/6/5.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "LocationChoiceVC.h"
#import "WeiCommentEditVC.h"

#import "LocationModule.h"
#import "CommonModel.h"

@interface LocationChoiceVC ()

@property(nonatomic,weak)IBOutlet UIView       *contentV;

@property(nonatomic,strong)UITableView         *locationTableV;
@property(nonatomic,strong)NSArray             *locationArray;
@end

@implementation LocationChoiceVC

- (NSString *)umengPageName {
    return @"选择地理位置";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_Location_WeiCommentEditer";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    
    _weak(self);
    [[LocationModule sharedModule] withUpdateToLocationBlock:^(CLLocationManager *manager, CLLocation *toLocation, CLLocation *fromLocation) {
        [[LocationModule sharedModule] stopLocation];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:toLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *mark = [placemarks lastObject];
            [[CommonModel sharedModel] asyncLocationAddrWithLatitude:mark.location.coordinate.latitude Longitude:mark.location.coordinate.longitude remoteBlock:^(NSArray *locationList, NSError *error) {
                _strong(self);
                self.locationArray = locationList;
            }];
        }];
    }];
    [[LocationModule sharedModule] withFailedWithErrorBlock:^(CLLocationManager *manager, NSError *error) {
        [[LocationModule sharedModule] stopLocation];
    }];
    [[LocationModule sharedModule] startLocation];
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
    if ([segue.identifier isEqualToString:@"UnSegue_Location_WeiCommentEditer"]) {
        if ([sender isKindOfClass:[LocationAddrInfo class]]) {
            ((WeiCommentEditVC*)segue.destinationViewController).locationName = ((LocationAddrInfo *)sender).name;
        }
    }
}


#pragma mark - Coding Views
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"locationArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.locationTableV reloadData];
    }];
}

- (void)_loadCodingViews {
    if (!self.locationTableV) {
        self.locationTableV = [[UITableView alloc] init];
        self.locationTableV.showsHorizontalScrollIndicator = NO;
        self.locationTableV.showsVerticalScrollIndicator = NO;
        [self.locationTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LocationCellIdentify"];
        
        _weak(self);
        [self.locationTableV withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.locationArray count];
        }];
        
        [self.locationTableV withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:@"LocationCellIdentify"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCellIdentify"];
            }
            
            LocationAddrInfo *info = self.locationArray[path.row];
            cell.textLabel.textColor = k_COLOR_GALLERY_F;
            cell.textLabel.text = info.name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }];
        
        [self.locationTableV withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if (self.unSegueName) {
                [self performSegueWithIdentifier:self.unSegueName sender:self.locationArray[path.row]];
            }
        }];
    }
}

- (void)_layoutCodingViews {
    if (![self.locationTableV superview]) {
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
        
        [self.contentV addSubview:self.locationTableV];
        [self.locationTableV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentV);
        }];
    }
}
@end
