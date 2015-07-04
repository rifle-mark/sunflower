//
//  IPSShareSelectViewController.m
//  IPSShareModule
//
//  Created by mark on 14-7-30.
//  Copyright (c) 2014年 MCI. All rights reserved.
//

#import "MKWShareSelectViewController.h"
#import "MKWShareContentViewController.h"
#import "MKWShareModule.h"
#import "MKWColorHelper.h"

#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIImage+Common.h>

#define k_IMAGE_SHARE_CANCEL_NORMAL         @"share_selection_cancel_normal.png"
#define k_IMAGE_SHARE_CANCEL_HIGHLIGHT      @"share_selection_cancel_highlight.png"
#define k_IMAGE_SHARE_SINAWEIBO_BTN_NORMAL      @"share_selection_sinaweibo_normal.png"
#define k_IMAGE_SHARE_SINAWEIBO_BTN_HIGHLIGHT   @"share_selection_sinaweibo_highlight.png"
#define k_IMAGE_SHARE_TECENTWEIBO_BTN_NORMAL    @"share_selection_tencentweibo_normal.png"
#define k_IMAGE_SHARE_TECENTWEIBO_BTN_HIGHLIGHT    @"share_selection_tencentweibo_highlight.png"
#define k_IMAGE_SHARE_SOHUWEIBO_BTN_NORMAL      @""
#define k_IMAGE_SHARE_SOHUWEIBO_BTN_HIGHLIGHT      @""
#define k_IMAGE_SHARE_163WEIBO_BTN_NORMAL       @""
#define k_IMAGE_SHARE_163WEIBO_BTN_HIGHLIGHT       @""
#define k_IMAGE_SHARE_DOUBAN_BTN_NORMAL         @""
#define k_IMAGE_SHARE_DOUBAN_BTN_HIGHLIGHT         @""
#define k_IMAGE_SHARE_QQSPACE_BTN_NORMAL        @"share_selection_qqspace_normal.png"
#define k_IMAGE_SHARE_QQSPACE_BTN_HIGHLIGHT        @"share_selection_qqspace_highlight.png"
#define k_IMAGE_SHARE_RENREN_BTN_NORMAL         @""
#define k_IMAGE_SHARE_RENREN_BTN_HIGHLIGHT         @""
#define k_IMAGE_SHARE_KAIXIN_BTN_NORMAL         @""
#define k_IMAGE_SHARE_KAIXIN_BTN_HIGHLIGHT         @""
#define k_IMAGE_SHARE_PENGYOU_BTN_NORMAL        @""
#define k_IMAGE_SHARE_PENGYOU_BTN_HIGHLIGHT        @""
#define k_IMAGE_SHARE_FACEBOOK_BTN_NORMAL       @""
#define k_IMAGE_SHARE_FACEBOOK_BTN_HIGHLIGHT       @""
#define k_IMAGE_SHARE_TWITTER_BTN_NORMAL        @""
#define k_IMAGE_SHARE_TWITTER_BTN_HIGHLIGHT        @""
#define k_IMAGE_SHARE_EVERNOTE_BTN_NORMAL       @""
#define k_IMAGE_SHARE_EVERNOTE_BTN_HIGHLIGHT       @""
#define k_IMAGE_SHARE_FOURSQUARE_BTN_NORMAL     @""
#define k_IMAGE_SHARE_FOURSQUARE_BTN_HIGHLIGHT     @""
#define k_IMAGE_SHARE_INSTAGRM_BTN_NORMAL       @""
#define k_IMAGE_SHARE_INSTAGRM_BTN_HIGHLIGHT       @""
#define k_IMAGE_SHARE_LINKEDIN_BTN_NORMAL       @""
#define k_IMAGE_SHARE_LINKEDIN_BTN_HIGHLIGHT       @""
#define k_IMAGE_SHARE_TUMBLR_BTN_NORMAL         @""
#define k_IMAGE_SHARE_TUMBLR_BTN_HIGHLIGHT         @""
#define k_IMAGE_SHARE_MAIL_BTN_NORMAL           @"share_selection_mail_normal.png"
#define k_IMAGE_SHARE_MAIL_BTN_HIGHLIGHT           @"share_selection_mail_highlight.png"
#define k_IMAGE_SHARE_SMS_BTN_NORMAL            @""
#define k_IMAGE_SHARE_SMS_BTN_HIGHLIGHT            @""
#define k_IMAGE_SHARE_AIRPRINT_BTN_NORMAL       @""
#define k_IMAGE_SHARE_AIRPRINT_BTN_HIGHLIGHT       @""
#define k_IMAGE_SHARE_COPY_BTN_NORMAL           @"share_selection_copy_normal.png"
#define k_IMAGE_SHARE_COPY_BTN_HIGHLIGHT           @"share_selection_copy_highlight.png"
#define k_IMAGE_SHARE_WEIXINSESSION_BTN_NORMAL  @"share_selection_weixinsession_normal.png"
#define k_IMAGE_SHARE_WEIXINSESSION_BTN_HIGHLIGHT  @"share_selection_weixinsession_highlight.png"
#define k_IMAGE_SHARE_WEIXINTIMELINE_BTN_NORMAL @"share_selectiong_weixintimeline_normal.png"
#define k_IMAGE_SHARE_WEIXINTIMELINE_BTN_HIGHLIGHT @"share_selection_weixintimeline_highlight.png"
#define k_IMAGE_SHARE_QQ_BTN_NORMAL             @"share_selection_qq_normal.png"
#define k_IMAGE_SHARE_QQ_BTN_HIGHLIGHT             @"share_selection_qq_highlight.png"
#define k_IMAGE_SHARE_INSTAPAPER_BTN_NORMAL     @""
#define k_IMAGE_SHARE_INSTAPAPER_BTN_HIGHLIGHT     @""
#define k_IMAGE_SHARE_POCKET_BTN_NORMAL         @""
#define k_IMAGE_SHARE_POCKET_BTN_HIGHLIGHT         @""
#define k_IMAGE_SHARE_YOUDAO_BTN_NORMAL         @""
#define k_IMAGE_SHARE_YOUDAO_BTN_HIGHLIGHT         @""
#define k_IMAGE_SHARE_SOHUKAN_BTN_NORMAL        @""
#define k_IMAGE_SHARE_SOHUKAN_BTN_HIGHLIGHT        @""
#define k_IMAGE_SHARE_PINTEREST_BTN_NORMAL      @""
#define k_IMAGE_SHARE_PINTEREST_BTN_HIGHLIGHT      @""
#define k_IMAGE_SHARE_FLICKR_BTN_NORMAL         @""
#define k_IMAGE_SHARE_FLICKR_BTN_HIGHLIGHT         @""
#define k_IMAGE_SHARE_DROPBOX_BTN_NORMAL        @""
#define k_IMAGE_SHARE_DROPBOX_BTN_HIGHLIGHT        @""
#define k_IMAGE_SHARE_VKONTAKTE_BTN_NORMAL      @""
#define k_IMAGE_SHARE_VKONTAKTE_BTN_HIGHLIGHT      @""
#define k_IMAGE_SHARE_WEIXINFAV_BTN_NORMAL      @""
#define k_IMAGE_SHARE_WEIXINFAV_BTN_HIGHLIGHT      @""
#define k_IMAGE_SHARE_YIXINSESSION_BTN_NORMAL   @""
#define k_IMAGE_SHARE_YIXINSESSION_BTN_HIGHLIGHT   @""
#define k_IMAGE_SHARE_YIXINTIMELINE_BTN_NORMAL  @""
#define k_IMAGE_SHARE_YIXINTIMELINE_BTN_HIGHLIGHT  @""
#define k_IMAGE_SHARE_YIXINFAV_BTN_NORMAL       @""
#define k_IMAGE_SHARE_YIXINFAV_BTN_HIGHLIGHT       @""

