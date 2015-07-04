//
//  UIView+FrameOperation.h
//  IPSShelf
//
//  Created by zhoujinqiang on 14-6-18.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameOperation)

- (void)setFrameX:(CGFloat)x;
- (void)setFrameY:(CGFloat)y;
- (void)setFrameWidth:(CGFloat)width;
- (void)setFrameHeight:(CGFloat)height;
- (void)setFrameSize:(CGSize)size;
- (void)setFrameOrigin:(CGPoint)origin;

- (void)setPosition:(CGPoint)p anchor:(CGPoint)anchor;
- (void)setSize:(CGSize)wh position:(CGPoint)p anchor:(CGPoint)anchor;

- (void)cleanUp;

@end
