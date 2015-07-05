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

/**
 *  查找当前View中被激活的对象
 *
 *  @return 激活的对象
 */
- (instancetype)findFirstResponder;

/**
 *  传入view是当前view的subview(递归)
 *
 *  @param view 需要检查的view
 *
 *  @return YES:包含 NO:不包含
 */
- (BOOL)containsTheView:(UIView *)view;

/**
 *  返回当前view所在的ViewController
 *
 *  @return 当前view所在的ViewController
 */
- (UIViewController *)parentViewController;

/**
 *  返回subview在当前view中的frame，支持多级subview
 *
 *  @param subview 需要取得frame的subview
 *
 *  @return subview在当前view中的frame
 */
- (CGRect)frameWithSubview:(UIView *)subview;

@end
