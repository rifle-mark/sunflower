//
//  MyRentVC.m
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MyRentVC.h"
#import "RentInVC.h"
#import "RentSaleOutVC.h"

#import "UserModel.h"


static NSInteger    c_PageSize = 10;

@interface MyRentCell : UITableViewCell

@property(nonatomic,strong)UIView       *contentV;
@property(nonatomic,strong)UIButton     *selectBtn;
@property(nonatomic,strong)UIButton     *deleteBtn;

@property(nonatomic,strong)UIView       *showV;
@property(nonatomic,strong)UIImageView  *imageV;
@property(nonatomic,strong)UILabel      *titleL;
@property(nonatomic,strong)UILabel      *roomL;
@property(nonatomic,strong)UILabel      *priceL;

@property(nonatomic,strong)RentListInfo *house;
@property(nonatomic,assign)BOOL         isHouseEdit;
@property(nonatomic,assign)BOOL         isHouseSelected;

@property(nonatomic,copy)void(^houseDeleteBlock)(RentListInfo *coupon);
@property(nonatomic,copy)void(^houseSelectBlock)(RentListInfo *coupon, BOOL isSelected);

+ (NSString *)reuseIdentify;
- (void)setIsHouseEdit:(BOOL)isHouseEdit animated:(BOOL)animate;
@end

@implementation MyRentCell

+ (NSString *)reuseIdentify {
    return @"MyRentCellIdentify";
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _isHouseEdit = NO;
        _weak(self);
        self.contentV = [[UIView alloc] init];
        self.contentV.clipsToBounds = YES;
        [self.contentView addSubview:self.contentV];
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(13);
            make.right.equalTo(self.contentView).with.offset(-13);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.selectBtn = [[UIButton alloc] init];
        [self.selectBtn setImage:[UIImage imageNamed:@"mycell_select_btn_n"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"mycell_select_btn_h"] forState:UIControlStateHighlighted];
        [self.selectBtn setImage:[UIImage imageNamed:@"mycell_select_btn_s"] forState:UIControlStateSelected];
        [self.contentV addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.bottom.equalTo(self.contentV);
            make.width.equalTo(@37);
        }];
        [self.selectBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            [self.selectBtn setSelected:!self.selectBtn.isSelected];
            GCBlockInvoke(self.houseSelectBlock, self.house, self.selectBtn.isSelected);
        }];
        
        self.deleteBtn = [[UIButton alloc] init];
        self.deleteBtn.backgroundColor = RGB(255, 153, 153);
        [self.deleteBtn setImage:[UIImage imageNamed:@"mycell_delete_btn"] forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
        self.deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-22, 15, 0, 0);
        self.deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(22, -15, 0, 0);
        self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.contentV addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.top.bottom.equalTo(self.contentV);
            make.width.equalTo(@50);
        }];
        [self.deleteBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            GCBlockInvoke(self.houseDeleteBlock, self.house);
        }];
        
        self.showV = [[UIView alloc] init];
        self.showV.backgroundColor = k_COLOR_WHITE;
        [self.contentV addSubview:self.showV];
        [self.showV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentV);
        }];
        
        self.imageV = [[UIImageView alloc] init];
        [self.showV addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.showV).with.offset(13);
            make.left.equalTo(self.showV).with.offset(17);
            make.width.height.equalTo(@70);
        }];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.font = [UIFont boldSystemFontOfSize:14];
        self.titleL.textColor = k_COLOR_COUPON_TEXT;
        self.titleL.numberOfLines = 2;
        [self.showV addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.showV).with.offset(32);
            make.left.equalTo(self.imageV.mas_right).with.offset(15);
            make.right.equalTo(self.showV);
            make.height.equalTo(@14);
        }];
        
        self.priceL = [[UILabel alloc] init];
        self.priceL.font = [UIFont systemFontOfSize:11];
        self.priceL.textColor = k_COLOR_COUPON_TEXT;
        self.priceL.textAlignment = NSTextAlignmentRight;
        [self.showV addSubview:self.priceL];
        [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.titleL.mas_bottom).with.offset(17);
            make.right.equalTo(self.titleL);
            make.width.equalTo(@70);
            make.height.equalTo(@11);
        }];
        
        self.roomL = [[UILabel alloc] init];
        self.roomL.font = [UIFont boldSystemFontOfSize:11];
        self.roomL.textColor = k_COLOR_COUPON_TEXT;
        [self.showV addSubview:self.roomL];
        [self.roomL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.priceL);
            make.left.equalTo(self.titleL);
            make.right.equalTo(self.priceL.mas_left).with.offset(-17);
            make.height.equalTo(@11);
        }];
        
        
        
        
        UISwipeGestureRecognizer *lswip = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            if (self.isHouseEdit) {
                return;
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    _strong(self);
                    make.left.equalTo(self.contentV).with.offset(-50);
                    make.top.bottom.equalTo(self.contentV);
                    make.width.equalTo(self.contentV);
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }];
        lswip.numberOfTouchesRequired = 1;
        lswip.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.showV addGestureRecognizer:lswip];
        
        UISwipeGestureRecognizer *rswip = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            if (self.isHouseEdit) {
                return;
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    _strong(self);
                    make.left.equalTo(self.contentV).with.offset(0);
                    make.top.bottom.equalTo(self.contentV);
                    make.width.equalTo(self.contentV);
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }];
        rswip.numberOfTouchesRequired = 1;
        rswip.direction = UISwipeGestureRecognizerDirectionRight;
        [self.showV addGestureRecognizer:rswip];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = k_COLOR_GALLERY;
        [self.contentView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        [self _setupObserver];
        
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"house" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.imageV sd_setImageWithURL:[APIGenerator urlOfPictureWith:70 height:70 urlString:self.house.image] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.titleL.text = self.house.title;
        self.roomL.text = [NSString stringWithFormat:@"%@室%@厅%@卫", self.house.room, self.house.hall, self.house.toilet];
        NSString *price = @"";
        if ([self.house.type integerValue] == 1) {
            price = [NSString stringWithFormat:@"%@/月", self.house.endPrice];
        }
        if ([self.house.type integerValue] == 2) {
            price = [NSString stringWithFormat:@"%@万元", self.house.price];
        }
        self.priceL.text = price;
    }];
    
    [self startObserveObject:self forKeyPath:@"isHouseEdit" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _strong(self);
            [self.showV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentV).with.offset(self.isHouseEdit?37:0);
                make.top.bottom.width.equalTo(self.contentV);
            }];
            
            [self layoutIfNeeded];
        }];
    }];
}

