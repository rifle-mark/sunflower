//
//  IPSShareModule.m
//  IPSShelf
//
//  Created by makewei on 14-5-13.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import "MKWShareModule.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"


#define WeiboSDKClass       [WeiboSDK class]
#define QQApiInterfaceClass [QQApiInterface class]
#define TencentOAuthClass   [TencentOAuth class]
#define RennClientClass     nil     //[RennClient class]
#define PinterestClass      nil     //[Pinterest class]
#define YXApiClass          nil     //[YXApi class]

static NSArray *platforms;
static NSString *key_weibo;
static NSString *sec_weibo;
static NSString *url_weibo;

@implementation MKWShareModule

#pragma mark - class public method
+ (void)initialize {
    platforms = @[/*@1,   新浪微博*/
                  /*@2,   腾讯微博*/
                  @6,   /*QQ空间*/
                  @22,  /*微信好友*/
                  @23,  /*微信朋友圈*/
                  @24,  /*QQ*/
                  /*@37,  微信收藏*/
                  ];
}
+ (void)registerApp {
    [ShareSDK registerApp:@"73e187b6ad64"];
    [ShareSDK ssoEnabled:[MKWShareModule enableSSO]];
}

+ (BOOL)enableSSO {
    return YES;
}

+(NSArray *)platforms {
    return platforms;
}

+ (void)connectDestinations {
    for (NSNumber *p in platforms) {
        switch ((ShareType)[p intValue]) {
            case ShareTypeSinaWeibo:
                [MKWShareModule _connectSinaWeibo];
                break;
            case ShareTypeTencentWeibo:
                [MKWShareModule _connectTencentWeibo];
                break;
            case ShareTypeQQSpace:
                [MKWShareModule _connectQQSpace];
                break;
            case ShareTypeWeixiSession:
                [MKWShareModule _connectWeixiSession];
                break;
            case ShareTypeWeixiTimeline:
                [MKWShareModule _connectWeiXinTimeline];
                break;
            case ShareTypeQQ:
                [MKWShareModule _connectQQ];
                break;
            default:
                break;
        }
    }
}

#pragma mark - private class method
/**
  新浪微博分享配置信息
 */
+ (void)_connectSinaWeibo {
    if ([MKWShareModule enableSSO]) {
        [ShareSDK connectSinaWeiboWithAppKey:@""
                                   appSecret:@""
                                 redirectUri:@""
                                 weiboSDKCls:WeiboSDKClass];
    }
    else {
    [ShareSDK connectSinaWeiboWithAppKey:@""
                               appSecret:@""
                             redirectUri:@""];
    }
}

/**
 腾讯微博分享配置信息
 */
+ (void)_connectTencentWeibo {

    [ShareSDK connectTencentWeiboWithAppKey:@""
                                  appSecret:@""
                                redirectUri:@""
                                   wbApiCls:WeiboSDKClass];
}

/**
  QQ空间分享配置信息
 */
+ (void)_connectQQSpace {

    [ShareSDK connectQZoneWithAppKey:@"1104627811"
                           appSecret:@"muUki5AVbsDfVvoE"
                   qqApiInterfaceCls:QQApiInterfaceClass
                     tencentOAuthCls:TencentOAuthClass];
}

/**
 *
 *  微信分享配置信息
 */
+ (void)_connectWeixiSession {
    [ShareSDK connectWeChatSessionWithAppId:@"wx9d7542e3d90fd680" appSecret:@"65794a56b94ac0ff176c609f4103068e" wechatCls:[WXApi class]];
}

+ (void)_connectWeiXinTimeline {
    [ShareSDK connectWeChatTimelineWithAppId:@"wx9d7542e3d90fd680" appSecret:@"65794a56b94ac0ff176c609f4103068e" wechatCls:[WXApi class]];
}

/**
 *  QQ应用分享配置信息
 */
+ (void)_connectQQ {

    [ShareSDK connectQQWithQZoneAppKey:@"1104627811"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
}


+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation delegate:(id)delegate {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:delegate];
}

+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id)delegate {
    return [ShareSDK handleOpenURL:url wxDelegate:delegate];
}

@end
