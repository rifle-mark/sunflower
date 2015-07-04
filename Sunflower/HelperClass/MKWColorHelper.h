//
//  IPSColorHelper.h
//  IPSFoundation
//
//  Created by makewei on 14-5-26.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGB(r, g, b)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]


#define k_COLOR_MINE_SHAFT       RGB(51, 51, 51)
#define k_COLOR_RED              RGB(201, 50, 50)
#define k_COLOR_YELLOW           RGB(238, 165, 0)
#define k_COLOR_GREEN            RGB(63, 117, 73)
#define k_COLOR_CARNATION        RGB(237, 87, 92)
#define k_COLOR_GRAY             RGB(153, 153, 153)
#define k_COLOR_BLUE             RGB(18, 77, 123)
#define k_COLOR_IRONSIDE_GRAY    RGB(102, 102, 102)
#define k_COLOR_NOBEL            RGB(182, 182, 182)
#define k_COLOR_MASALA           RGB(61, 61, 61)
#define k_COLOR_BON_JOUR         RGB(225, 225, 225)
#define k_COLOR_GALLERY          RGB(240, 240, 240)
#define k_COLOR_GALLERY_F        RGB(80, 80, 80)
#define k_COLOR_TUATARA          RGB(52, 52, 52)
#define k_COLOR_MENU             RGB(26, 26, 26)
#define k_COLOR_COUPON_TEXT      RGB(122, 121, 121)
#define k_COLOR_GRAY_BG          RGB(243, 243, 243)
#define k_COLOR_WHITE            [UIColor whiteColor]
#define k_COLOR_BLACK            [UIColor blackColor]
#define k_COLOR_CLEAR            [UIColor clearColor]

@class UIColor;
@interface MKWColorHelper : NSObject

+ (UIColor*)monthColor;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert withAlpha:(float)alpha;
+ (UIColor *)ipsHTMLColorToColor:(NSString *)string;
+ (UIColor *)colorWithHexRGBAString:(NSString *)stringToConvert;

@end
