//
//  WeiSubCommentCell.h
//  Sunflower
//
//  Created by makewei on 15/6/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiCommentInfo;
@interface WeiSubCommentCell : UITableViewCell

@property(nonatomic,strong)WeiCommentInfo   *comment;
@property(nonatomic,copy)void(^longTapBlock)(WeiCommentInfo *comment);
+ (NSString *)reuseIdentify;

+ (CGFloat)heightWithComment:(WeiCommentInfo *)comment screenWidth:(CGFloat)width;
@end
