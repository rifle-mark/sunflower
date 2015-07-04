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
    return [[NSString stringWithFormat:@"%@api/", k_API_DOMAIN_PREFIX] stringByAppendingPathComponent:suffix];
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

@end
