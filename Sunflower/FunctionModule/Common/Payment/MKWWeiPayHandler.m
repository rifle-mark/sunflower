//
//  MKWWeiPayHandler.m
//  Sunflower
//
//  Created by makewei on 15/6/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWWeiPayHandler.h"
#import "payRequsestHandler.h"
#import "APIGenerator.h"
#import "WXApi.h"

@implementation MKWWeiPayHandler


+ (void)registWeiXinPayment {
    [WXApi registerApp:APP_ID withDescription:@"向日葵社区"];
}

+ (void)payWithOrderNum:(NSString *)orderNum name:(NSString *)name price:(NSNumber *)price failed:(void(^)(NSString *msg))failed {
    payRequsestHandler *pay = [[payRequsestHandler alloc] init];
    if (![pay init:APP_ID mch_id:MCH_ID]) {
        GCBlockInvoke(failed, @"支付失败，请检查网络");
        return;
    }
    [pay setKey:PARTNER_ID];
    [pay setPayNotifyUrl:[APIGenerator urlAddWithoutHTTP:WXPayNOTIFY_URL]];
    NSString *totalFee = [NSString stringWithFormat:@"%ld", (long)((NSInteger)([price floatValue] * 100))];
    NSDictionary *payInfo = [pay sendPayWithOrderNum:orderNum name:name price:totalFee];
    if (!payInfo) {
        GCBlockInvoke(failed, @"支付失败，请检查网络");
        return;
    }
    
    NSMutableString *stamp  = [payInfo objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [payInfo objectForKey:@"appid"];
    req.partnerId           = [payInfo objectForKey:@"partnerid"];
    req.prepayId            = [payInfo objectForKey:@"prepayid"];
    req.nonceStr            = [payInfo objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [payInfo objectForKey:@"package"];
    req.sign                = [payInfo objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}
@end
