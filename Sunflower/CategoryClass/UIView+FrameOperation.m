//
//  UIView+FrameOperation.m
//  IPSShelf
//
//  Created by zhoujinqiang on 14-6-18.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import "UIView+FrameOperation.h"

@implementation UIView (FrameOperation)

- (void)setFrameX:(CGFloat)x {
    self.frame = CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
- (void)setFrameY:(CGFloat)y {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
- (void)setFrameWidth:(CGFloat)width {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, CGRectGetHeight(self.frame));
}
- (void)setFrameHeight:(CGFloat)height {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height);
}
- (void)setFrameSize:(CGSize)size {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), size.width, size.height);
}
- (void)setFrameOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)setPosition:(CGPoint)p anchor:(CGPoint)anchor{
    CGSize wh = self.frame.size;
    self.frame = CGRectMake((int)(p.x - anchor.x*wh.width), (int)(p.y - anchor.y*wh.height), wh.width, wh.height);
}

- (void)setSize:(CGSize)wh position:(CGPoint)p anchor:(CGPoint)anchor{
    self.bounds = (CGRect){{0, 0}, wh};
    self.frame = CGRectMake((int)(p.x - anchor.x*wh.width), (int)(p.y - anchor.y*wh.height), wh.width, wh.height);
}

- (void)cleanUp{
    NSArray *array = [NSArray arrayWithArray:[self subviews]];
    [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (instancetype)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id view = [subView findFirstResponder];
        if (view) {
            return view;
        }
    }
    return nil;
}

- (BOOL)containsTheView:(UIView *)view {
    if (self == view) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView containsTheView:view]) {
            return YES;
        }
    }
    return NO;
}

- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    if ([responder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)responder;
    }
    return nil;
}

- (CGRect)frameWithSubview:(UIView *)subview {
    if (self == subview)
        return CGRectMake(0, 0, subview.frame.size.width, subview.frame.size.height);
    CGPoint origin = CGPointZero;
    for (UIView *view = subview; view != self; view = view.superview) {
        origin.x += view.frame.origin.x;
        origin.y += view.frame.origin.y;
    }
    return CGRectMake(origin.x, origin.y, subview.frame.size.width, subview.frame.size.height);
}

@end