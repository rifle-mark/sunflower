//
//  MKWAlipayHandler.h
//  Sunflower
//
//  Created by makewei on 15/6/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088911835508633"
//收款支付宝账号
#define SellerID  @"wangkr@isunflower.net.cn"

// 商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJflmQXVpCs0J1u09t6kb17hA2XuZN+d9Okc3VPejjwVqnDvok6bj2KfAMOTN+VW27Lkbc5LMuLBark0NakJ2Z6keRj4xqK3Q+KJVF0572Jte974ZBP4Pzu+uiU7mXfdvrrW25k+AO3OiN7HeDQ/+TdvHpgmriGvKpdgR6bv8XHfAgMBAAECgYA9+6Po3JgkRSD2bC79BU6pAdr4IkKpeXRyF6Q9UCjsXc7yTOcHerUVAls2c4GwpTP7mPkx4D/Ahjq9no9zDiDt2a1+2Fpmg86a3GM0fwaKZpFCd0P4sN5RF7mujUcp5Nluek9Rc58QaqEkVvyr1wiO0rgB9E5b4b2svQrvBPbzwQJBAMgmPwff7gPGwOy3ATeYPrMJN2yNa4+7YI6HUyD0p/La5dC1k2YB1t9xJ48C+zhAm5rXed74vdqQNmAZaPHfsL8CQQDCSGmFmX6auSx+8tWRwbd/3efSOzCPlKz2OC3ApRt24GR2WdT+zvLZIye+xVtNijO+YwtwMCWstW0uBHKV1WbhAkACoe4mTl21EwIqmuWbM5dvh2mBNgL6Kv7EISeIwW8MFLD9I8ZCizemTLi2etWPEdp6GOdzdVYZ79enP+5PcB/FAkEAhDWuyWG5DCVzKDisKXJAI12pAiGRXEP6p9t3Fx/EXtM4ymk7TuMZ07XeuC2pgkzIBYl1ITVCjhMwZx5Ts67zQQJBAKtiNyCXQNLDsB7RQ11impUrk3MPc8G3ZEyjN0jR96qJJ0p+RnAEMjadQnLOGh+zlk6h7tzZp4x5DxxmFjsn58s="

// 支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

// 回调url
#define AlipayNotifyURL @"api/alipay/notify.aspx"

@interface AliPayProduct : NSObject

@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *orderId;

@end

@interface MKWAlipayHandler : NSObject
+ (void)payOrderWithProduct:(AliPayProduct *)product;
@end
