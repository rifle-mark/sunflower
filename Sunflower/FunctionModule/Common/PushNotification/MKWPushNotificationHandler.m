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

- (void)setupPushWithLaunchOptions:(NSDictionary *)launchOptions pushMode:(BPushMode)pushMode isDebug:(BOOL)isDebug {
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
    [BPush registerChannel:launchOptions apiKey:@"AX7iCmhNzycBFQDlhWAhePtW" pushMode:pushMode withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:isDebug];
    
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
    
    NSNumber* ID = pushNotiDic[@"rel_id"];
    NSNumber* type = pushNotiDic[@"rel_type"];
    
    if ([type integerValue] == 1 && self.currentvc.navigationController) {
        UIStoryboard *story = self.currentvc.storyboard;
        PropertyNotifyVC *noteVC = [story instantiateViewControllerWithIdentifier:@"CNoteInfoVC"];
        noteVC.noteId = ID;
        [noteVC refreshNote];
        
        [self.currentvc.navigationController pushViewController:noteVC animated:YES];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
