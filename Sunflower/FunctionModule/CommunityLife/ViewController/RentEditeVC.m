//
//  RentEditeVC.m
//  Sunflower
//
//  Created by mark on 15/5/6.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "RentEditeVC.h"

#import <Masonry.h>
#import "GCExtension.h"
#import "GCActionSheet.h"
#import "UIImagePickerController+GCDelegateBlock.h"

#import "CommunityLifeModel.h"
#import "CSSettingModel.h"
#import "CommonModel.h"
#import "EYImagePickerViewController.h"
#import "MKWStringHelper.h"

#import <SVProgressHUD.h>

@interface RentEditeVC ()

@property(nonatomic,weak)IBOutlet UITextField           *nameT;
@property(nonatomic,weak)IBOutlet UITextField           *tellT;

@property(nonatomic,weak)IBOutlet UIScrollView          *rentOutV;
@property(nonatomic,weak)IBOutlet UIView                *rentOutContainerV;
@property(nonatomic,weak)IBOutlet UITextField           *routTitleT;
@property(nonatomic,weak)IBOutlet UIButton              *routAreaB;
@property(nonatomic,weak)IBOutlet UIButton              *routRoomB;
@property(nonatomic,weak)IBOutlet UIButton              *routHallB;
@property(nonatomic,weak)IBOutlet UIButton              *routTolietB;
@property(nonatomic,weak)IBOutlet UITextField           *routSquareT;
@property(nonatomic,weak)IBOutlet UIButton              *routFloorB;
@property(nonatomic,weak)IBOutlet UIButton              *routFixB;
@property(nonatomic,weak)IBOutlet UIButton              *routOrientationB;
@property(nonatomic,weak)IBOutlet UIButton              *routCheckInB;
@property(nonatomic,weak)IBOutlet UITextField           *routPriceT;
@property(nonatomic,weak)IBOutlet UITextView            *routDescT;

@property(nonatomic,weak)IBOutlet UIScrollView          *sellOutV;
@property(nonatomic,weak)IBOutlet UIView                *sellOutContainerV;
@property(nonatomic,weak)IBOutlet UITextField           *soutTitleT;
@property(nonatomic,weak)IBOutlet UIButton              *soutAreaB;
@property(nonatomic,weak)IBOutlet UIButton              *soutRoomB;
@property(nonatomic,weak)IBOutlet UIButton              *soutHallB;
@property(nonatomic,weak)IBOutlet UIButton              *soutTolietB;
@property(nonatomic,weak)IBOutlet UITextField           *soutSquareT;
@property(nonatomic,weak)IBOutlet UIButton              *soutFloorB;
@property(nonatomic,weak)IBOutlet UIButton              *soutFixB;
@property(nonatomic,weak)IBOutlet UIButton              *soutOrientationB;
@property(nonatomic,weak)IBOutlet UIButton              *soutCheckInB;
@property(nonatomic,weak)IBOutlet UITextField           *soutPriceT;
@property(nonatomic,weak)IBOutlet UITextView            *soutDescT;

@property(nonatomic,weak)IBOutlet UIScrollView          *rentInV;
@property(nonatomic,weak)IBOutlet UIView                *rentInContainerV;
@property(nonatomic,weak)IBOutlet UITextField           *rinTitleT;
@property(nonatomic,weak)IBOutlet UITextView            *rinDescT;

@property(nonatomic,weak)IBOutlet UIButton              *rentOutTypeBtn;
@property(nonatomic,weak)IBOutlet UIButton              *sellOutTypeBtn;
@property(nonatomic,weak)IBOutlet UIButton              *rentInTypeBtn;

@property(nonatomic,strong)UITableView                  *selectionView;
@property(nonatomic,strong)NSArray                      *selectionArray;

@property(nonatomic,strong)RentHouseInfo                *routHouse;
@property(nonatomic,strong)NSMutableArray               *routImageArray;
@property(nonatomic,strong)RentHouseInfo                *soutHouse;
@property(nonatomic,strong)NSMutableArray               *soutImageArray;
@property(nonatomic,strong)RentHouseInfo                *rinHouse;

@end

