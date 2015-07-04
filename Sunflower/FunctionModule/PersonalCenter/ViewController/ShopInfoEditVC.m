//
//  ShopInfoEditVC.m
//  Sunflower
//
//  Created by makewei on 15/5/21.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopInfoEditVC.h"

#import "UserModel.h"

#import <Masonry.h>
#import <SVProgressHUD.h>
#import "GCExtension.h"

#import "ShopStoreEditVC.h"

#define k_SHOP_DESC_LENGTH          300

@interface ShopStoreCell : UITableViewCell

@property(nonatomic,strong)UIButton     *deleteBtn;
@property(nonatomic,strong)UILabel      *infoL;
@property(nonatomic,strong)UIImageView  *arrowV;

@property(nonatomic,strong)ShopStoreInfo    *store;

@property(nonatomic,copy)void(^deleteBlock)();

- (instancetype)withDeleteBlock:(void(^)())block;
+ (NSString *)reuseIdentify;
+ (CGFloat)heightWithWidth:(CGFloat)width store:(ShopStoreInfo *)store;
@end

@implementation ShopStoreCell

+ (NSString *)reuseIdentify {
    return @"pc_shop_store_cell";
}

- (instancetype)withDeleteBlock:(void(^)())block {
    self.deleteBlock = block;
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = k_COLOR_WHITE;
        
        self.deleteBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundImage:[UIImage imageNamed:@"edit_clear_btn"] forState:UIControlStateNormal];
            _weak(self);
            [btn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                _strong(self);
                GCBlockInvoke(self.deleteBlock);
            }];
            btn;
        });
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@40);
        }];
        
        self.infoL = ({
            UILabel *l = [[UILabel alloc] init];
            l.numberOfLines = 0;
            l.backgroundColor = k_COLOR_CLEAR;
            l;
        });
        [self.contentView addSubview:self.infoL];
        [self.infoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(40);
            make.right.equalTo(self.contentView).with.offset(-40);
            make.top.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
        }];
        
        self.arrowV = ({
            UIImageView *v = [[UIImageView alloc] init];
            v.image = [UIImage imageNamed:@"right_arrow"];
            v;
        });
        [self.contentView addSubview:self.arrowV];
        [self.arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-15);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@10);
            make.height.equalTo(@20);
        }];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"store" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        self.infoL.attributedText = [[self class] infoAttributeStringWithStore:self.store];
    }];
}

+ (NSDictionary *)_infoAttributes {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 4;
    ps.alignment = NSTextAlignmentLeft;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.lineHeightMultiple = 1;
    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps,};
    return att;
}

+ (NSDictionary *)_nameAttributes {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 4;
    ps.alignment = NSTextAlignmentLeft;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.lineHeightMultiple = 1;
    NSDictionary *att = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps,};
    return att;
}

+ (NSAttributedString *)infoAttributeStringWithStore:(ShopStoreInfo *)store {
    NSMutableAttributedString *retStr = [[NSMutableAttributedString alloc] init];
    [retStr appendAttributedString:[[NSAttributedString alloc] initWithString:store.name attributes:[ShopStoreCell _nameAttributes]]];
    NSMutableString *desc = [[NSMutableString alloc] init];
    [desc appendString:@"\n"];
    [desc appendString:store.address];
    [desc appendString:@"\n"];
    [desc appendString:store.tel];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", desc] attributes:[ShopStoreCell _infoAttributes]];
    [retStr appendAttributedString:str];
    return retStr;
}
+ (CGFloat)heightWithWidth:(CGFloat)width store:(ShopStoreInfo *)store {
    CGRect rect = [[ShopStoreCell infoAttributeStringWithStore:store] boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size.height > 0 ? rect.size.height + 40 : 40;
}

@end

@interface ShopInfoEditVC ()

@property(nonatomic,weak)IBOutlet UIView        *containerV;
@property(nonatomic,strong)UILabel              *titleL;
@property(nonatomic,strong)UIView               *editerContainer;
@property(nonatomic,strong)UITextView           *editV;

@property(nonatomic,strong)UITableView          *storeTableV;

@end

@implementation ShopInfoEditVC

- (NSString *)umengPageName {
    return @"商户信息编辑";
}

- (NSString *)unwindSegueIdentify {
    return @"Segue_ShopEdit_ShopInfo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupTitleL];
    [self _setupEditer];
    
    if (self.editType == ShopSubStore) {
        [self _setupStore];
    }
    
    [self _setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutTitleL];
    [self _layoutEditer];
    if (self.editType == ShopSubStore) {
        [self.navigationItem setRightBarButtonItem:nil];
        [self _layoutStore];
    }
//    [self.view setNeedsUpdateConstraints];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_ShopEdit_StoreEdit"]) {
        ShopStoreEditVC *vc = (ShopStoreEditVC *)segue.destinationViewController;
        vc.store = (ShopStoreInfo *)sender;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"UnSegue_StoreEdit_ShopInfo"]) {
        [self _reloadShopStors];
    }
}

