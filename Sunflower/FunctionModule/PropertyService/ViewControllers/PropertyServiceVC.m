//
//  PropertyServiceVC.m
//  Sunflower
//
//  Created by mark on 15/5/1.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyServiceVC.h"
#import "PropertyServiceModel.h"
#import "PropertyPayListVC.h"

#import "CommunityNote.h"
#import "CommonModel.h"
#import "MKWModelHandler.h"

@interface PropertyServiceVC ()

@property(nonatomic,weak)IBOutlet UIButton  *propertyPaymentBtn;
@property(nonatomic,weak)IBOutlet UIButton  *warmPaymentBtn;
@property(nonatomic,weak)IBOutlet UIButton  *cleanPaymentBtn;
@property(nonatomic,weak)IBOutlet UIButton  *parkPaymentBtn;
@property(nonatomic,weak)IBOutlet UIButton  *noteBtn;

@property(nonatomic,weak)IBOutlet UIImageView      *readIcon;

@end

@implementation PropertyServiceVC

- (NSString *)umengPageName {
    return @"物业服务首页";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self _updateNoteReadIcon];
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
    if ([segue.identifier isEqualToString:@"Segue_Property_Payment"]) {
        PropertyChargeType type = ChargeProperty;
        if ([sender isEqual:self.propertyPaymentBtn]) {
            type = ChargeProperty;
        }
        if ([sender isEqual:self.warmPaymentBtn]) {
            type = ChargeWarm;
        }
        if ([sender isEqual:self.cleanPaymentBtn]) {
            type = ChargeClean;
        }
        if ([sender isEqual:self.parkPaymentBtn]) {
            type = ChargePark;
        }
        
        ((PropertyPayListVC *)[segue destinationViewController]).type = type;
    }
    
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    [self _updateNoteReadIcon];
}

#pragma mark - Xib Control Action
- (IBAction)paymentTap:(id)sender {
    [self performSegueWithIdentifier:@"Segue_Property_Payment" sender:sender];
}

#pragma mark - private

- (void)_loadCodingViews {
//    if (self.readIcon) {
//        return;
//    }
//    
//    self.readIcon = [[UIImageView alloc] init];
//    self.readIcon.image = [UIImage imageNamed:@"notify_red"];
}

- (void)_layoutCodingViews {
//    if ([self.readIcon superview]) {
//        return;
//    }
//    _weak(self);
//    [[self.noteBtn superview] addSubview:self.readIcon];
//    [self.readIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        _strong(self);
//        make.centerY.equalTo(self.noteBtn);
//        make.left.equalTo(self.noteBtn).with.offset(10);
//        make.height.width.equalTo(@10);
//    }];
//    [self.noteBtn setHidden:YES];
}

- (void)_updateNoteReadIcon {
    [self.readIcon setHidden:YES];
    CommunityNoteInfo *note = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYNOTE predicate:[NSPredicate predicateWithFormat:@"isRead=%@ AND communityId=%@", @(NO), [CommonModel sharedModel].currentCommunityId]] firstObject];
    if (note) {
        [self.readIcon setHidden:NO];
        return;
    }
    _weak(self);
    [[PropertyServiceModel sharedModel] asyncCommunityNoteListWithCommunityId:[CommonModel sharedModel].currentCommunityId pageIndex:@1 pageSize:@1 cacheBlock:nil remoteBlock:^(NSArray *list, NSNumber *cPage, NSError *error) {
        _strong(self);
        if (!error && [list count] > 0) {
            CommunityNoteInfo *info = list[0];
            if (![[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_COMMUNITYNOTE predicate:[NSPredicate predicateWithFormat:@"noticeId=%@ AND isRead=%@", info.noticeId, @(YES)]] firstObject]) {
                [self.readIcon setHidden:NO];
            }
        }
    }];
}

@end
