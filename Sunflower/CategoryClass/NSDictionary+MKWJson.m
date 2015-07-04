//
//  NSDictionary+MKWJson.m
//  Sunflower
//
//  Created by mark on 15/5/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "NSDictionary+MKWJson.h"

@implementation NSDictionary (MKWJson)

- (NSDictionary *)validModelDictionary {
    NSMutableDictionary* validDictionary = [self mutableCopy];
    for (NSString* key in [self allKeys]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSString class]] && [value hasPrefix:@"/Date("]) {
            NSRange range = NSMakeRange(6, 10);
            NSString *sdate = [(NSString*)value substringWithRange:range];
            NSNumber* date = [NSNumber numberWithLongLong:[sdate longLongValue]];
            [validDictionary setObject:date forKey:key];
        }
    }
    return validDictionary;
}

@end