@implementation RentEditeVC

- (NSString *)umengPageName {
    return @"租凭信息-编辑";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_RentEdit";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.routImageArray = [@[@"",@"",@"",@"",@""] mutableCopy];
    self.soutImageArray = [@[@"",@"",@"",@"",@""] mutableCopy];
    self.routHouse = [[RentHouseInfo alloc] init];
    self.soutHouse = [[RentHouseInfo alloc] init];
    self.rinHouse = [[RentHouseInfo alloc] init];
    [self _setupSelectionView];
    
    [self _setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    _weak(self);
    [self.rentOutContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
    }];
    [self.sellOutContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
    }];
    [self.rentInContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.width.equalTo(self.view);
    }];

    [self.rentOutV withBlockForDidScroll:^(UIScrollView *view) {
        _strong(self);
        [self.selectionView removeFromSuperview];
    }];
    [self.sellOutV withBlockForDidScroll:^(UIScrollView *view) {
        _strong(self);
        [self.selectionView removeFromSuperview];
    }];
    [self.rentInV withBlockForDidScroll:^(UIScrollView *view) {
        _strong(self);
        [self.selectionView removeFromSuperview];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    // custom code
    if (![self.rentOutTypeBtn isSelected] && ![self.sellOutTypeBtn isSelected] && ![self.rentInTypeBtn isSelected]) {
        [self.view bringSubviewToFront:self.rentOutV];
        [self.rentOutTypeBtn setSelected:YES];
    }
    
    [super viewDidAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI Control Action
- (IBAction)rentOutSubmitTap:(id)sender {
    if ([MKWStringHelper isNilEmptyOrBlankString:self.nameT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    self.routHouse.userName = [MKWStringHelper trimWithStr:self.nameT.text];
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.tellT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入电话"];
        return;
    }
    self.routHouse.userPhone = [MKWStringHelper trimWithStr:self.tellT.text];
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routTitleT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    self.routHouse.title = [MKWStringHelper trimWithStr:self.routTitleT.text];
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routAreaB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择区域板块"];
        return;
    }
    self.routHouse.district = self.routAreaB.titleLabel.text;
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routRoomB.titleLabel.text] ||
        [MKWStringHelper isNilEmptyOrBlankString:self.routHallB.titleLabel.text] ||
        [MKWStringHelper isNilEmptyOrBlankString:self.routTolietB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择户型"];
        return;
    }
    self.routHouse.room = @([self.routRoomB.titleLabel.text integerValue]);
    self.routHouse.hall = @([self.routHallB.titleLabel.text integerValue]);
    self.routHouse.toilet = @([self.routTolietB.titleLabel.text integerValue]);
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routSquareT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入面积"];
        return;
    }
    self.routHouse.area = @([self.routSquareT.text floatValue]);
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routFloorB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择楼层"];
        return;
    }
    self.routHouse.floor = @([self.routFloorB.titleLabel.text integerValue]);
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routFixB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择装修"];
        return;
    }
    self.routHouse.fix = self.routFixB.titleLabel.text;
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routOrientationB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择朝向"];
        return;
    }
    self.routHouse.orientation = self.routOrientationB.titleLabel.text;
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routCheckInB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择入住时间"];
        return;
    }
    self.routHouse.checkIn = self.routCheckInB.titleLabel.text;
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.routPriceT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入价格"];
        return;
    }
    self.routHouse.endPrice = @([self.routPriceT.text floatValue]);
    
    BOOL hasImg = NO;
    NSInteger count = 0;
    NSMutableArray *pics = [[NSMutableArray alloc] init];
    for (NSString *url in self.routImageArray) {
        if (![MKWStringHelper isNilEmptyOrBlankString:url]) {
            if (count == 0) {
                hasImg = YES;
                self.routHouse.image = url;
            }
            [pics addObject:@{@"Image":url}];
            count ++;
        }
    }
    if (!hasImg) {
        [SVProgressHUD showErrorWithStatus:@"请至少上传一张图片"];
        return;
    }
    
    self.routHouse.rentDesc = self.routDescT.text;
    
    [SVProgressHUD showWithStatus:@"正在保存" maskType:SVProgressHUDMaskTypeClear];
    [[CommunityLifeModel sharedModel] asyncRentHouseAddWithInfo:@{@"houseSale":@{@"Title":self.routHouse.title, @"Type":@1,@"UserName":self.routHouse.userName,@"UserPhone":self.routHouse.userPhone,@"Room":self.routHouse.room,@"Hall":self.routHouse.hall,@"Toilet":self.routHouse.toilet,@"Area":self.routHouse.area,@"Floor":self.routHouse.floor,@"Fix":self.routHouse.fix,@"Orientation":self.routHouse.orientation,@"CheckIn":self.routHouse.checkIn,@"Description":self.routHouse.rentDesc,@"Image":self.routHouse.image,@"CommunityId":[[CommonModel sharedModel] currentCommunityId],@"Price":self.routHouse.endPrice,@"EndPrice":@0},@"pics":pics} remoteBlock:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            [self _clearRentOutInfo];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"保存失败\n%@", error.domain]];
        }
    }];
}
- (IBAction)sellOutSubmitTap:(id)sender {
    if ([MKWStringHelper isNilEmptyOrBlankString:self.nameT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    self.soutHouse.userName = [MKWStringHelper trimWithStr:self.nameT.text];
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.tellT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入电话"];
        return;
    }
    self.soutHouse.userPhone = [MKWStringHelper trimWithStr:self.tellT.text];
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutTitleT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    self.soutHouse.title = [MKWStringHelper trimWithStr:self.soutTitleT.text];
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutAreaB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择区域板块"];
        return;
    }
    self.soutHouse.district = self.soutAreaB.titleLabel.text;
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutRoomB.titleLabel.text] ||
        [MKWStringHelper isNilEmptyOrBlankString:self.soutHallB.titleLabel.text] ||
        [MKWStringHelper isNilEmptyOrBlankString:self.soutTolietB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择户型"];
        return;
    }
    self.soutHouse.room = @([self.soutRoomB.titleLabel.text integerValue]);
    self.soutHouse.hall = @([self.soutHallB.titleLabel.text integerValue]);
    self.soutHouse.toilet = @([self.soutTolietB.titleLabel.text integerValue]);
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutSquareT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入面积"];
        return;
    }
    self.soutHouse.area = @([self.soutSquareT.text floatValue]);
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutFloorB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择楼层"];
        return;
    }
    self.soutHouse.floor = @([self.soutFloorB.titleLabel.text integerValue]);
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutFixB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择装修"];
        return;
    }
    self.soutHouse.fix = self.soutFixB.titleLabel.text;
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutOrientationB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择朝向"];
        return;
    }
    self.soutHouse.orientation = self.soutOrientationB.titleLabel.text;
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutCheckInB.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择入住时间"];
        return;
    }
    self.soutHouse.checkIn = self.soutCheckInB.titleLabel.text;
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.soutPriceT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入价格"];
        return;
    }
    self.soutHouse.price = @([self.soutPriceT.text floatValue]);
    
    BOOL hasImg = NO;
    NSInteger count = 0;
    NSMutableArray *pics = [[NSMutableArray alloc] init];
    for (NSString *url in self.soutImageArray) {
        if (![MKWStringHelper isNilEmptyOrBlankString:url]) {
            if (count == 0) {
                hasImg = YES;
                self.soutHouse.image = url;
            }
            [pics addObject:@{@"Image":url}];
            count ++;
        }
    }
    if (!hasImg) {
        [SVProgressHUD showErrorWithStatus:@"请至少上传一张图片"];
        return;
    }
    
    self.soutHouse.rentDesc = self.soutDescT.text;
    
    [SVProgressHUD showWithStatus:@"正在保存" maskType:SVProgressHUDMaskTypeClear];
    [[CommunityLifeModel sharedModel] asyncRentHouseAddWithInfo:@{@"houseSale":@{@"Title":self.soutHouse.title, @"Type":@2,@"UserName":self.soutHouse.userName,@"UserPhone":self.soutHouse.userPhone,@"Room":self.soutHouse.room,@"Hall":self.soutHouse.hall,@"Toilet":self.soutHouse.toilet,@"Area":self.soutHouse.area,@"Floor":self.soutHouse.floor,@"Fix":self.soutHouse.fix,@"Orientation":self.soutHouse.orientation,@"CheckIn":self.soutHouse.checkIn,@"Description":self.soutHouse.rentDesc,@"Image":self.soutHouse.image,@"CommunityId":[[CommonModel sharedModel] currentCommunityId],@"Price":self.soutHouse.price,@"EndPrice":@0},@"pics":pics} remoteBlock:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            [self _clearSellOutInfo];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"保存失败\n%@", error.domain]];
        }
    }];
}
- (IBAction)rentInSubmitTap:(id)sender {
    if ([MKWStringHelper isNilEmptyOrBlankString:self.nameT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    self.rinHouse.userName = [MKWStringHelper trimWithStr:self.nameT.text];
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.tellT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入电话"];
        return;
    }
    self.rinHouse.userPhone = [MKWStringHelper trimWithStr:self.tellT.text];
    
    if ([MKWStringHelper isNilEmptyOrBlankString:self.rinTitleT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    self.rinHouse.title = [MKWStringHelper trimWithStr:self.rinTitleT.text];
    if ([MKWStringHelper isNilEmptyOrBlankString:self.rinDescT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入描述"];
        return;
    }
    self.rinHouse.rentDesc = self.rinDescT.text;
    
    [SVProgressHUD showWithStatus:@"正在保存" maskType:SVProgressHUDMaskTypeClear];
    [[CommunityLifeModel sharedModel] asyncRentHouseAddWithInfo:@{@"houseSale":@{@"Title":self.rinHouse.title, @"Type":@3,@"UserName":self.rinHouse.userName,@"UserPhone":self.rinHouse.userPhone,@"Room":@0,@"Hall":@0,@"Toilet":@0,@"Area":@0,@"Floor":@0,@"Fix":@"",@"Orientation":@"",@"CheckIn":@"",@"Description":self.rinHouse.rentDesc,@"Image":@"",@"CommunityId":[[CommonModel sharedModel] currentCommunityId],@"Price":@0,@"EndPrice":@0},@"pics":@[]} remoteBlock:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            [self _clearRentInInfo];
            [UserPointHandler addUserPointWithType:RentAdd showInfo:NO];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"保存失败\n%@", error.domain]];
        }
    }];
}