- (IBAction)saveBtnTap:(id)sender {
    if (self.editType == ShopSubStore) {
        return;
    }
    else {
        if ([MKWStringHelper isNilEmptyOrBlankString:self.editV.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入信息"];
            return;
        }
    }
    
    NSString *info = self.editV.text;
    [SVProgressHUD showWithStatus:@"正在保存" maskType:SVProgressHUDMaskTypeClear];
    [[UserModel sharedModel] asyncUpdateShopInfoWithName:(self.editType == ShopName ? info : self.shop.name)
                                                     tel:(self.editType == ShopTel ? info : self.shop.tel)
                                                 address:(self.editType == ShopAddress ? info : self.shop.address)
                                                    logo:self.shop.logo
                                                    desc:(self.editType == ShopDesc ? info : self.shop.shopDesc)
                                             remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                                                 if (!error) {
                                                     [SVProgressHUD showInfoWithStatus:@"保存成功"];
                                                     [self performSegueWithIdentifier:@"Segue_ShopEdit_ShopInfo" sender:nil];
                                                 }
                                                 else {
                                                     [SVProgressHUD showErrorWithStatus:@"保存失败，请检查网络"];
                                                 }
    }];
}

#pragma mark - UI Control setup
- (void)_setupTitleL {
    self.titleL = ({
        UILabel *l = [[UILabel alloc] init];
        l.font = [UIFont boldSystemFontOfSize:18];
        l.textColor = RGB(78, 78, 78);
        l.backgroundColor = k_COLOR_CLEAR;
        if (self.editType == ShopName) {
            l.text = @"商铺名称";
        }
        if (self.editType == ShopTel) {
            l.text = @"商铺电话";
        }
        if (self.editType == ShopDesc) {
            l.text = @"商铺介绍";
        }
        if (self.editType == ShopAddress) {
            l.text = @"商铺地址";
        }
        l;
    });
    
    
    
}
- (void)_layoutTitleL {
    if ([self.titleL superview] || self.editType == ShopSubStore) {
        return;
    }
    [self.containerV addSubview:self.titleL];
    _weak(self);
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.containerV).with.offset(20);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@18);
    }];
}

