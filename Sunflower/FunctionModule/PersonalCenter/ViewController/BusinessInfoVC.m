//
//  BusinessInfoVC.m
//  Sunflower
//
//  Created by makewei on 15/5/19.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "BusinessInfoVC.h"
#import "GCExtension.h"
#import <UIImageView+AFNetworking.h>

#import "ShopInfoCell.h"
#import "ShopLogoCell.h"
#import "ShopInfoEditVC.h"

#import "UserModel.h"
#import "CommonModel.h"
#import "EYImagePickerViewController.h"

@interface BusinessInfoVC ()

@property(nonatomic,weak)IBOutlet UITableView       *infoTableV;

@property(nonatomic,strong)ShopInfo             *shop;
@property(nonatomic,strong)NSArray              *shopStoreList;
@property(nonatomic,assign)BOOL                 shouldUpdate;
@end

@implementation BusinessInfoVC

- (NSString *)umengPageName {
    return @"商户信息";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_BusinessInfo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    // get shop info
    [self _getShopInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.infoTableV.delegate && self.infoTableV.dataSource) {
        return;
    }
    
    _weak(self);
    [self.infoTableV withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
        _strong(self);
        if (!self.shop) {
            return 0;
        }
        return 6;
    }];
    
    [self.infoTableV withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
        _strong(self);
        if (!self.shop) {
            return [[UITableViewCell alloc] init];
        }
        if (path.row == 0) {
            ShopLogoCell *cell = [view dequeueReusableCellWithIdentifier:[ShopLogoCell reuseIdentify]];
            [cell.logoV setImageWithURL:[NSURL URLWithString:self.shop.logo] placeholderImage:nil];
            return cell;
        }
        if (path.row == 1) {
            ShopInfoCell *cell = [view dequeueReusableCellWithIdentifier:[ShopInfoCell reuseIdentify]];
            cell.titleL.text = @"商铺名称";
            cell.infoL.text = self.shop.name;
            return cell;
        }
        if (path.row == 2) {
            ShopInfoCell *cell = [view dequeueReusableCellWithIdentifier:[ShopInfoCell reuseIdentify]];
            cell.titleL.text = @"商铺电话";
            cell.infoL.text = self.shop.tel;
            return cell;
        }
        if (path.row == 3) {
            ShopInfoCell *cell = [view dequeueReusableCellWithIdentifier:[ShopInfoCell reuseIdentify]];
            cell.titleL.text = @"商铺地址";
            cell.infoL.numberOfLines = 0;
            cell.infoL.attributedText = [ShopInfoCell shopDescAttributeStringWithDesc:self.shop.address];
            return cell;
        }
        if (path.row == 4) {
            ShopInfoCell *cell = [view dequeueReusableCellWithIdentifier:[ShopInfoCell reuseIdentify]];
            cell.titleL.text = @"商铺介绍";
            cell.infoL.numberOfLines = 0;
            cell.infoL.attributedText = [ShopInfoCell shopDescAttributeStringWithDesc:self.shop.shopDesc];
            return cell;
        }
        if (path.row == 5) {
            ShopInfoCell *cell = [view dequeueReusableCellWithIdentifier:[ShopInfoCell reuseIdentify]];
            cell.titleL.text = @"分店信息";
            cell.infoL.numberOfLines = 0;
            cell.infoL.attributedText = [ShopInfoCell shopStoreAttributeStringWithStores:self.shopStoreList];
            return cell;
        }
        return nil;
    }];
    
    [self.infoTableV withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
        _strong(self);
        if (path.row == 0) {
            return 84;
        }
        if (path.row == 1 || path.row == 2) {
            return 63;
        }
        if (path.row == 3) {
            if (self.shop) {
                return [ShopInfoCell shopDescCellHeighWithDescStr:self.shop.address width:V_W_(self.view)-180];
            }
            return 63;
        }
        if (path.row == 4) {
            if (self.shop) {
                return [ShopInfoCell shopDescCellHeighWithDescStr:self.shop.shopDesc width:V_W_(self.view)-180];
            }
            return 63;
        }
        if (path.row == 5) {
            if (self.shopStoreList && [self.shopStoreList count] > 0) {
                return [ShopInfoCell shopStorHeightWithStores:self.shopStoreList width:V_W_(self.view)-180];
            }
            return 63;
        }
        return 0;
    }];
    
    [self.infoTableV withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
        if (path.row == 0) {
            void (^SetupEYImagePicker)(EYImagePickerViewController* picker) =
            ^(EYImagePickerViewController* picker) {
                _strong(self);
                picker.dismissBlock = ^(NSDictionary* userInfo) {
                    _strong(self);
                    [self dismissViewControllerAnimated:YES completion:nil];
                };
                [picker withBlockForDidFinishPickingMediaUsingFilePath:^(EYImagePickerViewController *picker, UIImage *thumbnail, NSString *filePath) {
                    _strong(self);
                    [self dismissViewControllerAnimated:NO completion:^{
                        [SVProgressHUD showWithStatus:@"正在保存店标" maskType:SVProgressHUDMaskTypeClear];
                        [[CommonModel sharedModel] uploadImage:thumbnail path:filePath progress:nil remoteBlock:^(NSString *url, NSError *error) {
                            _strong(self);
                            if (!error) {
                                [[UserModel sharedModel] asyncUpdateShopInfoWithName:self.shop.name tel:self.shop.tel address:self.shop.address logo:url desc:self.shop.shopDesc remoteBlock:^(BOOL isSuccess, NSString *msg, NSError *error) {
                                    _strong(self);
                                     if (!error) {
                                         ShopLogoCell *cell = (ShopLogoCell*)[self.infoTableV cellForRowAtIndexPath:path];
                                         cell.logoV.image = thumbnail;
                                         [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                                     }
                                     else {
                                         [SVProgressHUD showErrorWithStatus:@"保存失败，请检查网络"];
                                     }
                                }];
                            }
                            else {
                                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                            }
                        }];
                        
                    }];
                }];
                [self presentViewController:picker animated:YES completion:nil];
            };
            
            // 文本，小视频，本地视频，拍照，手机相册选择
            GCActionSheet* as = [[GCActionSheet alloc] initWithTitle:@""];
            
            [as setCancelButtonTitle:@"取消" actionBlock:nil];
            
            if ([EYImagePickerViewController isCameraPhotoAvailable]) {
                [as addOtherButtonTitle:@"拍照" actionBlock:^{
                    EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForCameraPhotoEditable:YES];
                    SetupEYImagePicker(picker);
                }];
            }
            
            if ([EYImagePickerViewController isLibraryPhotoAvailable]) {
                [as addOtherButtonTitle:@"手机相册" actionBlock:^{
                    EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForLibraryPhotoEditable:YES];
                    SetupEYImagePicker(picker);
                }];
            }
            [as showInView:self.view];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[ShopInfoCell class]] && [segue.identifier isEqualToString:@"Segue_ShopInfo_Edit"]) {
        ShopInfoCell *cell = (ShopInfoCell *)sender;
        ShopInfoEditVC *vc = (ShopInfoEditVC*)[segue destinationViewController];
        
        if ([cell.titleL.text isEqualToString:@"商铺名称"]) {
            vc.editType = ShopName;
        }
        if ([cell.titleL.text isEqualToString:@"商铺电话"]) {
            vc.editType = ShopTel;
        }
        if ([cell.titleL.text isEqualToString:@"商铺地址"]) {
            vc.editType = ShopAddress;
        }
        if ([cell.titleL.text isEqualToString:@"商铺介绍"]) {
            vc.editType = ShopDesc;
        }
        if ([cell.titleL.text isEqualToString:@"分店信息"]) {
            vc.editType = ShopSubStore;
        }
        vc.shop = self.shop;
        vc.shopStores = self.shopStoreList;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"Segue_ShopEdit_ShopInfo"]) {
        [self _getShopInfo];
    }
}

#pragma mark - Business Logic
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"shouldUpdate" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        if (self.shouldUpdate == YES) {
            [self.infoTableV reloadData];
        }
    }];
}

- (void)_getShopInfo {
    _weak(self);
    [[UserModel sharedModel] asyncGetShopInfoWithCacheBlock:nil remoteBlock:^(ShopInfo *shop, NSArray *shopStoreList, NSError *error){
        _strong(self);
        if (!error) {
            self.shop = shop;
            self.shopStoreList = shopStoreList;
            self.shouldUpdate = YES;
        }
    }];
}
@end
