//
//  NSStringHelper.m
//  IPSFoundation
//
//  Created by zhoujinqiang on 14-5-26.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import "MKWStringHelper.h"

@implementation MKWStringHelper

+ (NSString *)trimWithStr:(NSString *)str {
    NSMutableString *mStr = [str mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    NSString *result = [mStr copy];
    return result;
//    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (BOOL)isNilOrEmptyString:(NSString *)str {
    if (!str) {
        return YES;
    }
    if ([str isEqual:[NSNull null]]) {
        return YES;
    }
    if (0 == [str length]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNilEmptyOrBlankString:(NSString *)str {
    
    NSString *tmpStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [MKWStringHelper isNilOrEmptyString:tmpStr];
}

+ (BOOL) isValidateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)isVAlidatePhoneNumber:(NSString *)str {
    NSString *phoneNumRegex = @"(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}";
    NSPredicate *phoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumRegex];
    
    return [phoneNumTest evaluateWithObject:str];
}

+ (NSString *)createGUIDString {
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    return (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
}


+ (NSString *)dateTimeStringForArticleWithDate:(NSDate *)date {
    NSDate *useDate = [NSDate dateWithTimeInterval:(-8 * 60 * 60) sinceDate:date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MMM"];
    NSString *month = [formater stringFromDate:useDate];
    [formater setDateFormat:@"dd"];
    NSString *day = [formater stringFromDate:useDate];
    [formater setDateFormat:@"yyyy"];
    NSString *year = [formater stringFromDate:useDate];
    [formater setDateFormat:@"KK:mmaa"];
    NSString *time = [formater stringFromDate:useDate];
    return [NSString stringWithFormat:@"%@ %@th %@ at %@", month, day, year, time];
}
@end
