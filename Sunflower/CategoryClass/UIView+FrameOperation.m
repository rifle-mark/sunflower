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

@end