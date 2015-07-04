//
//  HTMLServerProxy.m
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "HTMLServerProxy.h"
#import <AFNetworking.h>
#import "GCExtension.h"
#import "APIGenerator.h"

@implementation HTMLServerProxy

+ (void)prepareRequestHeader:(AFHTTPRequestOperationManager *)manager {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:k_USERDEFAULTS_TOKEN];
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    
    NSString *admintoken = [[NSUserDefaults standardUserDefaults] objectForKey:k_USERDEFAULTS_ADMIN_TOKEN];
    [manager.requestSerializer setValue:admintoken forHTTPHeaderField:@"admintoken"];
}

+ (void)postWithUrl:(NSString*)urlStr parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式：
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式：
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [HTMLServerProxy prepareRequestHeader:manager];
    
    [manager POST:[APIGenerator apiAddressWithSuffix:urlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            GCBlockInvoke(success, jsonDic);
            return;
        }
        GCBlockInvoke(failed, [[NSError alloc] initWithDomain:@"数据错误" code:1000001 userInfo:nil]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GCBlockInvoke(failed, error);
    }];
    
}


+ (void)getWithUrl:(NSString*)urlStr success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置返回格式：
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [HTMLServerProxy prepareRequestHeader:manager];
    
    [manager GET:[APIGenerator apiAddressWithSuffix:urlStr] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            GCBlockInvoke(success, jsonDic);
            return;
        }
        GCBlockInvoke(failed, [[NSError alloc] initWithDomain:@"数据错误" code:1000001 userInfo:nil]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GCBlockInvoke(failed, error);
    }];
}

@end
