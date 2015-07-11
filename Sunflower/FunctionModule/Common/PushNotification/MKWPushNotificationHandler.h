//
//  MKWPushNotificationHandler.h
//  Sunflower
//
//  Created by makewei on 15/6/30.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPush.h"

@interface MKWPushNotificationHandler : NSObject

@property(nonatomic,weak)UIViewController *currentvc;

+ (instancetype)sharedHandler;

- (void)setupPushWithLaunchOptions:(NSDictionary *)launchOptions pushMode:(BPushMode)pushMode isDebug:(BOOL)isDebug;
- (void)handlePushNotification:(NSDictionary *)pushNotiDic rootVC:(UIViewController *)vc;

@end