- (BOOL)isHouseSelected {
    return [self.selectBtn isSelected];
}

- (void)setIsHouseSelected:(BOOL)isHouseSelected {
    [self.selectBtn setSelected:isHouseSelected];
}

- (void)setIsHouseEdit:(BOOL)isHouseEdit animated:(BOOL)animate {
    if (animate) {
        self.isHouseEdit = isHouseEdit;
    }
    else {
        _isHouseEdit = isHouseEdit;
    }
}

@end

@interface MyRentVC ()
@property(nonatomic,weak)IBOutlet UIView        *contentV;

@property(nonatomic,strong)UITableView          *rentTableV;
@property(nonatomic,strong)NSArray              *rentList;
@property(nonatomic,strong)NSMutableArray       *selectedRentList;
@property(nonatomic,strong)NSNumber             *cPage;

@property(nonatomic,assign)BOOL                 isEdit;
@end

@implementation MyRentVC

- (NSString *)umengPageName {
    return @"我的租凭列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_MyRent";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_edit_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(_houseEditTap:)];
    editItem.tintColor = k_COLOR_WHITE;
    self.navigationItem.rightBarButtonItem = editItem;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    self.selectedRentList = [@[] mutableCopy];
    
    [self _setupObserver];
    [self.rentTableV.header beginRefreshing];
}

