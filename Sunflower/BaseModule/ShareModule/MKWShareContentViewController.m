//
//  IPSCommonShareViewController.m
//  IPSShareModule
//
//  Created by makewei on 14-6-9.
//  Copyright (c) 2014年 MCI. All rights reserved.
//

#import "MKWShareContentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIImage+Common.h>
#import "MKWColorHelper.h"

#define RGB(r, g, b)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define top_margin              20
#define screen_width            CGRectGetWidth([[UIScreen mainScreen] bounds])
#define screen_height           CGRectGetHeight([[UIScreen mainScreen] bounds])
#define is_pad                  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define is_current_landscape    UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

#define SHARE_CONTENT_WIDTH         (is_pad ? (627) : (is_current_landscape ? (screen_height) : (screen_width)))
#define SHARE_CONTENT_HEIGHT        (is_pad ? (316) : (is_current_landscape ? (screen_width) : (screen_height)))
#define SHARE_CONTENT_TOP_MARGIN    (is_pad ? (is_current_landscape ? (180) : (80)) : (0))
#define SHARE_CONTENT_CORNERRADIUS  (is_pad ? 8 : 0)
#define SHARE_TITLE_TOP_MARGIN      (is_pad ? 15 : 15 + top_margin)
#define SHARE_TITLELABEL_TOP_MARGIN (is_pad ? 15 : 20 + top_margin)
#define SHARE_TITLE_HOR_MARGIN      (is_pad ? 10 : 5)
#define SHARE_TITLE_WIDTH           (is_pad ? 80 : 80)
#define SHARE_TITLE_HEIGHT          (is_pad ? 30 : 20)
#define SHARE_SEND_BTN_WIDTH        (is_pad ? 80 : 60)
#define SHARE_CANCEL_BTN_WIDTH      (is_pad ? 80 : 60)
#define SHARE_SEND_BTN_HEIGHT       (is_pad ? 33 : 30)
#define SHARE_CANCEL_BTN_HEIGHT     (is_pad ? 33 : 30)
#define SHARE_TITLE_PAN_HEIGHT      (is_pad ? 55 : 45 + top_margin)
#define SHARE_TEXT_HOR_MARGIN       (is_pad ? 40 : 10)
#define SHARE_TEXT_TOP_MARGIN       (is_pad ? 5 : 5)
#define SHARE_TEXT_HEIGHT           (is_pad ? 200 : screen_height - SHARE_TITLE_PAN_HEIGHT - SHARE_TEXT_TOP_MARGIN - 1)
#define SHARE_ICO_TOP_MARGIN        (is_pad ? 4 : 1)
#define SHARE_ICO_HOR_MARGIN        (is_pad ? 10 : 5)
#define SHARE_ICO_WIDTH             (is_pad ? 44 : 44)
#define SHARE_ICO_HEIGHT            (is_pad ? 44 : 44)
#define kMaxImageWidth              (is_pad ? 200 : 100)
#define kMaxImageHeigth             (is_pad ? 200 : 100)
#define SHARE_FONT_SIZE             (is_pad ? 20 : 18)


@interface MKWShareContentViewController ()

@property (nonatomic, strong) UIView *shareContentView;

@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UIImageView* chooseImage;
//    MROrientation orientation;

@property (nonatomic, assign) CGFloat frameHeight;

@end

