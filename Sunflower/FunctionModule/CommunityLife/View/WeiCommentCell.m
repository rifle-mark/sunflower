//
//  WeiCommentCell.m
//  Sunflower
//
//  Created by makewei on 15/6/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "WeiCommentCell.h"

static CGFloat splitHeight = 5;
static CGFloat userVHeight = 68;
static CGFloat controlHeight = 47;

@implementation WeiCommentPicCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imgV];
        _weak(self);
        self.clipsToBounds = YES;
        [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)prepareForReuse {
    self.imgV.contentMode = UIViewContentModeCenter;
    self.imgV.backgroundColor = k_COLOR_GALLERY;
    [self.imgV setImage:[UIImage imageNamed:@"default_placeholder"]];
}

+ (NSString *)reuseIdentify {
    return @"WeiCommentPicCellIdentify";
}

@end

@interface WeiCommentCell()

@property(nonatomic,strong)UIView       *splitV;
@property(nonatomic,strong)UIButton     *actionBtn;
@property(nonatomic,strong)UIView       *nameSplitV;
@property(nonatomic,strong)UIView       *controlSplitV;
@property(nonatomic,strong)UIView       *btnSplitV;
@property(nonatomic,strong)UIView       *userView;
@property(nonatomic,strong)UIImageView  *avatarV;
@property(nonatomic,strong)UILabel      *nameL;
@property(nonatomic,strong)UILabel      *timeL;
@property(nonatomic,strong)UILabel      *time2L;
@property(nonatomic,strong)UIView       *contentV;
@property(nonatomic,strong)UILabel      *contentL;
@property(nonatomic,strong)UICollectionView *picsV;
@property(nonatomic,strong)UIView       *controlV;
@property(nonatomic,strong)UIButton     *upBtn;
@property(nonatomic,strong)UIButton     *commentBtn;

@property(nonatomic,strong)NSArray      *picUrlVArray;

@end

@implementation WeiCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self _setupSubViews];
        [self _setupObserver];
        [self updateConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints {
    [super updateConstraints];
    _weak(self);
    [self.splitV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(splitHeight));
    }];
    
    [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentView).with.offset(splitHeight);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(userVHeight));
    }];
    
    [self.avatarV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.centerY.equalTo(self.userView);
        make.left.equalTo(self.userView).with.offset(10);
        make.width.height.equalTo(@44);
    }];
    
    [self.actionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.userView).with.offset(14);
        make.right.equalTo(self.userView);
        make.width.equalTo(@34);
        make.height.equalTo(@19);
    }];
    
    [self.timeL mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.userView).with.offset(20);
        make.right.equalTo(self.userView).with.offset(-36);
        make.height.equalTo(@12);
        make.width.equalTo(@120);
    }];
    
    [self.nameL mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.userView).with.offset(20);
        make.left.equalTo(self.userView).with.offset(66);
        make.right.equalTo(self.timeL.mas_left).with.offset(-5);
        make.height.equalTo(@17);
    }];
    
    [self.time2L mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.nameL.mas_bottom).with.offset(5);
        make.left.equalTo(self.nameL);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@12);
    }];
    
    [self.nameSplitV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.equalTo(self.userView).with.offset(66);
        make.bottom.equalTo(self.userView);
        make.right.equalTo(self.userView);
        make.height.equalTo(@1);
    }];
    
    [self.controlV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@47);
    }];
    
    [self.controlSplitV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.left.right.equalTo(self.controlV);
        make.height.equalTo(@1);
    }];
    
    [self.btnSplitV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.centerX.equalTo(self.controlV);
        make.top.bottom.equalTo(self.controlV);
        make.width.equalTo(@1);
    }];
    
    [self.upBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.controlV).with.offset(1);
        make.left.bottom.equalTo(self.controlV);
        make.right.equalTo(self.btnSplitV.mas_left);
    }];
    
    [self.commentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.controlV).with.offset(1);
        make.right.bottom.equalTo(self.controlV);
        make.left.equalTo(self.btnSplitV.mas_right);
    }];
    
    [self.contentV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.userView.mas_bottom);
        make.left.equalTo(self.contentView).with.offset(66);
        make.right.equalTo(self.contentView).with.offset(-34);
        make.bottom.equalTo(self.controlV.mas_top);
    }];
    
    [self.contentL mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentV).with.offset(10);
        make.left.right.equalTo(self.contentV);
        make.height.equalTo(@([[self class] _contentHeightWithComment:self.comment screenWidth:V_W_([UIApplication sharedApplication].keyWindow)]));
    }];
    
    [self.picsV mas_remakeConstraints:^(MASConstraintMaker *make) {
        _strong(self);
        make.top.equalTo(self.contentL.mas_bottom).with.offset(10);
        make.left.right.equalTo(self.contentV);
        NSInteger picRowNumber = [WeiCommentCell _picRowNumberWithComment:self.comment];
        CGFloat picHeight = [WeiCommentCell _picHeightWithScreenWidth:V_W_([UIApplication sharedApplication].keyWindow)];
        make.height.equalTo(@((picRowNumber==0?0:picRowNumber*(5+picHeight)+15)));
    }];
    
    
}

