//
//  AppDelegate.m
//  Sunflower
//
//  Created by mark on 15/4/16.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationModule.h"
#import "CommonModel.h"
#import "MKWModelHandler.h"
#import "BPush.h"
#import "MKWWeiPayHandler.h"
#import "WXApi.h"

#import "MKWShareModule.h"
#import "MKWPushNotificationHandler.h"

#import <AlipaySDK/AlipaySDK.h>
#import <ShareSDK/ShareSDK.h>


@interface AppDelegate ()

@property(nonatomic,strong)LocationModule *locationModule;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // hold the CLLocationManager object, otherwise we can not get the user location.
    self.locationModule = [LocationModule sharedModule];
    
    // 设置弹出提示框样式
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    // 设置友盟统计
    [MobClick startWithAppkey:@"5583936367e58ecdc6000e53" reportPolicy:BATCH channelId:@""];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
//    [[MKWPushNotificationHandler sharedHandler] setupPushWithLaunchOptions:launchOptions];
    // App 是用户点击推送消息启动
    
    //test
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
        
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //角标清0
    
    
    NSString *displayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    [WXApi registerApp:@"wx9d7542e3d90fd680" withDescription:displayName];
    //第三方平台
    [MKWShareModule registerApp];
    [MKWShareModule connectDestinations];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[MKWModelHandler defaultHandler] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[MKWModelHandler defaultHandler] saveContext];
}

-(void)dealloc {
    [self.locationModule stopLocation];
}

#pragma mark - Push

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [BPush handleNotification:userInfo];
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        GCAlertView *alertV = [[GCAlertView alloc] initWithTitle:@"您有一条新通知" andMessage:[NSString stringWithFormat:@"%@", alert]];
        [alertV setCancelButtonWithTitle:@"好的" actionBlock:nil];
        [alertV show];
    }
    else {
        [[MKWPushNotificationHandler sharedHandler] handlePushNotification:userInfo rootVC:self.window.rootViewController];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
    }];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark - URL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([url.scheme isEqualToString:@"alsunflower2088911835508633"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_SUCCESS object:nil userInfo:nil];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_FAILED object:nil userInfo:nil];
            }
        }];
        return YES;
    }
    
    return [WXApi handleOpenURL:url delegate:self] || [ShareSDK handleOpenURL:url wxDelegate:nil];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"alsunflower2088911835508633"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_SUCCESS object:nil userInfo:nil];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_FAILED object:nil userInfo:nil];
            }
        }];
        return YES;
    }
    
    return [WXApi handleOpenURL:url delegate:self] || [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
    
    return YES;
}

-(void) onReq:(BaseReq*)req
{
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_SUCCESS object:nil userInfo:nil];
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_FAILED object:nil userInfo:nil];
                break;
        }
    }
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_WXAUTH_SUCCESS object:nil userInfo:dic];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_WXAUTH_FAILED object:nil userInfo:nil];
        }
    }
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *mresp = (SendMessageToWXResp *)resp;
        if (mresp.errCode == 0) {
            GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"分享成功" andMessage:@"微信分享成功"];
            [alert setCancelButtonWithTitle:@"好的" actionBlock:nil];
            [alert show];
        }
        else {
            GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"分享失败" andMessage:@"微信分享失败"];
            [alert setCancelButtonWithTitle:@"好的" actionBlock:nil];
            [alert show];
        }
    }
}

@end
