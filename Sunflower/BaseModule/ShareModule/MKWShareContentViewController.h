//
//  IPSShareContentViewController.h
//  IPSShareModule
//
//  Created by mark on 14-7-30.
//  Copyright (c) 2014年 MCI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKWShareSelectViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface MKWShareContentViewController : UIViewController

@property (nonatomic, strong) ShareSendBlock shareBlock;
@property (nonatomic, strong) id<ISSContent> publishContent;
@property (nonatomic, assign) ShareType currentShareType;

- (void)showInViewController:(UIViewController*)parentVC;
-(void)setShareImage:(UIImage *)shareImage message:(NSString *)message;
@end