- (void)loadView {
    [super loadView];
    
    [self _loadRentTableV];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutRentTableV];
    FixesViewDidLayoutSubviewsiOS7Error;
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
    if ([segue.identifier isEqualToString:@"Segue_MyRentList_RentOutSale"]) {
        RentListInfo *house = (RentListInfo *)sender;
        ((RentSaleOutVC*)segue.destinationViewController).houseId = house.houseId;
    }
    if ([segue.identifier isEqualToString:@"Segue_MyRentList_RentIn"]) {
        RentListInfo *house = (RentListInfo *)sender;
        ((RentInVC*)segue.destinationViewController).houseId = house.houseId;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
}

 
- (void)_houseEditTap:(id)sender {
    __block BOOL edit = !self.isEdit;
    _weak(self);
    if (!edit && [self.selectedRentList count] > 0) {
        NSMutableArray *houseIdArray = [[NSMutableArray alloc] initWithCapacity:[self.selectedRentList count]];
        for (RentListInfo *info in self.selectedRentList) {
            [houseIdArray addObject:info.houseId];
        }
        
        [[UserModel sharedModel] asyncDeleteMyHouseWithArray:houseIdArray remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
            _strong(self);
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"成功删除"];
                [self _loadRentHouseAtPage:@1 pageSize:@(c_PageSize)];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"操作失败"];
            }
            [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"navi_edit_btn"]];
            [self _setHouseListEdit:edit];
            self.isEdit = edit;
            [self.selectedRentList removeAllObjects];
        }];
    }
    
    
    else if (!edit) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"navi_edit_btn"]];
        [self _setHouseListEdit:edit];
        self.isEdit = edit;
    }
    
    if (edit) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_cancel"]];
        [self _setHouseListEdit:edit];
        self.isEdit = edit;
    }
}

- (void)_setHouseListEdit:(BOOL)edit {
    for (MyRentCell *cell in [self.rentTableV visibleCells]) {
        cell.isHouseSelected = NO;
        cell.isHouseEdit = edit;
        [self.selectedRentList removeAllObjects];
    }
}

#pragma mark - data
- (void)_loadRentHouseAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[UserModel sharedModel] asyncGetUserHouseListAtPage:page pageSize:pageSize cacheBlock:^(NSArray *houseList) {
        
    } remoteBlock:^(NSArray *houseList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if ([self.rentTableV.header isRefreshing]) {
            [self.rentTableV.header endRefreshing];
        }
        if ([self.rentTableV.footer isRefreshing]) {
            [self.rentTableV.footer endRefreshing];
        }
        if (!error) {
            if ([cPage integerValue] == 1) {
                self.cPage = cPage;
                self.rentList = houseList;
                return;
            }
            if ([houseList count] > 0) {
                self.cPage = cPage;
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.rentList];
                [tmp addObjectsFromArray:houseList];
                self.rentList = tmp;
            }
            
        }
    }];
}


#pragma mark - private
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"rentList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.rentTableV reloadData];
        if ([self.rentList count] > 0) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }
    }];
}

- (void)_loadRentTableV {
    self.rentTableV = ({
        UITableView *v = [[UITableView alloc] init];
        [v registerClass:[MyRentCell class] forCellReuseIdentifier:[MyRentCell reuseIdentify]];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        _weak(self);
        
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _loadRentHouseAtPage:@1 pageSize:@(c_PageSize)];
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadRentHouseAtPage:@([self.cPage integerValue]+1) pageSize:@(c_PageSize)];
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            return [self.rentList count];
        }];
        
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 110;
        }];
        
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            MyRentCell *cell = [view dequeueReusableCellWithIdentifier:[MyRentCell reuseIdentify]];
            if (!cell) {
                cell = [[MyRentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyRentCell reuseIdentify]];
            }
            RentListInfo *house = (RentListInfo*)self.rentList[path.row];
            
            cell.house = house;
            [cell setIsHouseEdit:self.isEdit animated:NO];
            cell.houseDeleteBlock = ^(RentListInfo *house){
                _strong(self);
                [[UserModel sharedModel] asyncDeleteMyHouseWithId:house.houseId remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [self _loadRentHouseAtPage:@1 pageSize:@(c_PageSize)];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }
                }];
            };
            cell.houseSelectBlock = ^(RentListInfo *coupon, BOOL isSelected) {
                _strong(self);
                if (isSelected) {
                    [self.selectedRentList addObject:coupon];
                    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_delete"]];
                }
                else {
                    [self.selectedRentList removeObject:coupon];
                    if ([self.selectedRentList count] == 0) {
                        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"pc_info_cancel"]];
                    }
                }
            };
            return cell;
        }];
        
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            RentListInfo *house = self.rentList[path.row];
            if ([house.type integerValue] == 3) {
                [self performSegueWithIdentifier:@"Segue_MyRentList_RentIn" sender:house];
            }
            else {
                [self performSegueWithIdentifier:@"Segue_MyRentList_RentOutSale" sender:house];
            }
        }];
        v;
    });
}

- (void)_layoutRentTableV {
    if ([self.rentTableV superview]) {
        return;
    }
    
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
    
    [self.contentV addSubview:self.rentTableV];
    [self.rentTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.top.bottom.equalTo(self.contentV);
    }];
}

@end