#define k_SHARE_SELECTION_COLUMN    4
#define k_SHARE_SELECTION_MAX_ROW   3
#define k_SHARE_SELECTION_TITLE_HEIGHT  80.0 / 2
#define k_SHARE_SELECTION_PAGE_HEIGHT   10.0 / 2
#define k_SHARE_SELECTION_CANCLE_HEIGHT 84.0 / 2
#define k_SHARE_SELECTION_BTN_WIDTH     150.0 / 2
#define k_SHARE_SELECTION_BTN_HEIGHT    180.0 / 2
#define k_SHARE_BTN_TAG_BEGIN   15000

@interface MKWShareSelectViewController ()

@property (nonatomic, weak) UIViewController * ownerVC;
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) NSMutableArray * shareTypes;

@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation MKWShareSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shareTypes = [[NSMutableArray alloc] init];
        [_shareTypes addObjectsFromArray:[MKWShareModule platforms]];
        if (_shareTypes.count<=0) {
            //书架没有设定，默认
            [_shareTypes addObject:[NSNumber numberWithInt:ShareTypeSinaWeibo]];
            [_shareTypes addObject:[NSNumber numberWithInt:ShareTypeMail]];
        }
        
        NSInteger tmpRowCount = [_shareTypes count] / k_SHARE_SELECTION_COLUMN;
        BOOL isDivide = [_shareTypes count] % k_SHARE_SELECTION_COLUMN == 0;
        _rowCount = tmpRowCount >= 3 ? 3 : (isDivide ? tmpRowCount : tmpRowCount + 1);
        
        NSInteger tmpPageCount = _rowCount / k_SHARE_SELECTION_MAX_ROW;
        isDivide = _rowCount % k_SHARE_SELECTION_MAX_ROW == 0;
        _pageCount = isDivide ? tmpPageCount : tmpPageCount + 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[MKWColorHelper colorWithHexRGBAString:@"99999900"]];

    CGFloat contentHeight = _rowCount * k_SHARE_SELECTION_BTN_HEIGHT;
    CGFloat containerHeight = contentHeight + k_SHARE_SELECTION_TITLE_HEIGHT + (_pageCount > 1 ? k_SHARE_SELECTION_PAGE_HEIGHT : 0);
    
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - containerHeight)];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [cancelBtn addTarget:self action:@selector(cancelBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), containerHeight)];
    [_containerView setBackgroundColor:[MKWColorHelper colorWithHexRGBAString:@"F5F5F5FF"]];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), k_SHARE_SELECTION_TITLE_HEIGHT)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"分享到"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setTextColor:[MKWColorHelper colorWithHexRGBAString:@"555555FF"]];
    [_containerView addSubview:titleLabel];
    
    [self.view addSubview:_containerView];
    
    UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc] init];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipe.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:rightSwipe];
    
    //  拦截左边栏滑出
    UIGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] init];
    [pan requireGestureRecognizerToFail:rightSwipe];
    [self.view addGestureRecognizer:pan];
    
    [self _loadShareSelectionItems:contentHeight];
}

