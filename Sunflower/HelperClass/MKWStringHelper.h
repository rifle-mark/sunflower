//
//  NSStringHelper.h
//  IPSFoundation
//
//  Created by zhoujinqiang on 14-5-26.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKWStringHelper : NSObject

+ (BOOL)isNilOrEmptyString:(NSString *)str;

+ (BOOL)isNilEmptyOrBlankString:(NSString *)str;

+ (BOOL)isValidateEmail:(NSString *)candidate;

+ (BOOL)isVAlidatePhoneNumber:(NSString *)str;

+ (NSString *)trimWithStr:(NSString *)str;

+ (NSString *)createGUIDString;

/**
 *  文章列表及详情页面获取时间字符串，返回格式为：MMM ddth yyyy at KK:mmaa
 *
 *  @param date 需要转换的时间日期
 *
 *  @return 时间日期字符串
 */
+ (NSString *)dateTimeStringForArticleWithDate:(NSDate *)date;
@end