@implementation MKWShareContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shareContentView = [[UIView alloc] init];
    [self _setContentViewFrame];
    
    self.view.backgroundColor =  [UIColor clearColor];
    _shareContentView.backgroundColor =[ UIColor whiteColor];
    _shareContentView.layer.cornerRadius=SHARE_CONTENT_CORNERRADIUS;
    [self.view addSubview:_shareContentView];
    
    UIFont *font= [UIFont systemFontOfSize:SHARE_FONT_SIZE];
    UIColor *color=RGB(82.0f, 82.0f, 82.0f);
    CGFloat width = CGRectGetWidth(_shareContentView.frame);
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake((width-SHARE_TITLE_WIDTH)/2, SHARE_TITLELABEL_TOP_MARGIN, SHARE_TITLE_WIDTH, SHARE_TITLE_HEIGHT)];
    title.text=[NSString stringWithFormat:@"分享"];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.font=font;
    title.textColor=color;
    [title setBackgroundColor:[UIColor clearColor]];
    [_shareContentView addSubview:title];
    
    UIColor *btnColor = [MKWColorHelper ipsHTMLColorToColor:@"#2087fc"];
    _sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setBackgroundColor:[UIColor clearColor]];
    _sendBtn.frame=CGRectMake(width - SHARE_TITLE_HOR_MARGIN - SHARE_SEND_BTN_WIDTH, SHARE_TITLE_TOP_MARGIN, SHARE_SEND_BTN_WIDTH, SHARE_SEND_BTN_HEIGHT);
    [_sendBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[btnColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(shareSend) forControlEvents:UIControlEventTouchUpInside];
    [_shareContentView addSubview:_sendBtn];
    
    _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setBackgroundColor:[UIColor clearColor]];
    _cancelBtn.frame=CGRectMake(SHARE_TITLE_HOR_MARGIN, SHARE_TITLE_TOP_MARGIN, SHARE_CANCEL_BTN_WIDTH, SHARE_CANCEL_BTN_HEIGHT);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[btnColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(shareCancelled) forControlEvents:UIControlEventTouchUpInside];
    [_shareContentView addSubview:_cancelBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SHARE_TITLE_PAN_HEIGHT, _shareContentView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:0.5];
    [_shareContentView  addSubview:line];
    
    _messageTextView=[[UITextView alloc] initWithFrame:CGRectMake(SHARE_TEXT_HOR_MARGIN, SHARE_TITLE_PAN_HEIGHT + SHARE_TEXT_TOP_MARGIN, width - SHARE_TEXT_HOR_MARGIN * 2, SHARE_TEXT_HEIGHT)];
    [_messageTextView setBackgroundColor:[UIColor clearColor]];
    _messageTextView.delegate=(id)self;
    _messageTextView.font=font;
    _messageTextView.textColor=color;
    [_shareContentView  addSubview:_messageTextView];
    
    _chooseImage = [[UIImageView alloc] init];
    _chooseImage.hidden=YES;
    _chooseImage.backgroundColor=[UIColor clearColor];
    [_shareContentView addSubview:_chooseImage];
    
    [self canSendButtonEnable];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_messageTextView becomeFirstResponder];
}

-(void)setShareImage:(UIImage *)shareImage message:(NSString *)message
{
    _chooseImage.image = shareImage;
    _messageTextView.text = message;
    
    if(_chooseImage.image){
        _messageTextView.hidden = NO;
        _chooseImage.hidden = NO;
        CGSize imageSize = _chooseImage.image.size;
        float ws = imageSize.width/kMaxImageWidth;
        float hs = imageSize.height/kMaxImageHeigth;
        float maxs = ws>hs?ws:hs;
        CGSize newImageSize=imageSize;
        if(maxs>1)
        {
            newImageSize.width = imageSize.width/maxs;
            newImageSize.height = imageSize.height/maxs;
        }
        
        
        _chooseImage.frame =CGRectMake(_shareContentView.frame.size.width - newImageSize.width-10, SHARE_TITLE_PAN_HEIGHT+ 6 +(kMaxImageHeigth-newImageSize.height)/2,  newImageSize.width,  newImageSize.height );
        _messageTextView.frame =   CGRectMake(SHARE_TEXT_HOR_MARGIN, SHARE_TITLE_PAN_HEIGHT + SHARE_TEXT_TOP_MARGIN + 1, (_shareContentView.frame.size.width - SHARE_TEXT_HOR_MARGIN * 2 - newImageSize.width - 10), SHARE_TEXT_HEIGHT);
        
    }
    else{
        _messageTextView.hidden = NO;
        _chooseImage.hidden = YES;
        _messageTextView.frame =   CGRectMake(SHARE_TEXT_HOR_MARGIN, SHARE_TITLE_PAN_HEIGHT + SHARE_TEXT_TOP_MARGIN + 1, _shareContentView.frame.size.width- SHARE_TEXT_HOR_MARGIN * 2, SHARE_TEXT_HEIGHT);
    }
}

// sendButton 按钮是否可用
- (void)canSendButtonEnable
{
    return;
}