- (void)_loadShareSelectionItems:(CGFloat)contentHeight {
    if (_pageCount > 1) {
        
    }
    else
    {
        UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, k_SHARE_SELECTION_TITLE_HEIGHT, CGRectGetWidth(self.view.frame), contentHeight)];
        [contentView setBackgroundColor:[UIColor clearColor]];
        CGFloat btnMargin = ceil((CGRectGetWidth(self.view.frame) - k_SHARE_SELECTION_COLUMN * k_SHARE_SELECTION_BTN_WIDTH) / (k_SHARE_SELECTION_COLUMN + 1));
        int idx = 0;
        int rowidx = 0;
        for (rowidx = 0; rowidx < _rowCount; rowidx++) {
            for (int i = 0; i < k_SHARE_SELECTION_COLUMN; i++) {
                idx = rowidx * k_SHARE_SELECTION_COLUMN + i;
                if (idx >= [_shareTypes count]) {
                    break;
                }
                UIButton * shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnMargin * (i + 1) + k_SHARE_SELECTION_BTN_WIDTH * i, k_SHARE_SELECTION_TITLE_HEIGHT + rowidx * k_SHARE_SELECTION_BTN_HEIGHT, k_SHARE_SELECTION_BTN_WIDTH, k_SHARE_SELECTION_BTN_HEIGHT)];
                [shareBtn setBackgroundColor:[UIColor clearColor]];
                [shareBtn setBackgroundImage:[self _getShareBtnImageNormal:_shareTypes[idx]] forState:UIControlStateNormal];
                [shareBtn setBackgroundImage:[self _getShareBtnImageHighlight:_shareTypes[idx]] forState:UIControlStateHighlighted];
                [shareBtn setTag:k_SHARE_BTN_TAG_BEGIN + [_shareTypes[idx] integerValue]];
                [shareBtn addTarget:self action:@selector(shareBtnTap:) forControlEvents:UIControlEventTouchUpInside];
                [_containerView addSubview:shareBtn];
            }
        }
        
    }
}

