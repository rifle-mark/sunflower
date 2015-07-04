//
//  CALayer+IBAttribute.m
//  Sunflower
//
//  Created by mark on 15/4/24.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CALayer+IBAttribute.h"

@implementation CALayer (IBAttribute)

@dynamic borderIBColor;

-(void)setBorderIBColor:(UIColor *)borderIBColor {
    self.borderColor = borderIBColor.CGColor;
}
@end
