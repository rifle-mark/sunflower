//
//  APIGenerator.m
//  Sunflower
//
//  Created by makewei on 15/6/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "APIGenerator.h"

@implementation APIGenerator


+ (NSString *)apiAddressWithSuffix:(NSString *)suffix {
    if ([suffix hasPrefix:@"http"]) {
        return suffix;
    }
//    return [[NSString stringWithFormat:@"%@api/", k_API_DOMAIN_PREFIX] stringByAppendingPathComponent:suffix];
    return [NSString stringWithFormat:@"%@api/%@", k_API_DOMAIN_PREFIX, suffix];
}
+ (NSString *)normalAddressWithSuffix:(NSString *)suffix {
    if ([suffix hasPrefix:@"http"]) {
        return suffix;
    }
    return [k_API_DOMAIN_PREFIX stringByAppendingPathComponent:suffix];
}

+ (NSString *)urlAddWithoutHTTP:(NSString *)suffix {
    return [k_API_DOMAIN_WITHOUT_HTTP stringByAppendingPathComponent:suffix];
}
+ (NSString *)uploadImgAddressWithSuffix:(NSString *)suffix {
    if ([suffix hasPrefix:@"http"]) {
        return suffix;
    }
    return [k_UPLOADIMG_DOMAIN_PREFIX stringByAppendingPathComponent:suffix];
}

+ (NSURL*)urlOfPictureWith:(CGFloat)width height:(CGFloat)height urlString:(NSString*)urlStr {
    if (!urlStr) {
        return nil;
    }
    
    if (width == 0 || height == 0) {
        return [NSURL URLWithString:urlStr];
    }
    if ([UIScreen mainScreen].scale >= 3) {
        width = width * 3;
        height = height * 3;
    }
    if ([UIScreen mainScreen].scale >=2 && [UIScreen mainScreen].scale < 3) {
        width = width * 2;
        height = height * 2;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d-%d-1", urlStr, (int)width, (int)height]];
}

@end