- (void)showInViewController:(UIViewController*)parentVC {

    [self showInViewController:parentVC transform:CGAffineTransformIdentity];
}

- (void)showInViewController:(UIViewController*)parentVC transform:(CGAffineTransform)transform {
    _ownerVC = parentVC;
    CGRect selfRect = CGRectMake(0, 0, CGRectGetWidth(parentVC.view.frame), CGRectGetHeight(parentVC.view.frame));
    [self.view setFrame:selfRect];
    
    [self.view setTransform:transform];
    
    [parentVC addChildViewController:self];
    [parentVC.view addSubview:self.view];
    __weak MKWShareSelectViewController * blockSelf = self;
    [UIView animateWithDuration:0.3 animations:^(void){
        CGRect containerFrame = CGRectMake(0, CGRectGetHeight(blockSelf.view.frame) - CGRectGetHeight(blockSelf.containerView.frame), CGRectGetWidth(blockSelf.containerView.frame), CGRectGetHeight(blockSelf.containerView.frame));
        [blockSelf.containerView setFrame:containerFrame];
        [blockSelf.view setBackgroundColor:[MKWColorHelper colorWithHexRGBAString:@"0000007F"]];
    }];
}

- (BOOL)_needAuthWithType:(ShareType)shareType {
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

- (void)_authorizedWithType:(ShareType)sharetype {
    
    if (![self _needAuthWithType:sharetype] || [ShareSDK hasAuthorizedWithType:sharetype]) {
        [self _sendShareWithType:sharetype];
    }
    else if (![ShareSDK hasAuthorizedWithType:sharetype])//未登陆
    {
        NSLog(@"登录");
        __weak typeof(self) weakself = self;
        [ShareSDK authWithType:sharetype  options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
            if (state == SSAuthStateSuccess)
            {
                [weakself _sendShareWithType:sharetype];
            }
            else if (state == SSAuthStateFail)
            {
                [weakself dismissWithCompleteBlock:nil];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权失败" message:error.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        }];
    }
}

- (void)shareBtnTap:(id)sender {
    NSInteger btnTag = [sender tag];
    ShareType sType = (ShareType)(btnTag - k_SHARE_BTN_TAG_BEGIN);
    if (sType == ShareTypeSinaWeibo ||
        sType == ShareTypeTencentWeibo) {
        [self _authorizedWithType:sType];
    }
    else if (sType == ShareTypeWeixiSession ||
             sType == ShareTypeWeixiTimeline ||
             sType == ShareTypeQQ ||
             sType == ShareTypeQQSpace ||
             sType == ShareTypeCopy ||
             sType == ShareTypeMail){
        [self _sendShareWithType:sType];
    }

}

- (void)_sendShareWithType:(ShareType)shareType {
    if (_selectBlock) {
        __block NSDictionary * shareInfoDic = _selectBlock(shareType);
        if (!shareInfoDic) {
            [self dismissWithCompleteBlock:nil];
            return;
        }
        __weak MKWShareSelectViewController * weakSelf = self;
        __block ShareType ourShareType = shareType;
        
        [self dismissWithCompleteBlock:^(UIViewController* parentVC){
            switch (ourShareType) {
                case ShareTypeSinaWeibo:
                case ShareTypeTencentWeibo:
                {
                    // show share content edit view
                    id<ISSContent> publishContent = [weakSelf _createShareContentWithType:ourShareType info:shareInfoDic];
                    MKWShareContentViewController * shareContentVC = [[MKWShareContentViewController alloc] init];
                    shareContentVC.shareBlock = weakSelf.sendBlock;
                    shareContentVC.publishContent = publishContent;
                    shareContentVC.currentShareType = ourShareType;
                    [shareContentVC showInViewController:parentVC];
                    [shareContentVC setShareImage:shareInfoDic[k_SHAREINFO_KEY_IMAGE] message:shareInfoDic[k_SHAREINFO_KEY_CONTENT]];
                }
                    break;
                case ShareTypeWeixiSession:
                case ShareTypeWeixiTimeline:
                case ShareTypeQQ:
                case ShareTypeQQSpace:
                case ShareTypeCopy:
                case ShareTypeMail:
                {
                    id<ISSContent> publishContent = [weakSelf _createShareContentWithType:ourShareType info:shareInfoDic];
                    [weakSelf _sendShareContent:publishContent type:ourShareType];
                }
                    break;
                default:
                    break;
            }
        }];
    }
    else {
        [self dismissWithCompleteBlock:nil];
    }
}

- (void)_sendShareContent:(id<ISSContent>)publishContent type:(ShareType)ourShareType {
    [ShareSDK shareContent:publishContent
                      type:ourShareType
              authOptions :nil
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo,
                             id<ICMErrorInfo>error,BOOL end){
                        
                        if (state == SSResponseStateSuccess) {
                            if (self.sendBlock) {
                                self.sendBlock(YES);
                                self.sendBlock = nil;
                            }
                            
                            NSString *resultStr = @"分享成功";
                            if (type == ShareTypeCopy) {
                                resultStr = @"已复制到剪贴板";
                            }

                            NSLog(@"分享成功");
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:resultStr message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else if (state == SSResponseStateFail) {
                            if (self.sendBlock) {
                                self.sendBlock(NO);
                                self.sendBlock = nil;
                            }
                            
                            NSString *resultStr = @"分享失败";
                            if (type == ShareTypeCopy) {
                                resultStr = @"复制链接失败";
                            }
                            
                            NSLog(@"分享失败:errorCode = %ld, errorDescription = %@", (long)[error errorCode], [error errorDescription]);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:resultStr message:[error errorDescription] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }];

}

- (id<ISSContent>)_createShareContentWithType:(ShareType)ourShareType
                                         info:(NSDictionary *)infoDic {
    UIImage * shareImage = infoDic[k_SHAREINFO_KEY_IMAGE];
    id<ISSCAttachment> sharedImage = nil;
    id<ISSCAttachment> thumbImage = nil;
    if(shareImage)
    {
        sharedImage = [ShareSDK pngImageWithImage:shareImage];
        thumbImage = [ShareSDK pngImageWithImage:[shareImage scaleImageWithSize:CGSizeMake(240, 240)]];
    }
    id<ISSContent> retVal = [ShareSDK content:infoDic[k_SHAREINFO_KEY_CONTENT]
       defaultContent:nil
                image:sharedImage
                title:infoDic[k_SHAREINFO_KEY_TITLE]
                  url:infoDic[k_SHAREINFO_KEY_URL]          //必须填写
          description:infoDic[k_SHAREINFO_KEY_DESCRIPTION]
            mediaType:(SSPublishContentMediaType)[infoDic[k_SHAREINFO_KEY_MEDIATYPE] integerValue]];
    switch (ourShareType) {
        case ShareTypeMail:
            [retVal addMailUnitWithSubject:infoDic[k_SHAREINFO_KEY_TITLE]
                                   content:INHERIT_VALUE
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
            break;
        case ShareTypeWeixiSession:
            [retVal addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:thumbImage
                                           image:INHERIT_VALUE
                                    musicFileUrl:INHERIT_VALUE
                                         extInfo:INHERIT_VALUE
                                        fileData:INHERIT_VALUE
                                    emoticonData:INHERIT_VALUE];
            break;
        case ShareTypeWeixiTimeline:
            [retVal addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:INHERIT_VALUE
                                            title:INHERIT_VALUE
                                              url:INHERIT_VALUE
                                       thumbImage:thumbImage
                                            image:INHERIT_VALUE
                                     musicFileUrl:INHERIT_VALUE
                                          extInfo:INHERIT_VALUE
                                         fileData:INHERIT_VALUE
                                     emoticonData:INHERIT_VALUE];
            break;
        default:
            break;
    }
    
    return retVal;
}

- (void)cancelBtnTap:(id)sender {
    [self dismissWithCompleteBlock:nil];
}

- (void)dismissWithCompleteBlock:(void (^)(UIViewController*)) complete {
    __weak MKWShareSelectViewController * blockSelf = self;
    [UIView animateWithDuration:0.5 animations:^(void){
        CGRect containerFrame = CGRectMake(0, CGRectGetHeight(blockSelf.view.frame), CGRectGetWidth(blockSelf.containerView.frame), CGRectGetHeight(blockSelf.containerView.frame));
        [blockSelf.containerView setFrame:containerFrame];
        [blockSelf.view setBackgroundColor:[MKWColorHelper colorWithHexRGBAString:@"99999900"]];
    } completion:^(BOOL finished){
        if (finished) {
            UIViewController * parentVC = blockSelf.ownerVC;
            [blockSelf.view removeFromSuperview];
            [blockSelf removeFromParentViewController];
            if (complete) {
                complete(parentVC);
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*)_getShareBtnImageHighlight:(NSNumber*)shareType {
    switch ([shareType integerValue]) {
        case ShareTypeSinaWeibo:
            return [UIImage imageNamed:k_IMAGE_SHARE_SINAWEIBO_BTN_HIGHLIGHT];
            break;
        case ShareTypeTencentWeibo:
            return [UIImage imageNamed:k_IMAGE_SHARE_TECENTWEIBO_BTN_HIGHLIGHT];
            break;
        case ShareTypeDouBan:
            return [UIImage imageNamed:k_IMAGE_SHARE_DOUBAN_BTN_HIGHLIGHT];
            break;
        case ShareTypeQQSpace:
            return [UIImage imageNamed:k_IMAGE_SHARE_QQSPACE_BTN_HIGHLIGHT];
            break;
        case ShareTypeRenren:
            return [UIImage imageNamed:k_IMAGE_SHARE_RENREN_BTN_HIGHLIGHT];
            break;
        case ShareTypeKaixin:
            return [UIImage imageNamed:k_IMAGE_SHARE_KAIXIN_BTN_HIGHLIGHT];
            break;
        case ShareTypePengyou:
            return [UIImage imageNamed:k_IMAGE_SHARE_PENGYOU_BTN_HIGHLIGHT];
            break;
        case ShareTypeFacebook:
            return [UIImage imageNamed:k_IMAGE_SHARE_FACEBOOK_BTN_HIGHLIGHT];
            break;
        case ShareTypeTwitter:
            return [UIImage imageNamed:k_IMAGE_SHARE_TWITTER_BTN_HIGHLIGHT];
            break;
        case ShareTypeEvernote:
            return [UIImage imageNamed:k_IMAGE_SHARE_EVERNOTE_BTN_HIGHLIGHT];
            break;
        case ShareTypeFoursquare:
            return [UIImage imageNamed:k_IMAGE_SHARE_FOURSQUARE_BTN_HIGHLIGHT];
            break;
        case ShareTypeInstagram:
            return [UIImage imageNamed:k_IMAGE_SHARE_INSTAGRM_BTN_HIGHLIGHT];
            break;
        case ShareTypeLinkedIn:
            return [UIImage imageNamed:k_IMAGE_SHARE_LINKEDIN_BTN_HIGHLIGHT];
            break;
        case ShareTypeTumblr:
            return [UIImage imageNamed:k_IMAGE_SHARE_TUMBLR_BTN_HIGHLIGHT];
            break;
        case ShareTypeMail:
            return [UIImage imageNamed:k_IMAGE_SHARE_MAIL_BTN_HIGHLIGHT];
            break;
        case ShareTypeSMS:
            return [UIImage imageNamed:k_IMAGE_SHARE_SMS_BTN_HIGHLIGHT];
            break;
        case ShareTypeAirPrint:
            return [UIImage imageNamed:k_IMAGE_SHARE_AIRPRINT_BTN_HIGHLIGHT];
            break;
        case ShareTypeCopy:
            return [UIImage imageNamed:k_IMAGE_SHARE_COPY_BTN_HIGHLIGHT];
            break;
        case ShareTypeWeixiSession:
            return [UIImage imageNamed:k_IMAGE_SHARE_WEIXINSESSION_BTN_HIGHLIGHT];
            break;
        case ShareTypeWeixiTimeline:
            return [UIImage imageNamed:k_IMAGE_SHARE_WEIXINTIMELINE_BTN_HIGHLIGHT];
            break;
        case ShareTypeQQ:
            return [UIImage imageNamed:k_IMAGE_SHARE_QQ_BTN_HIGHLIGHT];
            break;
        case ShareTypeInstapaper:
            return [UIImage imageNamed:k_IMAGE_SHARE_INSTAPAPER_BTN_HIGHLIGHT];
            break;
        case ShareTypePocket:
            return [UIImage imageNamed:k_IMAGE_SHARE_POCKET_BTN_HIGHLIGHT];
            break;
        case ShareTypeYouDaoNote:
            return [UIImage imageNamed:k_IMAGE_SHARE_YOUDAO_BTN_HIGHLIGHT];
            break;
        case ShareTypeSohuKan:
            return [UIImage imageNamed:k_IMAGE_SHARE_SOHUKAN_BTN_HIGHLIGHT];
            break;
        case ShareTypePinterest:
            return [UIImage imageNamed:k_IMAGE_SHARE_PINTEREST_BTN_HIGHLIGHT];
            break;
        case ShareTypeFlickr:
            return [UIImage imageNamed:k_IMAGE_SHARE_FLICKR_BTN_HIGHLIGHT];
            break;
        case ShareTypeDropbox:
            return [UIImage imageNamed:k_IMAGE_SHARE_DROPBOX_BTN_HIGHLIGHT];
            break;
        case ShareTypeVKontakte:
            return [UIImage imageNamed:k_IMAGE_SHARE_VKONTAKTE_BTN_HIGHLIGHT];
            break;
        case ShareTypeWeixiFav:
            return [UIImage imageNamed:k_IMAGE_SHARE_WEIXINFAV_BTN_HIGHLIGHT];
            break;
        case ShareTypeYiXinSession:
            return [UIImage imageNamed:k_IMAGE_SHARE_YIXINSESSION_BTN_HIGHLIGHT];
            break;
        case ShareTypeYiXinTimeline:
            return [UIImage imageNamed:k_IMAGE_SHARE_YIXINTIMELINE_BTN_HIGHLIGHT];
            break;
        case ShareTypeYiXinFav:
            return [UIImage imageNamed:k_IMAGE_SHARE_YIXINFAV_BTN_HIGHLIGHT];
            break;
        default:
            return nil;
            break;
    }
    return nil;

}

- (UIImage*)_getShareBtnImageNormal:(NSNumber*)shareType {
    switch ([shareType integerValue]) {
        case ShareTypeSinaWeibo:
            return [UIImage imageNamed:k_IMAGE_SHARE_SINAWEIBO_BTN_NORMAL];
            break;
        case ShareTypeTencentWeibo:
            return [UIImage imageNamed:k_IMAGE_SHARE_TECENTWEIBO_BTN_NORMAL];
            break;
        case ShareTypeDouBan:
            return [UIImage imageNamed:k_IMAGE_SHARE_DOUBAN_BTN_NORMAL];
            break;
        case ShareTypeQQSpace:
            return [UIImage imageNamed:k_IMAGE_SHARE_QQSPACE_BTN_NORMAL];
            break;
        case ShareTypeRenren:
            return [UIImage imageNamed:k_IMAGE_SHARE_RENREN_BTN_NORMAL];
            break;
        case ShareTypeKaixin:
            return [UIImage imageNamed:k_IMAGE_SHARE_KAIXIN_BTN_NORMAL];
            break;
        case ShareTypePengyou:
            return [UIImage imageNamed:k_IMAGE_SHARE_PENGYOU_BTN_NORMAL];
            break;
        case ShareTypeFacebook:
            return [UIImage imageNamed:k_IMAGE_SHARE_FACEBOOK_BTN_NORMAL];
            break;
        case ShareTypeTwitter:
            return [UIImage imageNamed:k_IMAGE_SHARE_TWITTER_BTN_NORMAL];
            break;
        case ShareTypeEvernote:
            return [UIImage imageNamed:k_IMAGE_SHARE_EVERNOTE_BTN_NORMAL];
            break;
        case ShareTypeFoursquare:
            return [UIImage imageNamed:k_IMAGE_SHARE_FOURSQUARE_BTN_NORMAL];
            break;
        case ShareTypeInstagram:
            return [UIImage imageNamed:k_IMAGE_SHARE_INSTAGRM_BTN_NORMAL];
            break;
        case ShareTypeLinkedIn:
            return [UIImage imageNamed:k_IMAGE_SHARE_LINKEDIN_BTN_NORMAL];
            break;
        case ShareTypeTumblr:
            return [UIImage imageNamed:k_IMAGE_SHARE_TUMBLR_BTN_NORMAL];
            break;
        case ShareTypeMail:
            return [UIImage imageNamed:k_IMAGE_SHARE_MAIL_BTN_NORMAL];
            break;
        case ShareTypeSMS:
            return [UIImage imageNamed:k_IMAGE_SHARE_SMS_BTN_NORMAL];
            break;
        case ShareTypeAirPrint:
            return [UIImage imageNamed:k_IMAGE_SHARE_AIRPRINT_BTN_NORMAL];
            break;
        case ShareTypeCopy:
            return [UIImage imageNamed:k_IMAGE_SHARE_COPY_BTN_NORMAL];
            break;
        case ShareTypeWeixiSession:
            return [UIImage imageNamed:k_IMAGE_SHARE_WEIXINSESSION_BTN_NORMAL];
            break;
        case ShareTypeWeixiTimeline:
            return [UIImage imageNamed:k_IMAGE_SHARE_WEIXINTIMELINE_BTN_NORMAL];
            break;
        case ShareTypeQQ:
            return [UIImage imageNamed:k_IMAGE_SHARE_QQ_BTN_NORMAL];
            break;
        case ShareTypeInstapaper:
            return [UIImage imageNamed:k_IMAGE_SHARE_INSTAPAPER_BTN_NORMAL];
            break;
        case ShareTypePocket:
            return [UIImage imageNamed:k_IMAGE_SHARE_POCKET_BTN_NORMAL];
            break;
        case ShareTypeYouDaoNote:
            return [UIImage imageNamed:k_IMAGE_SHARE_YOUDAO_BTN_NORMAL];
            break;
        case ShareTypeSohuKan:
            return [UIImage imageNamed:k_IMAGE_SHARE_SOHUKAN_BTN_NORMAL];
            break;
        case ShareTypePinterest:
            return [UIImage imageNamed:k_IMAGE_SHARE_PINTEREST_BTN_NORMAL];
            break;
        case ShareTypeFlickr:
            return [UIImage imageNamed:k_IMAGE_SHARE_FLICKR_BTN_NORMAL];
            break;
        case ShareTypeDropbox:
            return [UIImage imageNamed:k_IMAGE_SHARE_DROPBOX_BTN_NORMAL];
            break;
        case ShareTypeVKontakte:
            return [UIImage imageNamed:k_IMAGE_SHARE_VKONTAKTE_BTN_NORMAL];
            break;
        case ShareTypeWeixiFav:
            return [UIImage imageNamed:k_IMAGE_SHARE_WEIXINFAV_BTN_NORMAL];
            break;
        case ShareTypeYiXinSession:
            return [UIImage imageNamed:k_IMAGE_SHARE_YIXINSESSION_BTN_NORMAL];
            break;
        case ShareTypeYiXinTimeline:
            return [UIImage imageNamed:k_IMAGE_SHARE_YIXINTIMELINE_BTN_NORMAL];
            break;
        case ShareTypeYiXinFav:
            return [UIImage imageNamed:k_IMAGE_SHARE_YIXINFAV_BTN_NORMAL];
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

@end
