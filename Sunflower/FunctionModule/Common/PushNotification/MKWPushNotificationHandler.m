//
//  MKWPushNotificationHandler.m
//  Sunflower
//
//  Created by makewei on 15/6/30.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWPushNotificationHandler.h"
#import "BPush.h"
#import "CommonModel.h"
#import "UserModel.h"
#import "PropertyNotifyVC.h"

@implementation MKWPushNotificationHandler

+ (instancetype)sharedHandler {
    static MKWPushNotificationHandler *ret = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        ret = [[MKWPushNotificationHandler alloc] init];
    });
    
    return ret;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addObserverForNotificationName:k_NOTIFY_NAME_CURRENT_COMMUNITY_CHANGED usingBlock:^(NSNotification *notification) {
            NSNumber *communityId = [CommonModel sharedModel].currentCommunityId;
            [BPush setTag:[communityId stringValue] withCompleteHandler:nil];
        }];
        
        [self addObserverForNotificationName:k_NOTIFY_NAME_USER_LOGIN usingBlock:^(NSNotification *notification) {
            NSNumber *usercommunityId = [UserModel sharedModel].currentNormalUser.communityId;
            if ([usercommunityId integerValue] != 0) {
                NSNumber *communityId = [CommonModel sharedModel].currentCommunityId;
                [BPush setTags:@[[communityId stringValue], [usercommunityId stringValue]] withCompleteHandler:nil];
            }
        }];
    }
    
    return self;
}

- (void)setupPushWithLaunchOptions:(NSDictionary *)launchOptions {
    // 设置百度推送
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"AX7iCmhNzycBFQDlhWAhePtW" pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    
    NSNumber *usercommunityId = [UserModel sharedModel].currentNormalUser.communityId;
    NSNumber *communityId = [CommonModel sharedModel].currentCommunityId;
    if (communityId || usercommunityId) {
        if ([usercommunityId integerValue] != 0) {
            [BPush setTags:@[[communityId stringValue], [usercommunityId stringValue]] withCompleteHandler:nil];
        }
        else {
            [BPush setTag:[communityId stringValue] withCompleteHandler:nil];
        }
    }
}

- (void)handlePushNotification:(NSDictionary *)pushNotiDic rootVC:(UIViewController *)vc {
    
    if (!pushNotiDic) {
        return;
    }
    
//    GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"收到推送" andMessage:@"asdf"];
//    [alert setCancelButtonWithTitle:@"OK" actionBlock:nil];
//    [alert show];
    
    NSNumber* ID = pushNotiDic[@"rel_id"];
    NSNumber* type = pushNotiDic[@"rel_type"];
    
    if ([type integerValue] == 1) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        //由storyboard根据myView的storyBoardID来获取我们要切换的视图]
        PropertyNotifyVC *noteVC = [story instantiateViewControllerWithIdentifier:@"CNoteInfoVC"];
        noteVC.noteId = ID;
        [noteVC refreshNote];
        
        

            UIViewController *result = nil;
            UIWindow * window = [[UIApplication sharedApplication] keyWindow];
            if (window.windowLevel != UIWindowLevelNormal)
            {
                NSArray *windows = [[UIApplication sharedApplication] windows];
                for(UIWindow * tmpWin in windows)
                {
                    if (tmpWin.windowLevel == UIWindowLevelNormal)
                    {
                        window = tmpWin;
                        break;
                    }
                }
            }
        if ([[window subviews] count] > 0) {
            UIView *frontView = [[window subviews] objectAtIndex:0];
            id nextResponder = [frontView nextResponder];
            
            if ([nextResponder isKindOfClass:[UIViewController class]])
                result = nextResponder;
            else
                result = window.rootViewController;
        }
        else {
            result = window.rootViewController;
        }
    
        if (result.navigationController) {
            [result.navigationController pushViewController:noteVC animated:YES];
        }
//        [result presentViewController:noteVC animated:NO completion:nil];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