- (IBAction)addImageBtnTap:(id)sender {
    UIButton *btn = (UIButton*)sender;
    _weak(self);
    _weak(btn);
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
                _strong(btn);
//                [SVProgressHUD showInfoWithStatus:@"正在上传图片" maskType:SVProgressHUDMaskTypeClear];
                [SVProgressHUD showWithStatus:@"正在上传图片" maskType:SVProgressHUDMaskTypeClear];
                UIImage *newImage = [thumbnail adjustedToStandardSize];
                [[CommonModel sharedModel] uploadImage:newImage path:filePath progress:nil remoteBlock:^(NSString *url, NSError *error) {
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                        [btn setBackgroundImage:newImage forState:UIControlStateNormal];
                        [btn setBackgroundImage:newImage forState:UIControlStateHighlighted];
                        NSInteger idx = btn.tag - 1020101;
                        if (idx > 4) {
                            [self.soutImageArray setObject:url atIndexedSubscript:idx-4];
                        }
                        else {
                            [self.routImageArray setObject:url atIndexedSubscript:idx];
                        }
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
            EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForCameraPhotoEditable:NO];
            SetupEYImagePicker(picker);
        }];
    }
    
    if ([EYImagePickerViewController isLibraryPhotoAvailable]) {
        [as addOtherButtonTitle:@"手机相册" actionBlock:^{
            EYImagePickerViewController* picker = [EYImagePickerViewController imagePickerForLibraryPhotoEditable:NO];
            SetupEYImagePicker(picker);
        }];
    }
    [as showInView:self.view];
}

