//
//  WeiSubCommentCell.m
//  Sunflower
//
//  Created by makewei on 15/6/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "WeiSubCommentCell.h"

#import "WeiComment.h"
#import "UserModel.h"
@interface WeiSubCommentCell ()

@property(nonatomic,strong)UIImageView      *avatarV;
@property(nonatomic,strong)UILabel          *nickNameL;
@property(nonatomic,strong)UILabel          *timeL;
@property(nonatomic,strong)UILabel          *contentL;

@end

@implementation WeiSubCommentCell

+ (NSString *)reuseIdentify {
    return @"WeiSubCommentCellIdentify";
}

+ (CGFloat)heightWithComment:(WeiCommentInfo *)comment screenWidth:(CGFloat)width {
    CGRect strRect = [[WeiSubCommentCell _contentAttributeStringWithComment:comment] boundingRectWithSize:ccs(width - 86, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return strRect.size.height + 15+12+10+15;
}

+ (NSAttributedString *)_contentAttributeStringWithComment:(WeiCommentInfo *)comment {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = NSTextAlignmentLeft;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.lineHeightMultiple = 1;
    NSDictionary *att = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:11],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps};
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:comment.content attributes:att];
    return str;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB(228, 228, 228);
        _weak(self);
        self.avatarV = [[UIImageView alloc] init];
        self.avatarV.clipsToBounds = YES;
        self.avatarV.layer.cornerRadius = 22;
        [self.contentView addSubview:self.avatarV];
        [self.avatarV mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(12);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.height.equalTo(@44);
        }];
        
        self.timeL = [[UILabel alloc] init];
        self.timeL.backgroundColor = k_COLOR_CLEAR;
        self.timeL.font = [UIFont boldSystemFontOfSize:12];
        self.timeL.textColor = k_COLOR_GALLERY_F;
        self.timeL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeL];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(20);
            make.right.equalTo(self.contentView).with.offset(-17);
            make.height.equalTo(@12);
            make.width.equalTo(@100);
        }];
        
        self.nickNameL = [[UILabel alloc] init];
        self.nickNameL.backgroundColor = k_COLOR_CLEAR;
        self.nickNameL.font = [UIFont boldSystemFontOfSize:12];
        self.nickNameL.textColor = k_COLOR_BLUE;
        [self.contentView addSubview:self.nickNameL];
        [self.nickNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.contentView).with.offset(15);
            make.left.equalTo(self.contentView).with.offset(69);
            make.right.equalTo(self.timeL.mas_left).with.offset(-5);
            make.height.equalTo(@12);
        }];
        
        self.contentL = [[UILabel alloc] init];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            _strong(self);
            make.top.equalTo(self.nickNameL.mas_bottom).with.offset(10);
            make.left.equalTo(self.nickNameL);
            make.right.equalTo(self.contentView).with.offset(-17);
            make.bottom.equalTo(self.contentView).with.offset(-15);
        }];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer *gesture) {
            _strong(self);
            if (gesture.state == UIGestureRecognizerStateBegan) {
                GCBlockInvoke(self.longTapBlock, self.comment);
            }
        }];
        [self.contentView addGestureRecognizer:longTap];
        
        [self _setupObserver];
    }
    return self;
}

- (void)_setupObserver {
    _weak(self);
    [self startObserveObject:self forKeyPath:@"comment" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        _strong(self);
        [self.avatarV setImageWithURL:[NSURL URLWithString:self.comment.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.nickNameL.text = self.comment.nickName;
        self.timeL.text = [self.comment.createDate dateTimeByNow];
        self.contentL.attributedText = [[self class] _contentAttributeStringWithComment:self.comment];
    }];
}

@end