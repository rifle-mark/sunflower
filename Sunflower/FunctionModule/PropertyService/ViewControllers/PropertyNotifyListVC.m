//
//  PropertyNotifyListVC.m
//  Sunflower
//
//  Created by mark on 15/5/1.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Masonry.h>
#import "GCExtension.h"
#import "NSNumber+MKWDate.h"
#import <MJRefresh.h>

#import "PropertyServiceModel.h"
#import "CommonModel.h"
#import "UserModel.h"

#import "PropertyNotifyListVC.h"
#import "CNoteTableViewCell.h"
#import "PropertyNotifyVC.h"

@interface PropertyNotifyCell : UITableViewCell

@property(nonatomic,strong)UILabel      *titleL;
@property(nonatomic,strong)UILabel      *pubTimeL;
@property(nonatomic,strong)UIImageView  *arrawV;
@property(nonatomic,strong)UIImageView  *readIcon;

@property(nonatomic,strong)CommunityNoteInfo    *note;

+ (NSString *)reuseIdentify;

@end

@implementation PropertyNotifyCell

+ (NSString *)reuseIdentify {
    return @"PropertyNotifyCellIdentify";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleL = [[UILabel alloc] init];
        self.titleL.font = [UIFont boldSystemFontOfSize:14];
        self.titleL.textColor = k_COLOR_GALLERY_F;
        
        _weak(self);
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView).with.offset(-8);
            make.left.equalTo(self.contentView).with.offset(25);
            make.right.equalTo(self.contentView).with.offset(-40);
            make.height.equalTo(@14);
        }];
        
        self.pubTimeL = [[UILabel alloc] init];
        self.pubTimeL.font = [UIFont boldSystemFontOfSize:14];
        self.pubTimeL.textColor = k_COLOR_GALLERY_F;
        [self.contentView addSubview:self.pubTimeL];
        [self.pubTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView).with.offset(8);
            make.left.equalTo(self.contentView).with.offset(25);
            make.right.equalTo(self.contentView).with.offset(-40);
            make.height.equalTo(@14);
        }];
        
        self.arrawV = [[UIImageView alloc] init];
        self.arrawV.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:self.arrawV];
        [self.arrawV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.right.equalTo(self.contentView).with.offset(-20);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@10);
            make.height.equalTo(@15);
        }];
        
        self.readIcon = [[UIImageView alloc] init];
        self.readIcon.image = [UIImage imageNamed:@"notify_red"];
        [self.contentView addSubview:self.readIcon];
        [self.readIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.arrawV.mas_left).with.offset(-30);
            make.height.width.equalTo(@10);
        }];
        [self.readIcon setHidden:YES];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = k_COLOR_GALLERY;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.equalTo(self.contentView);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"note" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        self.titleL.text = self.note.title;
        self.pubTimeL.text = [self.note.createDate dateSplitByChinese];
        
        [self.readIcon setHidden:[[PropertyServiceModel sharedModel] isNoteReadWithId:self.note.noticeId]];
    }];
}

@end

@interface PropertyNotifyListVC ()

@property(nonatomic,weak)IBOutlet UIView    *contentV;
@property(nonatomic,strong)UITableView      *noteListTableV;
@property(nonatomic,strong)UIView           *addNoteV;

@property(nonatomic,strong)NSArray          *noteArray;
@property(nonatomic,strong)NSNumber         *cPage;

@end

@implementation PropertyNotifyListVC

- (NSString *)umengPageName {
    return @"通知公告列表";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSeuge_PropertyNotifyList";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    
    [self.noteListTableV.header beginRefreshing];
}

- (void)loadView {
    [super loadView];
    
    [self _loadNoteListTable];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutNoteListTable];
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
    if ([segue.identifier isEqualToString:@"Segue_NotifyList_NotifyInfo"]) {
        PropertyNotifyVC *vc = [segue destinationViewController];
        CNoteTableViewCell *cell = (CNoteTableViewCell*)sender;
        vc.note = cell.note;
    }
}

- (void)unwindSegue:(UIStoryboardSegue *)segue {
    [self _refreshNoteList];
}

#pragma mark - private method

- (void)_refreshNoteList {
    [self _loadNoteListAtPage:@1 pageSize:@20];
}
- (void)_loadMoreNoteList {
    [self _loadNoteListAtPage:@([self.cPage integerValue]+1) pageSize:@20];
}

