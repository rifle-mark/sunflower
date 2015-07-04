//
//  MKWPushNotificationHandler.h
//  Sunflower
//
//  Created by makewei on 15/6/30.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKWPushNotificationHandler : NSObject

+ (instancetype)sharedHandler;

- (void)setupPushWithLaunchOptions:(NSDictionary *)launchOptions;
- (void)handlePushNotification:(NSDictionary *)pushNotiDic rootVC:(UIViewController *)vc;

@end
