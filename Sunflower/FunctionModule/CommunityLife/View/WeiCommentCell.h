//
//  WeiCommentCell.h
//  Sunflower
//
//  Created by makewei on 15/6/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiComment.h"

@interface WeiCommentPicCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView      *imgV;

+ (NSString *)reuseIdentify;

@end

@interface WeiCommentCell : UITableViewCell

@property(nonatomic,strong)WeiCommentInfo   *comment;
@property(nonatomic,assign)BOOL             isUped;

@property(nonatomic,copy)void(^likeActionBlock)(WeiCommentInfo *comment);
@property(nonatomic,copy)void(^commentActionBlock)(WeiCommentInfo *comment);
@property(nonatomic,copy)void(^actionBlock)(WeiCommentCell *cell);
@property(nonatomic,copy)void(^picShowBlock)(NSArray *picUrlArray, NSInteger index);

+ (NSString *)reuseIdentify;
+ (CGFloat)heightWithComment:(WeiCommentInfo *)comment screenWidth:(CGFloat)width;

- (void)addUpCount;
- (void)addCommentCount;
@end