- (void)_setupSubViews {
    _weak(self);
    _splitV = [[UIView alloc] init];
    _splitV.backgroundColor = k_COLOR_GALLERY;
    [self.contentView addSubview:_splitV];
    
    self.userView = [[UIView alloc] init];
    self.userView.backgroundColor = k_COLOR_CLEAR;
    [self.contentView addSubview:self.userView];
    
    self.avatarV = [[UIImageView alloc] init];
    self.avatarV.clipsToBounds = YES;
    self.avatarV.layer.cornerRadius = 22;
    [self.userView addSubview:self.avatarV];
    
    
    _actionBtn = [[UIButton alloc] init];
    [_actionBtn setBackgroundImage:[UIImage imageNamed:@"cl_weicomment_action_btn"] forState:UIControlStateNormal];
    [_actionBtn setBackgroundImage:[UIImage imageNamed:@"cl_weicomment_action_btn"] forState:UIControlStateHighlighted];
    [_actionBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        GCBlockInvoke(self.actionBlock, self);
    }];
    
    [self.userView addSubview:self.actionBtn];
    
    
    self.timeL = [[UILabel alloc] init];
    self.timeL.backgroundColor = k_COLOR_CLEAR;
    self.timeL.font = [UIFont boldSystemFontOfSize:12];
    self.timeL.textColor = k_COLOR_GALLERY_F;
    self.timeL.textAlignment = NSTextAlignmentRight;
    [self.userView addSubview:self.timeL];
    
    
    self.nameL = [[UILabel alloc] init];
    self.nameL.backgroundColor = k_COLOR_CLEAR;
    self.nameL.font = [UIFont boldSystemFontOfSize:17];
    self.nameL.textColor = k_COLOR_BLUE;
    [self.userView addSubview:self.nameL];
    
    
    self.time2L = [[UILabel alloc] init];
    self.time2L.backgroundColor = k_COLOR_CLEAR;
    self.time2L.font = [UIFont boldSystemFontOfSize:12];
    self.time2L.textColor = k_COLOR_GALLERY_F;
    [self.userView addSubview:self.time2L];
    
    
    _nameSplitV = [[UIView alloc] init];
    _nameSplitV.backgroundColor = k_COLOR_GALLERY;
    [self.userView addSubview:self.nameSplitV];
    
    
    self.controlV = [[UIView alloc] init];
    self.controlV.backgroundColor = k_COLOR_CLEAR;
    [self.contentView addSubview:self.controlV];
    
    
    _controlSplitV = [[UIView alloc] init];
    _controlSplitV.backgroundColor = k_COLOR_GALLERY;
    [self.controlV addSubview:self.controlSplitV];
    
    
    _btnSplitV = [[UIView alloc] init];
    _btnSplitV.backgroundColor = k_COLOR_GALLERY;
    [self.controlV addSubview:self.btnSplitV];
    
    
    self.upBtn = [[UIButton alloc] init];
    [self.upBtn setImage:[UIImage imageNamed:@"cl_weicomment_up_btn"] forState:UIControlStateNormal];
    [self.upBtn setImage:[UIImage imageNamed:@"cl_weicomment_up_btn_h"] forState:UIControlStateDisabled];
    self.upBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    self.upBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    self.upBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.upBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
    [self.upBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [self.upBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        GCBlockInvoke(self.likeActionBlock, self.comment);
    }];
    [self.controlV addSubview:self.upBtn];
    
    
    self.commentBtn = [[UIButton alloc] init];
    [self.commentBtn setImage:[UIImage imageNamed:@"cl_weicomment_sub_btn"] forState:UIControlStateNormal];
    self.commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    self.commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    self.commentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.commentBtn setTitleColor:k_COLOR_GALLERY_F forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:k_COLOR_GALLERY forState:UIControlStateHighlighted];
    [self.commentBtn addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
        _strong(self);
        GCBlockInvoke(self.commentActionBlock, self.comment);
    }];
    [self.controlV addSubview:self.commentBtn];
    
    
    
    self.contentV = [[UIView alloc] init];
    self.contentV.backgroundColor = k_COLOR_CLEAR;
    [self.contentView addSubview:self.contentV];
    
    
    self.contentL = [[UILabel alloc] init];
    self.contentL.numberOfLines = 0;
    [self.contentV addSubview:self.contentL];
    
    UICollectionViewFlowLayout *picLayout = [[UICollectionViewFlowLayout alloc] init];
    picLayout.minimumLineSpacing = 5;
    picLayout.minimumInteritemSpacing = 5;
    picLayout.headerReferenceSize = ccs(0, 0);
    picLayout.footerReferenceSize = ccs(0, 0);
    picLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    CGFloat picWH = [[self class] _picHeightWithScreenWidth:[[UIScreen mainScreen] bounds].size.width];
    picLayout.itemSize = ccs(picWH, picWH);
    self.picsV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:picLayout];
    [self.picsV registerClass:[WeiCommentPicCell class] forCellWithReuseIdentifier:[WeiCommentPicCell reuseIdentify]];
    self.picsV.showsHorizontalScrollIndicator = NO;
    self.picsV.showsVerticalScrollIndicator = NO;
    [self.picsV setScrollEnabled:NO];
    self.picsV.backgroundColor = k_COLOR_WHITE;

    [self.picsV withBlockForSectionNumber:^NSInteger(UICollectionView *view) {
        return 1;
    }];
    [self.picsV withBlockForItemNumber:^NSInteger(UICollectionView *view, NSInteger section) {
        _strong(self);
        return [self.picUrlVArray count];
    }];
    [self.picsV withBlockForItemCell:^UICollectionViewCell *(UICollectionView *view, NSIndexPath *path) {
        _strong(self);
        WeiCommentPicCell *cell = [view dequeueReusableCellWithReuseIdentifier:[WeiCommentPicCell reuseIdentify] forIndexPath:path];
        if (!cell) {
            cell = [[WeiCommentPicCell alloc] init];
        }
        _weak(cell);
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:self.picUrlVArray[path.row]] placeholderImage:[UIImage imageNamed:@"default_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                _strong(cell);
                cell.imgV.contentMode = UIViewContentModeScaleToFill;
                cell.imgV.image = image;
            }
        }];
        
        return cell;
    }];
    [self.picsV withBlockForItemDidSelect:^(UICollectionView *view, NSIndexPath *path) {
        _strong(self);
        GCBlockInvoke(self.picShowBlock, self.picUrlVArray, path.item);
    }];
    
    [self.contentV addSubview:self.picsV];
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"comment" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.avatarV sd_setImageWithURL:[APIGenerator urlOfPictureWith:44 height:44 urlString:self.comment.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.nameL.text = self.comment.nickName;
        self.timeL.text = [self.comment.createDate dateTimeByNow];
        self.time2L.text = [self.comment.createDate dateTimeSplitByMinus];
        self.contentL.attributedText = [[self class] _contentAttributeStringWithComment:self.comment];
        
        
        self.picUrlVArray = [[self class] _picUrlArrayWithComment:self.comment];
        [self.picsV reloadData];
        
        
        [self.upBtn setTitle:[NSString stringWithFormat:@"(%@)", self.comment.actionCount] forState:UIControlStateNormal];
        [self.commentBtn setTitle:[NSString stringWithFormat:@"(%@)", self.comment.subCommentCount] forState:UIControlStateNormal];
        
        [self setNeedsUpdateConstraints];
    }];
    
    [self startObserveObject:self forKeyPath:@"isUped" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.upBtn setEnabled:!self.isUped];
    }];
}

