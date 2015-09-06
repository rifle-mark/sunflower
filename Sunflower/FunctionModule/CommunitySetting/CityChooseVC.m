//
//  CityChooseVC.m
//  Sunflower
//
//  Created by mark on 15/4/22.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "GCExtension.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import <AFNetworking.h>

#import "MKWColorHelper.h"
#import "MKWStringHelper.h"
#import "LocationModule.h"

#import "CityChooseVC.h"
#import "CSTableViewCell.h"
#import "ServerProxy.h"
#import "CSSettingModel.h"

@interface CityChooseVC ()

@property(nonatomic,strong)NSArray      *opendCityArray;
@property(nonatomic,assign)BOOL         isLocatedCityChoosed;

@property(nonatomic,strong)UITableView  *cityTableView;

@end

@implementation CityChooseVC

- (NSString *)umengPageName {
    return @"选择城市";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.okBtn setEnabled:NO];
    [self _setupCityTableView];
    _weak(self);

    
    // 开始定位
    [[LocationModule sharedModule] withUpdateToLocationBlock:^(CLLocationManager *manager, CLLocation *toLocation, CLLocation *fromLocation) {
        [[LocationModule sharedModule] stopLocation];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:toLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            _strong(self);
            CLPlacemark *mark = [placemarks lastObject];
            self.locatedCity = [[mark addressDictionary] objectForKey:@"City"];
        }];
    }];
    [[LocationModule sharedModule] withFailedWithErrorBlock:^(CLLocationManager *manager, NSError *error) {
        [[LocationModule sharedModule] stopLocation];
    }];
    [[LocationModule sharedModule] startLocation];
    
    [self _setupObserver];
    
    // 获取开通城市列表
    [[CSSettingModel sharedModel] asyncOpendCityWithPage:@1 pageSize:@20 CacheBlock:^(NSArray *cityArray) {
        _strong(self);
        self.opendCityArray = cityArray;
    } remoteBlock:^(NSArray *cityArray, NSError *error) {
        _strong(self);
        if (!error) {
            self.opendCityArray = cityArray;
            [[CSSettingModel sharedModel] refreshLocalOpendCitysWithArray:cityArray];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    _weak(self);
    [self.cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.view).with.offset(self.topLayoutGuide.length);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-70);
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Private method

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"opendCityArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.cityTableView reloadData];
    }];
}

- (void)_setupCityTableView {
    self.cityTableView = ({
        _weak(self);
        UITableView *v = [[UITableView alloc] init];
        [v registerNib:[UINib nibWithNibName:@"CSCityAreaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GSNoIconTableCell"];
        v.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [v withBlockForSectionNumber:^NSInteger(UITableView *view) {
            return 3;
        }];
        [v withBlockForHeaderHeight:^CGFloat(UITableView *view, NSInteger section) {
            return 45;
        }];
        [v withBlockForHeaderView:^UIView *(UITableView *view, NSInteger section) {
            UIView *retV = [[UIView alloc] init];
            retV.backgroundColor = k_COLOR_GALLERY;
            UIImageView *imgV = [[UIImageView alloc] init];
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            UILabel *titleL = [[UILabel alloc] init];
            titleL.textColor = k_COLOR_GALLERY_F;
            titleL.font = [UIFont systemFontOfSize:12];
            [retV addSubview:imgV];
            [retV addSubview:titleL];
            _weak(retV);
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(retV);
                make.top.equalTo(retV).with.offset(10);
                make.left.equalTo(retV).with.offset(10);
                make.bottom.equalTo(retV).with.offset(-10);
                make.width.equalTo(@25);
            }];
            [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(retV);
                make.top.bottom.equalTo(retV);
                make.left.equalTo(retV).with.offset(45);
                make.right.equalTo(retV).with.offset(-50);
            }];
            if (section == 0) {
                //located city
                imgV.image = [UIImage imageNamed:@"GPSIcon"];
                titleL.text = @"GPS定位城市";
            }
            
            if (section == 1) {
                //opened city
                imgV.image = [UIImage imageNamed:@"CityIcon"];
                titleL.text = @"已开通城市";
            }
            
            if (section == 2) {
                //coming soon
                imgV.image = [UIImage imageNamed:@"CityIcon"];
                titleL.text = @"其它城市正在开通中，敬请期待......";
            }
            return retV;
        }];
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            NSInteger retVal = 0;
            if (section == 0) {
                retVal = 1;
            }
            if (section == 1) {
                retVal = [self.opendCityArray count];
            }
            if (section == 2) {
                retVal = 0;
            }
            return retVal;
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 50;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            CSTableViewCell *cell = [view dequeueReusableCellWithIdentifier:@"GSNoIconTableCell" forIndexPath:path];
            cell.type = City;
            if (path.section == 0) {
                _weak(cell);
                cell.titleText = self.locatedCity;
                if ([MKWStringHelper isNilEmptyOrBlankString:self.locatedCity]) {
                    cell.userInteractionEnabled = YES;
                    cell.titleText = @"正在努力定位...";
                }
                [cell startObserveObject:self forKeyPath:@"locatedCity" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
                    _strong(self);
                    _strong(cell);
                    cell.titleText = self.locatedCity;
                }];
                [cell startObserveObject:self forKeyPath:@"isLocatedCityChoosed" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
                    _strong(cell);
                    _strong(self);
                    [cell.selectedImgV setHidden:!self.isLocatedCityChoosed];
                }];
                if (_city && [self.locatedCity hasPrefix:_city.city]) {
                    [cell selectedStyleWithSelected:YES];
                }
                else {
                    [cell selectedStyleWithSelected:NO];
                }
            }
            if (path.section == 1) {
                cell.titleText = [(OpendCityInfo*)self.opendCityArray[path.row] city];
            }
            
            return cell;
        }];
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if (path.section == 0 && self.locatedCity && self.opendCityArray) {
                BOOL containLocatedCity = NO;
                for (OpendCityInfo *city in self.opendCityArray) {
                    if ([self.locatedCity hasPrefix:city.city]) {
                        containLocatedCity = YES;
                        [self _selectedCity:city];
                        [self.cityTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
                
                if (!containLocatedCity) {
                    [[view cellForRowAtIndexPath:path] setSelected:NO animated:YES];
                    [SVProgressHUD showErrorWithStatus:@"您所在的城市还未开通，敬请期待"];
                }
            }
            if (path.section == 1) {
                [self _selectedCity:[self.opendCityArray objectAtIndex:path.row]];
                if (!self.isLocatedCityChoosed) {
                }
            }
        }];
        v;
    });
    
    [self.view addSubview:self.cityTableView];
}


- (void)_updateLocatedCityStatus {
    self.isLocatedCityChoosed =  NO;
    if ([MKWStringHelper isNilEmptyOrBlankString:self.locatedCity]) {
        return;
    }
    
    NSString *compareTmp = [NSString stringWithFormat:@"%@", self.locatedCity];
    if (![compareTmp hasSuffix:@"市"]) {
        compareTmp = [compareTmp stringByAppendingString:@"市"];
    }
    if ([_city.city isEqualToString:self.locatedCity] || [_city.city isEqualToString:compareTmp]) {
        self.isLocatedCityChoosed = YES;
    }
}

- (void)_selectedCity:(OpendCityInfo *)city {
    if (!city) {
        return;
    }
    
    _city = city;
    
    [self _updateLocatedCityStatus];
    
    [self.okBtn setEnabled:YES];
}

@end
