//
//  MKWWeiPayHandler.h
//  Sunflower
//
//  Created by makewei on 15/6/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>

// 账号帐户资料
//更改商户把相关参数后可测试

#define APP_ID          @"wx9d7542e3d90fd680"               //APPID
#define APP_SECRET      @"65794a56b94ac0ff176c609f4103068e" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1247211101"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"mcitechmcitechmcitechmcitech8888"
//支付结果回调页面
#define WXPayNOTIFY_URL      @"wxpay/notify.aspx"
//获取服务器端支付数据地址（商户自定义）
//#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

@interface MKWWeiPayHandler : NSObject

+ (void)registWeiXinPayment;

+ (void)payWithOrderNum:(NSString *)orderNum name:(NSString *)name price:(NSNumber *)price failed:(void(^)(NSString *msg))failed;
@end
