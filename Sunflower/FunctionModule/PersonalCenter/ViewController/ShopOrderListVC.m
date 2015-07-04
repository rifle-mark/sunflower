//
//  ShopOrderListVC.m
//  Sunflower
//
//  Created by makewei on 15/5/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopOrderListVC.h"

#import "GCExtension.h"
#import <UIImageView+AFNetworking.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import <SVProgressHUD.h>

#import "UserModel.h"

@interface ShopOrderCell : UITableViewCell

@property(nonatomic,strong)UIImageView      *avatarV;
@property(nonatomic,strong)UILabel          *nameL;
@property(nonatomic,strong)UILabel          *productL;
@property(nonatomic,strong)UILabel          *endDateL;
@property(nonatomic,strong)UIButton         *useBtn;

@property(nonatomic,assign)BOOL             isUsed;
@property(nonatomic,copy)void(^useBlock)(ShopOrderCell *cell);

+ (NSString *)reuseIdentify;

@end

@implementation ShopOrderCell

+(NSString *)reuseIdentify {
    return @"ShopOrderCellIdentify";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = k_COLOR_CLEAR;
        
        self.avatarV = ({
            UIImageView *v = [[UIImageView alloc] init];
            v.clipsToBounds = YES;
            v.layer.cornerRadius = 32.0;
            v;
        });
        [self.contentView addSubview:self.avatarV];
        _weak(self);
        [self.avatarV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView);
            make.height.width.equalTo(@64);
            make.left.equalTo(self.contentView).with.offset(10);
        }];
        
        self.useBtn = ({
            UIButton *b = [[UIButton alloc] init];
            b.backgroundColor = k_COLOR_BLUE;
            b.layer.cornerRadius = 4;
            b.titleLabel.font = [UIFont systemFontOfSize:14];
            [b setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
            [b setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
            [b setTitle:@"未使用" forState:UIControlStateNormal];
            [b addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                _strong(self);
                GCBlockInvoke(self.useBlock, self);
            }];
            b;
        });
        [self.contentView addSubview:self.useBtn];
        [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@64);
            make.height.equalTo(@32);
        }];
        
        UILabel *(^cellLabelBlock)() =^(){
            UILabel *l = [[UILabel alloc] init];
            l.textColor = k_COLOR_GALLERY_F;
            l.font = [UIFont boldSystemFontOfSize:14];
            l.backgroundColor = k_COLOR_CLEAR;
            return l;
        };
        self.nameL = cellLabelBlock();
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(20);
            make.left.equalTo(self.avatarV.mas_right).with.offset(20);
            make.right.equalTo(self.useBtn.mas_left).with.offset(10);
            make.height.equalTo(@14);
        }];
        
        self.productL = cellLabelBlock();
        [self.contentView addSubview:self.productL];
        [self.productL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nameL.mas_bottom).with.offset(2);
            make.left.right.height.equalTo(self.nameL);
        }];
        
        self.endDateL = cellLabelBlock();
        [self.contentView addSubview:self.endDateL];
        [self.endDateL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.productL.mas_bottom).with.offset(2);
            make.left.right.height.equalTo(self.nameL);
        }];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"isUsed" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.isUsed) {
            [self.useBtn setBackgroundColor:k_COLOR_GALLERY_F];
            [self.useBtn setTitle:@"已使用" forState:UIControlStateNormal];
            [self.useBtn setTitle:@"已使用" forState:UIControlStateDisabled];
            [self.useBtn setEnabled:NO];
        }
        else {
            [self.useBtn setBackgroundColor:k_COLOR_BLUE];
            [self.useBtn setTitle:@"未使用" forState:UIControlStateNormal];
            [self.useBtn setTitle:@"未使用" forState:UIControlStateHighlighted];
            [self.useBtn setEnabled:YES];
        }
    }];
}

@end

@interface ShopOrderListVC ()

@property(nonatomic,weak)IBOutlet UIView            *contentV;
@property(nonatomic,strong)UITableView              *orderTableV;

@property(nonatomic,strong)NSArray                  *orderList;
@property(nonatomic,strong)NSString                 *searchKey;
@property(nonatomic,strong)NSNumber                 *currentPage;
@property(nonatomic,weak)UITextField                *focusedT;

@end

@implementation ShopOrderListVC