// 授权
- (void)_authorizedWithType:(ShareType)sharetype {
    if (![ShareSDK hasAuthorizedWithType:sharetype])//未登陆
    {
        NSLog(@"登录");
        __weak typeof(self) weakself = self;
        [ShareSDK authWithType:sharetype  options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
            if (state == SSAuthStateSuccess)
            {
                [weakself _sendShareContent];
            }
            else if (state == SSAuthStateFail)
            {
                [weakself dismiss];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权失败" message:error.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        }];
    }
}

- (BOOL)_plateNeedAuthWithType:(ShareType)shareType {
    //微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
    if (shareType == ShareTypeMail ||
        shareType == ShareTypeWeixiSession ||
        shareType == ShareTypeWeixiTimeline ||
        shareType == ShareTypeQQ ||
        shareType == ShareTypeQQSpace ||
        shareType == ShareTypeSMS ||
        shareType == ShareTypeAirPrint ||
        shareType == ShareTypeCopy) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)_authorizeSharePlatform {
    if ([self _plateNeedAuthWithType:_currentShareType]) {
        if (![ShareSDK hasAuthorizedWithType:_currentShareType]) {
            [self _authorizedWithType:_currentShareType];
        }
        else {
            [self _sendShareContent];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)_sendShareContent {
    __block ShareSendBlock shareBlock = self.shareBlock;
    [self dismissViewControllerAnimated:YES completion:^(void) {
    if ([ShareSDK hasAuthorizedWithType:_currentShareType] || (![self _plateNeedAuthWithType:_currentShareType])) {
        //已经授权过或者不需要授权

        //发送分享
        [ShareSDK shareContent:_publishContent
                          type:_currentShareType
                  authOptions :nil
                 statusBarTips:NO
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo,
                                 id<ICMErrorInfo>error,BOOL end){
                            
                            if (state == SSResponseStateSuccess) {
                                if (shareBlock) {
                                    shareBlock(YES);
                                }
                                
                                NSLog(@"分享成功");
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                            else if (state == SSResponseStateFail) {
                                if (shareBlock) {
                                    shareBlock(NO);
                                }
                                NSLog(@"分享失败:errorCode = %ld, errorDescription = %@", (long)[error errorCode], [error errorDescription]);
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                        }
         ];
    }
        }];
}
- (void)shareSend{
    //发送微博时，提示用户添加文字信息：
	if ([_messageTextView.text isEqualToString:@""] &&
        _currentShareType != ShareTypeWeixiSession &&
        _currentShareType != ShareTypeWeixiTimeline) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享" message:@"随便说点什么吧！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
		return;
	}
    
    [self _authorizeSharePlatform];
}

- (void)showInViewController:(UIViewController*)parentVC
{
    [self _setViewFrameToInterFaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
    
    [parentVC presentViewController:self animated:YES completion:nil];
}

-(void)shareCancelled{
    
    [self.messageTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismiss {
    [self shareCancelled];
}

- (void)_setContentViewFrame {
    CGFloat xMargin = ceil(CGRectGetMinX(self.view.frame) + (CGRectGetWidth(self.view.frame) - SHARE_CONTENT_WIDTH) / 2);
    CGFloat yMargin = ceil(CGRectGetMinY(self.view.frame) + (CGRectGetHeight(self.view.frame) - SHARE_CONTENT_HEIGHT) / 2) - SHARE_CONTENT_TOP_MARGIN;
    if (is_pad) {
        [_shareContentView setFrame:CGRectMake(xMargin, yMargin, SHARE_CONTENT_WIDTH, SHARE_CONTENT_HEIGHT)];
    }
    else {
        [_shareContentView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    }
}

#pragma mark - rotate methods

- (void)_setViewFrameToInterFaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    if (is_pad) {
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            [self.view setFrame:CGRectMake(0, is_pad ? -screen_width : 0, screen_height, screen_width)];
        }
        else {
            [self.view setFrame:CGRectMake(0, is_pad ? -screen_height : 0, screen_width, screen_height)];
        }
    }
    else {
        CGFloat frameY = 0.0;
        if ([[UIApplication sharedApplication] isStatusBarHidden]) {
            frameY = 0.0;
        }
        else {
            frameY = 0;
        }
        
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            [self.view setFrame:CGRectMake(0, frameY, screen_height, screen_width - (0))];
        }
        else {
            [self.view setFrame:CGRectMake(0, frameY, screen_width, screen_height - (0))];
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self _setViewFrameToInterFaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


@end