- (IBAction)infoTypeBtnTap:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if ([btn isSelected]) {
        return;
    }
    
    [self.view endEditing:YES];
    
    if (btn == self.rentOutTypeBtn) {
        [self.sellOutTypeBtn setSelected:NO];
        [self.rentInTypeBtn setSelected:NO];
        [self.view bringSubviewToFront:self.rentOutV];
    }
    
    if (btn == self.sellOutTypeBtn) {
        [self.rentOutTypeBtn setSelected:NO];
        [self.rentInTypeBtn setSelected:NO];
        [self.view bringSubviewToFront:self.sellOutV];
    }
    
    if (btn == self.rentInTypeBtn) {
        [self.rentOutTypeBtn setSelected:NO];
        [self.sellOutTypeBtn setSelected:NO];
        [self.view bringSubviewToFront:self.rentInV];
    }
    
    [btn setSelected:YES];
}

- (IBAction)editSelectBtnTap:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _weak(self);
    _weak(btn);
    void (^showSelectionBlock)() = ^{
        [self.selectionView withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            _strong(btn);
            UITableViewCell *cell = [view cellForRowAtIndexPath:path];
            [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
            [btn setTitle:cell.textLabel.text forState:UIControlStateHighlighted];
            [self.selectionView removeFromSuperview];
        }];
        
        if (![self.selectionView superview]) {
            [self.view addSubview:self.selectionView];
        }
        [self.selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(btn);
            CGRect rect = [btn convertRect:btn.bounds toView:self.view];
            make.left.equalTo(btn);
            make.right.equalTo(btn);
            if (rect.origin.y+rect.size.height + 90 > V_H_(self.view)-50) {
                make.bottom.equalTo(btn.mas_top);
            }
            else {
                make.top.equalTo(btn.mas_bottom);
            }
            make.height.equalTo(@90);
        }];
        [self.view bringSubviewToFront:self.selectionView];
    };
    
    self.selectionArray = @[];
    if (btn == self.routAreaB || btn == self.soutAreaB) {
        // async get area then show selection block
        OpendCityInfo *info = [[OpendCityInfo alloc] init];
        info.city = [[CommonModel sharedModel] currentCity];
        [[CSSettingModel sharedModel] asyncAreaWithCity:info cacheBlock:nil remoteBlock:^(NSArray *areaArray, NSError *error) {
            NSMutableArray *a = [[NSMutableArray alloc] init];
            for (OpendAreaInfo *area in areaArray) {
                [a addObject:area.area];
            }
            self.selectionArray = a;
        }];
    }
    
    if (btn == self.routRoomB || btn == self.soutRoomB) {
        self.selectionArray = @[@"0",
                                @"1",
                                @"2",
                                @"3",
                                @"4",
                                @"5",
                                @"6",
                                @"7",
                                @"8",
                                @"9",];
    }
    
    if (btn == self.routHallB || btn == self.soutHallB) {
        self.selectionArray = @[@"0",
                                @"1",
                                @"2",
                                @"3",
                                @"4",
                                @"5",
                                @"6",
                                @"7",
                                @"8",
                                @"9",];
    }
    
    if (btn == self.routTolietB || btn == self.soutTolietB) {
        self.selectionArray = @[@"0",
                                @"1",
                                @"2",
                                @"3",
                                @"4",
                                @"5",
                                @"6",
                                @"7",
                                @"8",
                                @"9",];
    }
    
    if (btn == self.routFloorB || btn == self.soutFloorB) {
        self.selectionArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                                @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                                @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                                @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
                                @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
                                @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",
                                @"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",
                                @"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",
                                @"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",
                                @"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"100",
                                @"101",@"102",@"103",@"104",@"105",@"106",@"107",@"108",@"109",@"110",];
    }
    
    if (btn == self.routFixB || btn == self.soutFixB) {
        self.selectionArray = @[@"清水房",@"简装修",@"精装修",@"豪华装修"];
    }
    
    if (btn == self.routOrientationB || btn == self.soutOrientationB) {
        self.selectionArray = @[@"东",@"南",@"西",@"北",@"东北",@"东南",@"西南",@"西北"];
    }
    
    if (btn == self.routCheckInB || btn == self.soutCheckInB) {
        self.selectionArray = @[@"可立即入住",@"一周内可入住",@"一个月内可入住",@"半年内可入住",@"一年内可入住"];
    }
    
    showSelectionBlock();
}


