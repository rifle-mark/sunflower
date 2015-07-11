//
//  JasonServerProxy.h
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONServerProxy : NSObject

+ (void)postJSONWithUrl:(NSString*)urlStr parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed;

+ (void)postWithUrl:(NSString*)urlStr parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed;

+ (void)getWithUrl:(NSString*)urlStr params:(NSDictionary *)param success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed;
@end
