//
//  PropertyNotifyVC.m
//  Sunflower
//
//  Created by mark on 15/5/1.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PropertyNotifyVC.h"
#import "PropertyNoteEditVC.h"
#import "GCExtension.h"
#import <UIImageView+AFNetworking.h>
#import "NSNumber+MKWDate.h"
#import "UserModel.h"
#import "CommonModel.h"
#import "PropertyServiceModel.h"

@interface PropertyNotifyVC ()

@property(nonatomic,weak)IBOutlet UILabel       *titleL;
@property(nonatomic,weak)IBOutlet UILabel       *timeL;
@property(nonatomic,weak)IBOutlet UIImageView   *coverImgV;
@property(nonatomic,weak)IBOutlet UITextView    *contentT;

@end

@implementation PropertyNotifyVC

- (NSString *)umengPageName {
    return @"通知公告详请";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_PropertyNotify";
}

- (void)refreshNote {
    if (!self.noteId) {
        return;
    }
    
    [[PropertyServiceModel sharedModel] asyncNoteDetailWithNoteId:self.noteId remoteblock:^(CommunityNoteInfo *note, NSError *error) {
        if (!error) {
            self.note = note;
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"获取公告信息失败"];
            [self performSegueWithIdentifier:@"UnSegue_PropertyNotify" sender:nil];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[UserModel sharedModel] isPropertyAdminLogined] && [[UserModel sharedModel].currentAdminUser.communityId integerValue] == [[CommonModel sharedModel].currentCommunityId integerValue]) {
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editNotify:)];
        editItem.tintColor = k_COLOR_WHITE;
        self.navigationItem.rightBarButtonItem = editItem;
    }
    
    [self _setupObserver];
    
    if (!self.note && self.noteId) {
        [self refreshNote];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self _layoutContent];
    FixesViewDidLayoutSubviewsiOS7Error;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Segue_Notify_NotifyEdit"]) {
        ((PropertyNoteEditVC*)segue.destinationViewController).note = self.note;
    }
}


- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"note" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        self.titleL.text = self.note.title;
        self.timeL.text = [self.note.createDate dateSplitByChinese];
        [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:self.note.image] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
        self.contentT.text = self.note.content;
        [self.note readNote];
    }];
}

- (void)_layoutContent {
    [self.contentT setEditable:NO];
    if (self.note) {
        self.titleL.text = self.note.title;
        self.timeL.text = [self.note.createDate dateSplitByChinese];
        [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:self.note.image] placeholderImage:[UIImage imageNamed:@"default_top_width"]];
        self.contentT.text = self.note.content;
        [self.note readNote];
    }
}

- (void)editNotify:(id)sender {
    [self performSegueWithIdentifier:@"Segue_Notify_NotifyEdit" sender:nil];
}
@end
