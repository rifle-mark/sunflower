//
//  PropertyApplyVC.m
//  Sunflower
//
//  Created by makewei on 15/5/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyApplyVC.h"

#import "GCExtension.h"
#import "CommonModel.h"
#import "UserModel.h"
#import <SVProgressHUD.h>
#import <Masonry.h>

@interface PropertyApplyVC () <UITextFieldDelegate>

@property(nonatomic,weak)IBOutlet UIScrollView  *scrollV;
@property(nonatomic,weak)IBOutlet UIView        *contentV;
@property(nonatomic,weak)IBOutlet UIButton      *provinceB;
@property(nonatomic,weak)IBOutlet UIButton      *cityB;
@property(nonatomic,weak)IBOutlet UITextField   *addressT;
@property(nonatomic,weak)IBOutlet UITextField   *communityNameT;
@property(nonatomic,weak)IBOutlet UITextField   *nameT;
@property(nonatomic,weak)IBOutlet UITextField   *telT;

@property(nonatomic,weak)UITextField   *focusedT;

@property(nonatomic,strong)UITableView          *selectionV;
@property(nonatomic,strong)NSArray              *selectionA;

@property(nonatomic,assign)NSInteger            selectedProvinceIndex;
@property(nonatomic,strong)NSArray              *provinceList;
@property(nonatomic,strong)NSArray              *cityList;

@end

@implementation PropertyApplyVC

- (NSString *)umengPageName {
    return @"物业管理申请";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_PropertyApply";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupSelectionV];
    [self _setupObserver];
    
    self.selectedProvinceIndex = -1;
    [self _loadCityList];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.contentV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
    }];
    FixesViewDidLayoutSubviewsiOS7Error;
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

#pragma mark - UI Control Action

- (IBAction)vieTap:(id)sender {
    if ([self.selectionV superview]) {
        [self.selectionV removeFromSuperview];
    }
    if (self.focusedT) {
        [self.focusedT resignFirstResponder];
    }
}

- (IBAction)applyBtnTap:(id)sender {
    NSString *provice = self.provinceB.titleLabel.text;
    if ([provice isEqualToString:@"请选择省"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择省"];
        return;
    }
    NSString *city = self.cityB.titleLabel.text;
    if ([city isEqualToString:@"请选择城市"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择城市"];
        return;
    }
    NSString *address = [MKWStringHelper trimWithStr:self.addressT.text];
    if ([MKWStringHelper isNilEmptyOrBlankString:address]) {
        [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
        return;
    }
    NSString *communityName = [MKWStringHelper trimWithStr:self.communityNameT.text];
    if ([MKWStringHelper isNilEmptyOrBlankString:communityName]) {
        [SVProgressHUD showErrorWithStatus:@"请填写小区"];
        return;
    }
    NSString *name = [MKWStringHelper trimWithStr:self.nameT.text];
    if ([MKWStringHelper isNilEmptyOrBlankString:name]) {
        [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
        return;
    }
    NSString *tel = [MKWStringHelper trimWithStr:self.telT.text];
    if ([MKWStringHelper isNilEmptyOrBlankString:tel]) {
        [SVProgressHUD showErrorWithStatus:@"请真写电话"];
        return;
    }
    
    [[UserModel sharedModel] asyncApplyPropertyWithProvince:provice city:city address:address communityName:communityName userName:name tel:tel remoteBlock:^(BOOL isSuccess, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
            return;
        }
        if (!isSuccess) {
            [SVProgressHUD showErrorWithStatus:@"申请失败，请检查网络"];
        }
        [SVProgressHUD showSuccessWithStatus:@"申请成功，请等待结果"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)selectionBtnTap:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isEqual:self.provinceB]) {
        self.selectionA = self.provinceList;
    }
    else if ([btn isEqual:self.cityB]) {
        if (self.selectedProvinceIndex < 0) {
            [SVProgressHUD showErrorWithStatus:@"请先选择“省”"];
            return;
        }
        self.selectionA = self.cityList[self.selectedProvinceIndex];
    }
    
    _weak(btn);
    _weak(self);
    [self.selectionV withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
        _strong(btn);
        _strong(self);
        if ([btn isEqual:self.provinceB]) {
            self.selectedProvinceIndex = path.row;
            [self.cityB setTitle:@"请选择城市" forState:UIControlStateNormal];
        }
        UITableViewCell *cell = [view cellForRowAtIndexPath:path];
        [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
        [btn setTitle:cell.textLabel.text forState:UIControlStateHighlighted];
        [self.selectionV removeFromSuperview];
    }];
    
    [self.view addSubview:self.selectionV];
    [self.selectionV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.selectionV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(btn);
        make.top.equalTo(btn.mas_bottom);
        make.left.equalTo(btn);
        make.right.equalTo(btn);
        make.height.equalTo(@150);
    }];
}

#pragma mark - Business Logic

- (void)_loadCityList {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CityList" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray *pList = [[NSMutableArray alloc] init];
    NSMutableArray *cList = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *arr = obj;
        NSMutableArray *citys = [[NSMutableArray alloc] init];
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx == 0)
                [pList addObject:obj];
            else
                [citys addObject:obj];
        }];
        [cList addObject:citys];
    }];
    self.provinceList = pList;
    self.cityList = cList;
}

- (void)_setupSelectionV {
    self.selectionV = ({
        UITableView *v = [[UITableView alloc] init];
        [v setShowsHorizontalScrollIndicator:NO];
        [v setShowsVerticalScrollIndicator:NO];
        [v setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        v.layer.borderColor = [k_COLOR_GALLERY_F CGColor];
        v.layer.borderWidth = 1;
        v.layer.cornerRadius = 4;
        [v registerClass:[UITableViewCell class] forCellReuseIdentifier:@"selection_cell"];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            return [self.selectionA count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 30;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:@"selection_cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selection_cell"];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = k_COLOR_GALLERY_F;
            cell.textLabel.text = [self.selectionA objectAtIndex:path.row];
            return cell;
        }];
        v;
     });
}
- (void)_setupObserver {
    [self.scrollV handleKeyboard];
    _weak(self);
    [self startObserveObject:self forKeyPath:@"selectionA" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.selectionV reloadData];
    }];
}

#pragma mark - UITextFieldDelegate

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.focusedT = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.addressT]) {
        [self.addressT resignFirstResponder];
        [self.communityNameT becomeFirstResponder];
    }
    if ([textField isEqual:self.communityNameT]) {
        [self.communityNameT resignFirstResponder];
        [self.nameT becomeFirstResponder];
    }
    if ([textField isEqual:self.nameT]) {
        [self.nameT resignFirstResponder];
        [self.telT becomeFirstResponder];
    }
    if ([textField isEqual:self.telT]) {
        [self.telT resignFirstResponder];
    }
    return YES;
}
@end
