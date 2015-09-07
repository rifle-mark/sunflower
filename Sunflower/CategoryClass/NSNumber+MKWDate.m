//
//  NSNumber+MKWDate.m
//  Sunflower
//
//  Created by mark on 15/5/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "NSNumber+MKWDate.h"

@implementation NSNumber (MKWDate)


- (NSString*)dateSplitByChinese {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    return [formatter stringFromDate:[self dateOfSelf]];
}
- (NSString*)dateSplitBySplash {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return [formatter stringFromDate:[self dateOfSelf]];
}
- (NSString*)dateSplitByMinus {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[self dateOfSelf]];
}

- (NSString*)dateTimeSplitByChinese {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    return [formatter stringFromDate:[self dateOfSelf]];
}
- (NSString*)dateTimeSplitBySplash {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [formatter stringFromDate:[self dateOfSelf]];
}
- (NSString*)dateTimeSplitByMinus {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[self dateOfSelf]];
}

- (NSString*)dateTimeByNow {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[self dateOfSelf]];
    if (interval <= 60) {
        return @"刚刚";
    }
    if (interval > 60 && interval <= 60*60) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)(interval/60)];
    }
    if (interval > 60*60 && interval <= 24*60*60) {
        return [NSString stringWithFormat:@"%ld小时前", (long)interval/(60*60)];
    }
    if (interval > 24*60*60 && interval <= 7*24*60*60) {
        return [NSString stringWithFormat:@"%ld天前", (long)interval/(24*60*60)];
    }
    if (interval > 7*24*60*60 && interval <= 4*7*24*60*60) {
        return [NSString stringWithFormat:@"%ld周前", (long)interval/(7*24*60*60)];
    }
    
    return [self dateSplitByChinese];
}

- (NSString*)dateTimeYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:[self dateOfSelf]];
}

- (NSString*)dateTimeYearMonth {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    return [formatter stringFromDate:[self dateOfSelf]];
}

- (NSNumber*)dateTimeMonthNumber {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *m = [formatter stringFromDate:[self dateOfSelf]];
    return @([m integerValue]);
}

- (NSDate*)dateOfSelf {
    return [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
}
@end
