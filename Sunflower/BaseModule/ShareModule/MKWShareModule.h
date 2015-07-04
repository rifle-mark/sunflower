//
//  IPSShareModule.h
//  IPSShelf
//
//  Created by makewei on 14-5-13.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ISSContent.h>

@interface MKWShareModule : NSObject

/**
 *  按ISPConfiguration.plist中的配置初始化ShareSDK。
 */
+ (void)registerApp;
/**
 *  按ISPConfiguration.plist中的配置连接各分享平台。
 */
+ (void)connectDestinations;

+ (NSArray*)platforms;

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation delegate:(id)delegate;

+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id)delegate;
@end
