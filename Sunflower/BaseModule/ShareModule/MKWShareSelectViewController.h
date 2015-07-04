//
//  IPSShareSelectViewController.h
//  IPSShareModule
//
//  Created by mark on 14-7-30.
//  Copyright (c) 2014年 MCI. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_SHAREINFO_KEY_MEDIATYPE           @"mediaType"
#define k_SHAREINFO_KEY_TITLE               @"title"
#define k_SHAREINFO_KEY_IMAGE               @"image"
#define k_SHAREINFO_KEY_CONTENT             @"content"
#define k_SHAREINFO_KEY_DESCRIPTION         @"discription"
#define k_SHAREINFO_KEY_URL                 @"url"

typedef NSDictionary*(^SharePlatformSelectBlock)(NSInteger shareType);
typedef void (^ShareSendBlock)(BOOL isSuccess);

@interface MKWShareSelectViewController : UIViewController

@property (nonatomic, copy) SharePlatformSelectBlock selectBlock;
@property (nonatomic, copy) ShareSendBlock sendBlock;

- (void)showInViewController:(UIViewController*)parentVC;

@end