- (void)_setupEditer {
    if (self.editType == ShopSubStore) {
        return;
    }
    self.editerContainer = ({
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = k_COLOR_WHITE;
        v.layer.cornerRadius = 4;
        v;
    });
    self.editV = ({
        UITextView  *v = [[UITextView alloc] init];
        if (self.editType == ShopTel) {
            v.keyboardType = UIKeyboardTypePhonePad;
        }
        v.editable = YES;
        v.textAlignment = NSTextAlignmentLeft;
        v.font = [UIFont boldSystemFontOfSize:16];
        v.textColor = k_COLOR_GALLERY_F;
        if (self.editType != ShopDesc && self.editType != ShopSubStore) {
            v.textContainerInset = UIEdgeInsetsMake(10, 11, 11, 0);
        }
        else {
            v.textContainerInset = UIEdgeInsetsMake(10, 11, 10, 10);
        }
        v.backgroundColor = k_COLOR_CLEAR;
        
        if (self.editType == ShopName) {
            v.text = self.shop.name;
        }
        if (self.editType == ShopTel) {
            v.text = self.shop.tel;
        }
        if (self.editType == ShopDesc) {
            v.text = self.shop.shopDesc;
        }
        if (self.editType == ShopAddress) {
            v.text = self.shop.address;
        }
        v;
    });
    [self.editerContainer addSubview:self.editV];
    _weak(self);
    [self.editV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.left.equalTo(self.editerContainer);
        
        if (self.editType == ShopDesc) {
            make.right.equalTo(self.editerContainer);
            make.bottom.equalTo(self.editerContainer).with.offset(-40);
        }
        else {
            make.right.equalTo(self.editerContainer).with.offset(-40);
            make.bottom.equalTo(self.editerContainer);
        }
    }];
    
    if (self.editType != ShopDesc) {
        UIButton *clearBtn = [[UIButton alloc] init];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"edit_clear_btn"] forState:UIControlStateNormal];
        [clearBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            self.editV.text = @"";
        }];
        [self.editerContainer addSubview:clearBtn];
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.editerContainer);
            make.centerY.equalTo(self.editerContainer);
            make.width.height.equalTo(@40);
        }];
    }
    else {
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentRight;
        l.font = [UIFont systemFontOfSize:16];
        l.textColor = k_COLOR_BON_JOUR;
        l.text = [NSString stringWithFormat:@"%d", (int)(k_SHOP_DESC_LENGTH-self.editV.text.length)];
        _weak(l);
        [self.editV withBlockForDidChanged:^(UITextView *view) {
            _strong(l);
            l.text = [NSString stringWithFormat:@"%d", (int)(k_SHOP_DESC_LENGTH-view.text.length)];
        }];
        [self.editV withBlockForShouldChangeText:^BOOL(UITextView *view, NSRange range, NSString *text) {
            if (view.text.length >= k_SHOP_DESC_LENGTH) {
                return NO;
            }
            return YES;
        }];
        [self.editerContainer addSubview:l];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.editerContainer).with.offset(-10);
            make.bottom.equalTo(self.editerContainer).with.offset(-10);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
        }];
    }
    
}

- (void)_layoutEditer {
    if ([self.editerContainer superview] || self.editType == ShopSubStore) {
        return;
    }
    
    [self.containerV addSubview:self.editerContainer];
    _weak(self);
    [self.editerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.containerV).with.offset(20);
        make.top.equalTo(self.titleL.mas_bottom).with.offset(10);
        make.width.equalTo(self.containerV).with.offset(-40);
        if (self.editType == ShopName || self.editType == ShopTel ) {
            make.height.equalTo(@40);
        }
        else if (self.editType == ShopAddress) {
            make.height.equalTo(@80);
        }
        else if (self.editType == ShopDesc) {
            make.height.equalTo(@200);
        }
        else {
            make.height.equalTo(@0);
        }
    }];
}