#pragma mark - Business Logic

- (void)_clearRentOutInfo {
    self.routTitleT.text = @"";
    [self _clearSelectedBtn:self.routAreaB];
    [self _clearSelectedBtn:self.routRoomB];
    [self _clearSelectedBtn:self.routHallB];
    [self _clearSelectedBtn:self.routTolietB];
    self.routSquareT.text = @"";
    [self _clearSelectedBtn:self.routFloorB];
    [self _clearSelectedBtn:self.routFixB];
    [self _clearSelectedBtn:self.routOrientationB];
    [self _clearSelectedBtn:self.routCheckInB];
    self.routPriceT.text = @"";
    self.routDescT.text = @"";
    self.routHouse = nil;
    self.routHouse = [[RentHouseInfo alloc] init];
    [self.routImageArray removeAllObjects];
    self.routImageArray = [@[@"",@"",@"",@"",@""] mutableCopy];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = (UIButton *)[self.rentOutV viewWithTag:1020101+i];
        [btn setBackgroundImage:[UIImage imageNamed:@"rent_edit_img_btn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"rent_edit_img_btn"] forState:UIControlStateHighlighted];
    }
}

- (void)_clearSellOutInfo {
    self.soutTitleT.text = @"";
    [self _clearSelectedBtn:self.soutAreaB];
    [self _clearSelectedBtn:self.soutRoomB];
    [self _clearSelectedBtn:self.soutHallB];
    [self _clearSelectedBtn:self.soutTolietB];
    self.soutSquareT.text = @"";
    [self _clearSelectedBtn:self.soutFloorB];
    [self _clearSelectedBtn:self.soutFixB];
    [self _clearSelectedBtn:self.soutOrientationB];
    [self _clearSelectedBtn:self.soutCheckInB];
    self.soutPriceT.text = @"";
    self.soutDescT.text = @"";
    self.soutHouse = nil;
    self.soutHouse = [[RentHouseInfo alloc] init];
    [self.soutImageArray removeAllObjects];
    self.soutImageArray = [@[@"",@"",@"",@"",@""] mutableCopy];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = (UIButton *)[self.sellOutV viewWithTag:1020106+i];
        [btn setBackgroundImage:[UIImage imageNamed:@"rent_edit_img_btn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"rent_edit_img_btn"] forState:UIControlStateHighlighted];
    }
}

- (void)_clearRentInInfo {
    self.rinTitleT.text = @"";
    self.rinDescT.text = @"";
    self.rinHouse = nil;
    self.rinHouse = [[RentHouseInfo alloc] init];
}

- (void)_clearSelectedBtn:(UIButton*)btn {
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setTitle:@"" forState:UIControlStateHighlighted];
    [btn setTitle:@"" forState:UIControlStateSelected];
    [btn setTitle:@"" forState:UIControlStateDisabled];
}

- (void)_setupSelectionView {
    self.selectionView = ({
        UITableView *v = [[UITableView alloc] init];
        [v setShowsHorizontalScrollIndicator:NO];
        [v setShowsVerticalScrollIndicator:NO];
        [v registerClass:[UITableViewCell class] forCellReuseIdentifier:@"selectionCell"];
        [v setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        v.layer.borderColor = [k_COLOR_GALLERY_F CGColor];
        v.layer.borderWidth = 1;
        v.layer.cornerRadius = 4;
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            return [self.selectionArray count];
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:@"selectionCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectionCell"];
            }
            NSString *selection = [self.selectionArray objectAtIndex:path.row];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = k_COLOR_GALLERY_F;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = selection;
            return cell;
        }];
        [v withBlockForSectionNumber:^NSInteger(UITableView *view) {
            return 1;
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 30;
        }];
        v;
    });
}

- (void)_setupObserver {
    _weak(self);
    [@[self.rentOutV, self.sellOutV, self.rentInV] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIScrollView *)obj handleKeyboard];
    }];
    [self startObserveObject:self forKeyPath:@"selectionArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.selectionView reloadData];
    }];
}
@end
