//
//  MKWAlipayHandler.m
//  Sunflower
//
//  Created by makewei on 15/6/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWAlipayHandler.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "APIGenerator.h"

@implementation AliPayProduct


@end

@implementation MKWAlipayHandler


#pragma mark 生成订单

+(NSString*)getOrderWithProduct:(AliPayProduct *)product
{
    /*
     *获取prodcut实例并初始化订单信息
     */
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = product.orderId;
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL = [APIGenerator urlAddWithoutHTTP:AlipayNotifyURL] ; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    return [order description];
}

+ (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand((unsigned)time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

+ (NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

+ (void)payOrderWithProduct:(AliPayProduct *)product{
    
    /*
     *生成订单信息及签名
     *目前采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
     */
    
    NSString *appScheme = @"alsunflower2088911835508633";
    NSString* orderInfo = [MKWAlipayHandler getOrderWithProduct:product];
    NSString* signedStr = [MKWAlipayHandler doRsa:orderInfo];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_SUCCESS object:nil userInfo:nil];
            
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTIFY_NAME_PROPERTY_CHARGE_FAILED object:nil userInfo:nil];
        }
    }];
    
    
}

@end