- (void)addUpCount {
    [self.upBtn setTitle:[NSString stringWithFormat:@"(%@)", @([self.comment.actionCount integerValue]+1)] forState:UIControlStateNormal];
}
- (void)addCommentCount {
    
}

+ (NSString *)reuseIdentify {
    return @"WeiCommentCellIdentify";
}

+ (CGFloat)heightWithComment:(WeiCommentInfo *)comment screenWidth:(CGFloat)width {

    NSInteger picRowNumber = [WeiCommentCell _picRowNumberWithComment:comment];
    CGFloat picHeight = [WeiCommentCell _picHeightWithScreenWidth:width];
    return splitHeight+userVHeight+(picRowNumber==0?0:picRowNumber*(5+picHeight)+15)+controlHeight+30+[WeiCommentCell _contentHeightWithComment:comment screenWidth:width];
}

+ (CGFloat)_contentHeightWithComment:(WeiCommentInfo *)comment screenWidth:(CGFloat)width {
    if (!comment) {
        return 0;
    }
    NSAttributedString *contentStr = [WeiCommentCell _contentAttributeStringWithComment:comment];
    CGRect contentRect = [contentStr boundingRectWithSize:ccs(width-100, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return contentRect.size.height;
}

+ (NSInteger)_picRowNumberWithComment:(WeiCommentInfo *)comment {
    if ([MKWStringHelper isNilEmptyOrBlankString:comment.images]) {
        return 0;
    }
    NSArray *images = [WeiCommentCell _picUrlArrayWithComment:comment];
    if ([images count] <= 0) {
        return 0;
    }
    
    NSInteger columCount = 3;
    NSUInteger imageCount = [images count];
    NSInteger rowCount = 1;
    while (imageCount > columCount) {
        rowCount += 1;
        imageCount -= 3;
    }
    return rowCount;
}

+ (NSArray*)_picUrlArrayWithComment:(WeiCommentInfo *)comment {
    return [[MKWStringHelper trimWithStr:comment.images] componentsSeparatedByString:@","];
}

+ (CGFloat)_picHeightWithScreenWidth:(CGFloat)width {
    CGFloat totalwidth = width - 110;
    return totalwidth / 3;
}

+ (NSAttributedString *)_contentAttributeStringWithComment:(WeiCommentInfo *)comment {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = NSTextAlignmentLeft;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.lineHeightMultiple = 1;
    NSDictionary *att = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps};
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:comment.content attributes:att];
    return str;
}
@end
