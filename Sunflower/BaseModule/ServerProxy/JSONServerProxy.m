//
//  JasonServerProxy.m
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "JSONServerProxy.h"
#import <AFNetworking.h>
#import "GCExtension.h"
#import "APIGenerator.h"

@implementation JSONServerProxy

+ (void)prepareRequestHeader:(AFHTTPRequestOperationManager *)manager {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:k_USERDEFAULTS_TOKEN];
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    
    NSString *admintoken = [[NSUserDefaults standardUserDefaults] objectForKey:k_USERDEFAULTS_ADMIN_TOKEN];
    if (admintoken) {
        [manager.requestSerializer setValue:admintoken forHTTPHeaderField:@"admintoken"];
    }
}

+ (void)postJSONWithUrl:(NSString*)urlStr parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式：
//    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式：
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [JSONServerProxy prepareRequestHeader:manager];
    
    [manager POST:[APIGenerator apiAddressWithSuffix:urlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCBlockInvoke(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"网络异常" andMessage:@"请检查网络连接"];
        [alert setCancelButtonWithTitle:@"好的" actionBlock:nil];
        [alert show];
        GCBlockInvoke(failed, error);
    }];
    
}

+ (void)postWithUrl:(NSString*)urlStr parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式：
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式：
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [JSONServerProxy prepareRequestHeader:manager];
    
    [manager POST:[APIGenerator apiAddressWithSuffix:urlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            GCBlockInvoke(success, jsonDic);
            return;
        }
        GCBlockInvoke(failed, [[NSError alloc] initWithDomain:@"数据错误" code:1000001 userInfo:nil]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"网络异常" andMessage:@"请检查网络连接"];
        [alert setCancelButtonWithTitle:@"好的" actionBlock:nil];
        [alert show];
        GCBlockInvoke(failed, error);
    }];
}

+ (void)getWithUrl:(NSString*)urlStr params:(NSDictionary *)param success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置返回格式：
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [JSONServerProxy prepareRequestHeader:manager];
    [manager GET:[APIGenerator apiAddressWithSuffix:urlStr] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCBlockInvoke(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GCAlertView *alert = [[GCAlertView alloc] initWithTitle:@"网络异常" andMessage:@"请检查网络连接"];
        [alert setCancelButtonWithTitle:@"好的" actionBlock:nil];
        [alert show];
        GCBlockInvoke(failed, error);
    }];
}

@end
