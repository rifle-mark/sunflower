//
//  IPSColorHelper.m
//  IPSFoundation
//
//  Created by makewei on 14-5-26.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import "MKWColorHelper.h"
#import <UIKit/UIKit.h>

@implementation MKWColorHelper

+ (UIColor*)monthColor{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger month= [components month];
    switch (month) {
        case 1:
            return [MKWColorHelper colorWithHexString:@"#d2b40c"];
            break;
        case 2:
            return [MKWColorHelper colorWithHexString:@"#8dd39c"];
            break;
        case 3:
            return [MKWColorHelper colorWithHexString:@"#0dbc62"];
            break;
        case 4:
            return [MKWColorHelper colorWithHexString:@"#d248a1"];
            break;
        case 5:
            return [MKWColorHelper colorWithHexString:@"#d248a1"];//#d1d30a
            break;
        case 6:
            return [MKWColorHelper colorWithHexString:@"#07d3d6"];
            break;
        case 7:
            return [MKWColorHelper colorWithHexString:@"#472dc9"];
            break;
        case 8:
            return [MKWColorHelper colorWithHexString:@"#06c665"];
            break;
        case 9:
            return [MKWColorHelper colorWithHexString:@"#a1d30a"];
            break;
        case 10:
            return [MKWColorHelper colorWithHexString:@"#d75427"];
            break;
        case 11:
            return [MKWColorHelper colorWithHexString:@"#d2b40b"];
            break;
        case 12:
            return [MKWColorHelper colorWithHexString:@"#d1d30a"];
            break;
        default:
            return [MKWColorHelper colorWithHexString:@"#ffd802"];
            break;
    }
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert withAlpha:(float)alpha{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexRGBAString:(NSString *)stringToConvert {
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 8)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    range.location = 6;
    NSString *aString = [cString substringWithRange:range];
    
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}

+ (int)ipsHexToInt:(NSString *)string
{
    int   num[16]={0};
    int   count=1;
    int   result=0;
    
    int length=(int)[string length];
    for   (int i=length-1;i>=0;i--)
    {
        if (([string characterAtIndex:i]>='0') && ([string characterAtIndex:i]<='9'))
            num[i]=[string characterAtIndex:i]-'0';//字符0的ASCII值为48
        else if (([string characterAtIndex:i]>='a') && ([string characterAtIndex:i]<='f'))
            num[i]=[string characterAtIndex:i]-'a'+10;
        else if (([string characterAtIndex:i]>='A') && ([string characterAtIndex:i]<='F'))
            num[i]=[string characterAtIndex:i]-'A'+10;
        else
            num[i]=0;
        result=result+num[i]*count;
        count=count*16;//十六进制
    }
    return result;
}

+ (UIColor *)ipsHTMLColorToColor:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    int colorValue=[self ipsHexToInt:string];
    
    float r=((float)((colorValue>>16)&0XFF))/255;//colorWithCalibratedRed：参数在0－1之内
    float g=((float)((colorValue>>8)&0XFF))/255;
    float b=((float)(colorValue&0XFF))/255;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