- (void)_setupStore {
    self.storeTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.backgroundColor = k_COLOR_CLEAR;
        [v registerClass:[ShopStoreCell class] forCellReuseIdentifier:[ShopStoreCell reuseIdentify]];
        _weak(self);
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            if ([self.shopStores count] == 0) {
                return 1;
            }
            return [self.shopStores count];
        }];
        [v withBlockForHeaderHeight:^CGFloat(UITableView *view, NSInteger section) {
            return 40;
        }];
        [v withBlockForFooterHeight:^CGFloat(UITableView *view, NSInteger section) {
            return 40;
        }];
        [v withBlockForHeaderView:^UIView *(UITableView *view, NSInteger section) {
            UIView *headerV = [[UIView alloc] init];
            headerV.backgroundColor = RGB(218, 218, 218);
            UILabel *l = [[UILabel alloc] init];
            l.font = [UIFont boldSystemFontOfSize:18];
            l.textColor = k_COLOR_GALLERY_F;
            l.text = @"分店信息";
            [headerV addSubview:l];
            _weak(headerV);
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(headerV);
                make.left.equalTo(headerV).with.offset(20);
                make.right.equalTo(headerV).with.offset(20);
                make.top.equalTo(headerV);
                make.bottom.equalTo(headerV);
            }];
            return headerV;
        }];
        [v withBlockForFooterView:^UIView *(UITableView *view, NSInteger section) {
            UIView *footerV = [[UIView alloc] init];
            footerV.backgroundColor = RGB(218, 218, 218);
            UIImageView *v = [[UIImageView alloc] init];
            v.image = [UIImage imageNamed:@"edit_clear_btn"];
            [footerV addSubview:v];
            _weak(footerV);
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(footerV);
                make.left.equalTo(footerV).with.offset(0);
                make.centerY.equalTo(footerV);
                make.width.height.equalTo(@40);
            }];
            UILabel *l = [[UILabel alloc] init];
            l.font = [UIFont boldSystemFontOfSize:18];
            l.textColor = k_COLOR_GALLERY_F;
            l.text = @"添加分店信息";
            [footerV addSubview:l];
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(footerV);
                make.left.equalTo(footerV).with.offset(40);
                make.right.equalTo(footerV).with.offset(20);
                make.top.equalTo(footerV);
                make.bottom.equalTo(footerV);
            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
                _strong(self);
                [self performSegueWithIdentifier:@"Segue_ShopEdit_StoreEdit" sender:nil];
            }];
            [footerV addGestureRecognizer:tap];
            return footerV;
        }];
        
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if ([self.shopStores count] == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.backgroundColor = k_COLOR_WHITE;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
                cell.textLabel.textColor = k_COLOR_GALLERY_F;
                cell.textLabel.text = @"暂无分店";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                return cell;
            }
            
            ShopStoreCell *cell = [view dequeueReusableCellWithIdentifier:[ShopStoreCell reuseIdentify]];
            if (!cell) {
                cell = [[ShopStoreCell alloc] init];
            }
            cell.store = self.shopStores[path.row];
            _weak(cell);
            cell = [cell withDeleteBlock:^{
                GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"确认删除" andMessage:@"您确认要删除分店吗?"];
                [alert setCancelButtonWithTitle:@"删除" actionBlock:^{
                    _strong(cell);
                    [[UserModel sharedModel] asyncDeleteShopStoreWithShopId:cell.store.shopId remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                        if (error) {
                            [SVProgressHUD showErrorWithStatus:@"删除失败，请检查网络"];
                            return;
                        }
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        NSMutableArray * tmp =[self.shopStores mutableCopy];
                        [tmp removeObject:cell.store];
                        self.shopStores = tmp;
                    }];
                }];
                [alert addOtherButtonWithTitle:@"取消" actionBlock:^{
                    
                }];
                [alert show];
            }];
            return cell;
        }];
        
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if ([self.shopStores count] <= 0) {
                return 80;
            }
            return [ShopStoreCell heightWithWidth:V_W_(self.view)-80 store:self.shopStores[path.row]];
        }];
        
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            if ([self.shopStores count] <= 0) {
                return;
            }
            [self performSegueWithIdentifier:@"Segue_ShopEdit_StoreEdit" sender:self.shopStores[path.row]];
        }];
        v;
    });
}

- (void)_layoutStore {
    if ([self.storeTableV superview] || self.editType != ShopSubStore) {
        return;
    }
    UIView *tmpV = [[UIView alloc]init];
    [self.containerV addSubview:tmpV];
    _weak(self);
    [tmpV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerV).with.offset(-1);
        make.left.right.equalTo(self.containerV);
        make.height.equalTo(@1);
    }];
    [self.containerV addSubview:self.storeTableV];
    
    [self.storeTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.left.right.bottom.equalTo(self.containerV);
    }];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"shopStores" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.storeTableV && [self.storeTableV superview]) {
            [self.storeTableV reloadData];
        }
    }];
}

- (void)_reloadShopStors {
    _weak(self);
    [[UserModel sharedModel] asyncGetShopInfoWithCacheBlock:nil remoteBlock:^(ShopInfo *shop, NSArray *shopStoreList, NSError *error) {
        _strong(self);
        if (!error) {
            self.shopStores = shopStoreList;
        }
    }];
}
@end
