//
//  APIGenerator.h
//  Sunflower
//
//  Created by makewei on 15/6/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>

#define k_API_DOMAIN_PREFIX         @"http://210.73.220.102/"
#define k_UPLOADIMG_DOMAIN_PREFIX   @"http://210.73.220.102:8080/"
#define k_API_DOMAIN_WITHOUT_HTTP   @"210.73.220.102/"


//#define k_API_DOMAIN_PREFIX         @"http://wgweb.createapp.cn/api/"
//#define k_UPLOADIMG_DOMAIN_PREFIX   @"http://wgitem.createapp.cn/"

@interface APIGenerator : NSObject

+ (NSString *)apiAddressWithSuffix:(NSString *)suffix;
+ (NSString *)normalAddressWithSuffix:(NSString *)suffix;
+ (NSString *)uploadImgAddressWithSuffix:(NSString *)suffix;

+ (NSString *)urlAddWithoutHTTP:(NSString *)suffix;

+ (NSURL*)urlOfPictureWith:(CGFloat)width height:(CGFloat)height urlString:(NSString*)urlStr;

@end
