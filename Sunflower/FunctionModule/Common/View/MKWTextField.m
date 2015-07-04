//
//  MKWTextField.m
//  Sunflower
//
//  Created by makewei on 15/5/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWTextField.h"

@implementation MKWTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectMake(
                      rect.origin.x + _textEdgeInset.left,
                      rect.origin.y + _textEdgeInset.top,
                      rect.size.width - _textEdgeInset.left - _textEdgeInset.right,
                      rect.size.height - _textEdgeInset.top - _textEdgeInset.bottom
                      );

}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect = [super editingRectForBounds:bounds];
    return CGRectMake(
                      rect.origin.x + _textEdgeInset.left,
                      rect.origin.y + _textEdgeInset.top,
                      rect.size.width - _textEdgeInset.left - _textEdgeInset.right,
                      rect.size.height - _textEdgeInset.top - _textEdgeInset.bottom
                      );
}

- (void)setTextEdgeRect:(CGRect)textEdgeRect {
    self.textEdgeInset = UIEdgeInsetsMake(textEdgeRect.origin.y, textEdgeRect.origin.x, textEdgeRect.size.height, textEdgeRect.size.width);
}

- (CGRect)textEdgeRect {
    return CGRectMake(self.textEdgeInset.left, self.textEdgeInset.top, self.textEdgeInset.right, self.textEdgeInset.bottom);
}

@end
