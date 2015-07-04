//
//  PointRulerVC.m
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "PointRulerVC.h"
#import "UserModel.h"

@interface PointRulerTableCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleL;
@property(nonatomic,strong)UILabel *pointL;

@property(nonatomic,strong)PointRulerInfo *ruler;

+ (NSString *)reuseIdentify;
@end

@implementation PointRulerTableCell

+ (NSString *)reuseIdentify {
    return @"PointRulerTableCellIdentify";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _weak(self);
        self.titleL = [[UILabel alloc] init];
        self.titleL.font = [UIFont boldSystemFontOfSize:14];
        self.titleL.textColor = k_COLOR_GALLERY_F;
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(32);
            make.height.equalTo(@14);
            make.width.equalTo(@150);
        }];
        
        self.pointL = [[UILabel alloc] init];
        self.pointL.font = [UIFont boldSystemFontOfSize:14];
        self.pointL.textColor = k_COLOR_BLUE;
        self.pointL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.pointL];
        [self.pointL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.titleL.mas_right);
            make.height.equalTo(@14);
            make.right.equalTo(self.contentView).with.offset(-32);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = k_COLOR_GALLERY;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self startObserveObject:self forKeyPath:@"ruler" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        self.titleL.text = self.ruler.title;
        self.pointL.text = [NSString stringWithFormat:@"+%@积分", self.ruler.points];
    }];
}
@end

@interface PointRulerVC ()

@property(nonatomic,strong)UITableView      *ruleTableV;
@property(nonatomic,strong)NSArray          *ruleArray;

@end

@implementation PointRulerVC

- (NSString *)umengPageName {
    return @"积分规则";
}

- (NSString *)unwindSegueIdentify {
    return @"UnSegue_PointRuler";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupObserver];
    [self _refreshPointRuleList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    
    [self _loadCodingViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutCodingViews];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Coding Views
- (void)_loadCodingViews {
    if (self.ruleTableV) {
        return;
    }
    
    self.ruleTableV = ({
        UITableView *v = [[UITableView alloc] init];
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        
        [v registerClass:[PointRulerTableCell class] forCellReuseIdentifier:[PointRulerTableCell reuseIdentify]];
        
        [v withBlockForRowNumber:^NSInteger(UITableView *view, NSInteger section) {
            return [self.ruleArray count];
        }];
        [v withBlockForRowHeight:^CGFloat(UITableView *view, NSIndexPath *path) {
            return 37;
        }];
        [v withBlockForRowCell:^UITableViewCell *(UITableView *view, NSIndexPath *path) {
            PointRulerTableCell *cell = [view dequeueReusableCellWithIdentifier:[PointRulerTableCell reuseIdentify] forIndexPath:path];
            if (!cell) {
                cell = [[PointRulerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PointRulerTableCell reuseIdentify]];
            }
            
            cell.ruler = self.ruleArray[path.row];
            return cell;
        }];
        [v withBlockForHeaderHeight:^CGFloat(UITableView *view, NSInteger section) {
            return 52;
        }];
        [v withBlockForHeaderView:^UIView *(UITableView *view, NSInteger section) {
            UIView *ret = [[UIView alloc] init];
            ret.backgroundColor = RGB(243, 243, 243);
            UILabel *pointL = [[UILabel alloc] init];
            pointL.backgroundColor = k_COLOR_WHITE;
            pointL.layer.cornerRadius = 17;
            pointL.clipsToBounds = YES;
            
            NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
            ps.alignment = NSTextAlignmentCenter;
            ps.lineSpacing = 1;
            NSDictionary *normalattributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                               NSParagraphStyleAttributeName:ps,
                                               NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                                               NSBaselineOffsetAttributeName: @0};
            
            NSDictionary *countattributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                              NSParagraphStyleAttributeName:ps,
                                              NSForegroundColorAttributeName:k_COLOR_BLUE,
                                              NSBaselineOffsetAttributeName: @0};
            NSMutableAttributedString *pointStr= [[NSMutableAttributedString alloc] initWithString:@"我的积分：" attributes:normalattributes];
            [pointStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [UserModel sharedModel].currentNormalUser.points] attributes:countattributes]];
            
            pointL.attributedText = pointStr;
            
            [ret addSubview:pointL];
            _weak(ret);
            [pointL mas_makeConstraints:^(MASConstraintMaker *make) {
                _strong(ret);
                make.centerX.equalTo(ret);
                make.centerY.equalTo(ret);
                make.height.equalTo(@34);
                make.width.equalTo(@180);
            }];
            return ret;
        }];
        v;
    });
}

- (void)_layoutCodingViews {
    if ([self.ruleTableV superview]) {
        return;
    }
    
    _weak(self);
    UIView *topTmp = [[UIView alloc] init];
    topTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:topTmp];
    [topTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(self.topLayoutGuide.length));
    }];
    
    UIView *botTmp = [[UIView alloc] init];
    botTmp.backgroundColor = k_COLOR_CLEAR;
    [self.view addSubview:botTmp];
    [botTmp mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(self.bottomLayoutGuide.length));
    }];
    
    _weak(topTmp);
    _weak(botTmp);
    [self.view addSubview:self.ruleTableV];
    [self.ruleTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        _strong(botTmp);
        _strong(topTmp);
        make.left.right.equalTo(self.view);
        make.top.equalTo(topTmp.mas_bottom);
        make.bottom.equalTo(botTmp.mas_top);
    }];
}

#pragma mark - Data
- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"ruleArray" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.ruleTableV reloadData];
    }];
}

- (void)_refreshPointRuleList {
    _weak(self);
    [[UserModel sharedModel] asyncUserPointRuleListWithRemoteBlock:^(NSArray *list, NSError *error) {
        _strong(self);
        if (!error) {
            self.ruleArray = list;
        }
    }];
}

@end