- (NSString *)umengPageName {
    return @"商户优惠券预约用户列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_ShopOrderList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchKey = @"";
    [self _setupObserver];
    [self _getCouponUserListAtPage:@1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    
    [self _loadOrderTableV];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutOrderTableV];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)_loadOrderTableV {
    self.orderTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.backgroundColor = k_COLOR_WHITE;
        _weak(self);
        [v registerClass:[ShopOrderCell class] forCellReuseIdentifier:[ShopOrderCell reuseIdentify]];
        
        [v withBlockForHeaderHeight:^CGFloat(UITableView *view, NSInteger section) {
            return 64;
        }];
        
        [v withBlockForHeaderView:^UIView *(UITableView *view, NSInteger section) {
            UIView *ret = [[UIView alloc] init];
            ret.backgroundColor = RGB(243, 243, 243);
            
            UITextField *t = [[UITextField alloc] init];
//            t.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg"]];
            t.backgroundColor = k_COLOR_CLEAR;
            t.layer.borderColor = [k_COLOR_GALLERY_F CGColor];
            t.layer.borderWidth = 1;
            t.layer.cornerRadius = 19;
            t.textColor = k_COLOR_GALLERY_F;
            t.font = [UIFont systemFontOfSize:14];
            t.placeholder = @"搜索预约用户";
            _weak(t);
            [t withBlockForDidBeginEditing:^(UITextField *view) {
                _strong(self);
                self.focusedT = view;
            }];
            t.returnKeyType = UIReturnKeyDone;
            [t withBlockForDidEndEditing:^(UITextField *view) {
                _strong(t);
                [t resignFirstResponder];
            }];
            
            UIButton *searchBtn = [[UIButton alloc] init];
            
            [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateNormal];
            [searchBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                _strong(t);
                [t resignFirstResponder];
                if ([MKWStringHelper isNilEmptyOrBlankString:[MKWStringHelper trimWithStr:t.text]]) {
                    [SVProgressHUD showErrorWithStatus:@"请输入搜索关键字"];
                    return;
                }
                
                _strong(self);
                self.searchKey = [MKWStringHelper trimWithStr:t.text];
                [self _getCouponUserListAtPage:@1];
            }];
            
            _weak(ret);
            [ret addSubview:t];
            [t mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(ret);
                make.centerY.equalTo(ret);
                make.left.equalTo(ret).with.offset(16);
                make.right.equalTo(ret).with.offset(-16);
                make.height.equalTo(@38);
            }];
            [ret addSubview:searchBtn];
            [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(t);
                make.top.bottom.right.equalTo(t);
                make.width.equalTo(@44);
            }];
            
            return ret;
        }];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            return [self.orderList count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 90;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            ShopOrderCell *cell = [view dequeueReusableCellWithIdentifier:[ShopOrderCell reuseIdentify]];
            if (!cell) {
                cell = [[ShopOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ShopOrderCell reuseIdentify]];
            }
            CouponUserInfo *info = (CouponUserInfo *)self.orderList[path.row];
            [cell.avatarV setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
            cell.nameL.text = [NSString stringWithFormat:@"昵称：%@", info.nickName];
            cell.productL.text = [NSString stringWithFormat:@"优惠产品：%@", info.couponName];
            cell.endDateL.text = [NSString stringWithFormat:@"优惠截止日期：%@", [info.endDate dateSplitBySplash]];
            cell.isUsed = [info.beUsed boolValue];
            cell.useBlock = ^(ShopOrderCell *cell) {
                [[UserModel sharedModel] asyncSetOrderUsedWithId:info.orderId remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                    if (isSuccess) {
                        cell.isUsed = YES;
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:@"操作失败，请检查网络"];
                    }
                }];
            };
            return cell;
        }];
        v;
    });
}

- (void)_layoutOrderTableV {
    if ([self.orderTableV superview]) {
        return;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
        if (self.focusedT) {
            [self.focusedT resignFirstResponder];
        }
    }];
    [self.contentV addGestureRecognizer:tap];
    
    UIView *tmpV = [[UIView alloc] init];
    tmpV.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:tmpV];
    _weak(self);
    [tmpV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(-1);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    [self.contentV addSubview:self.orderTableV];
    [self.orderTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.left.right.bottom.equalTo(self.contentV);
    }];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"orderList" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.orderTableV reloadData];
//        if ([self.orderList count] > 0) {
//            [self.orderTableV reloadData];
//        }
    }];
}
- (void)_getCouponUserListAtPage:(NSNumber *)page{
    _weak(self);
    [[UserModel sharedModel] asyncGetOrderUserWithKey:self.searchKey page:@1 pageSize:@10 remoteBlock:^(NSArray *orderList, NSNumber *cPage, NSError *error) {
        _strong(self);
        if (!error) {
            self.orderList = orderList;
            self.currentPage = cPage;
        }
    }];
}

@end