- (void)_loadNoteListAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize {
    _weak(self);
    [[PropertyServiceModel sharedModel] asyncCommunityNoteListWithCommunityId:[[CommonModel sharedModel] currentCommunityId] pageIndex:page pageSize:pageSize cacheBlock:nil remoteBlock:^(NSArray *list, NSNumber *cPage, NSError *error) {
        _strong(self);
        if ([self.noteListTableV.header isRefreshing]) {
            [self.noteListTableV.header endRefreshing];
        }
        if ([self.noteListTableV.footer isRefreshing]) {
            [self.noteListTableV.footer endRefreshing];
        }
        if (!error) {
            if ([cPage integerValue] == 1) {
                self.cPage = cPage;
                self.noteArray = list;
            }
            else {
                if ([list count] >0) {
                    self.cPage = cPage;
                    NSMutableArray *tmp = [self.noteArray mutableCopy];
                    [tmp addObjectsFromArray:list];
                    self.noteArray = tmp;
                }
            }
        }
    }];
}
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"noteArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.noteListTableV reloadData];
        for (CommunityNoteInfo *note in self.noteArray) {
            [note saveToDb];
        }
    }];
}

- (void)_loadNoteListTable {
    self.noteListTableV = ({
        UITableView *v = [[UITableView alloc] init];
        [v registerClass:[PropertyNotifyCell class] forCellReuseIdentifier:[PropertyNotifyCell reuseIdentify]];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        _weak(self);
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            _strong(self);
            return [self.noteArray count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 60;
        }];
        
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            _strong(self);
            PropertyNotifyCell *cell = [v dequeueReusableCellWithIdentifier:[PropertyNotifyCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[PropertyNotifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PropertyNotifyCell reuseIdentify]];
            }
            CommunityNoteInfo *note = (CommunityNoteInfo*)self.noteArray[path.row];
            cell.note = note;
            return cell;
        }];
        
        [v withBlockForRowDidSelect:^(UITableView *view, NSIndexPath *path) {
            _strong(self);
            UITableViewCell *cell = [v cellForRowAtIndexPath:path];
            [cell setSelected:NO animated:YES];
            
            [self performSegueWithIdentifier:@"Segue_NotifyList_NotifyInfo" sender:cell];
        }];
        
        v.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _strong(self);
            [self _refreshNoteList];
        }];
        v.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _strong(self);
            [self _loadMoreNoteList];
        }];
        v;
    });
    
    if (!self.addNoteV) {
        _addNoteV = ({
            UIView *ret = [[UIView alloc] init];
            ret.backgroundColor = k_COLOR_WHITE;
            UIButton *btn = [[UIButton alloc] init];
            btn.backgroundColor = k_COLOR_BLUE;
            btn.layer.cornerRadius = 4;
            [btn setTitleColor:k_COLOR_WHITE forState:UIControlStateNormal];
            [btn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
            [btn setTitle:@"发布新公告" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [ret addSubview:btn];
            _weak(ret);
            _weak(self);
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(ret);
                make.centerY.equalTo(ret);
                make.left.equalTo(ret).with.offset(13);
                make.right.equalTo(ret).with.offset(-13);
                make.height.equalTo(@43);
            }];
            _weak(btn);
            [btn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
                _strong(self);
                _strong(btn);
                [self performSegueWithIdentifier:@"Segue_NotifyList_NotifyEdit" sender:btn];
            }];
            ret;
        });
    }
}

- (void)_layoutNoteListTable {
    if ([self.noteListTableV superview]) {
        return;
    }
    _weak(self);
    UIView *tmpV = [[UIView alloc] init];
    tmpV.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:tmpV];
    [tmpV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(-1);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@1);
    }];
    
    UIView *botV = [[UIView alloc] init];
    botV.backgroundColor = k_COLOR_CLEAR;
    [self.contentV addSubview:botV];
    [botV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.bottom.equalTo(self.contentV);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@(self.bottomLayoutGuide.length));
    }];
    
    _weak(botV);
    if ([[UserModel sharedModel] isPropertyAdminLogined] && [[UserModel sharedModel].currentAdminUser.communityId integerValue] == [[CommonModel sharedModel].currentCommunityId integerValue]) {
        [self.contentV addSubview:self.addNoteV];
        [self.addNoteV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.bottom.equalTo(botV.mas_top);
            make.left.right.equalTo(self.contentV);
            make.height.equalTo(@53);
        }];
        [self.contentV addSubview:self.noteListTableV];
        [self.noteListTableV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.equalTo(self.contentV);
            make.bottom.equalTo(self.addNoteV.mas_top);
        }];
    }
    else {
        [self.contentV addSubview:self.noteListTableV];
        [self.noteListTableV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            _strong(botV);
            make.left.top.right.equalTo(self.contentV);
            make.bottom.equalTo(botV.mas_top);
        }];
    }
}

@end
