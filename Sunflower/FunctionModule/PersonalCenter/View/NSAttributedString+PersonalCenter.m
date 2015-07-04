//
//  NSAttributedString+PersonalCenter.m
//  Sunflower
//
//  Created by mark on 15/5/14.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "NSAttributedString+PersonalCenter.h"
#import "MKWStringHelper.h"

@implementation NSAttributedString (PersonalCenter)

+ (NSAttributedString *)attributedStringForShopDesc:(NSString *)desc {
    if ([MKWStringHelper isNilEmptyOrBlankString:desc]) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSBaselineOffsetAttributeName: @0};
    NSMutableAttributedString *retStr = [[NSMutableAttributedString alloc] initWithString:desc attributes:attributes];
    
    [retStr boundingRectWithSize:CGSizeMake(0, 0) options:0 context:0];
    return retStr;
}

@end
