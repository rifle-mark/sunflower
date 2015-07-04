//
//  HTMLServerProxy.h
//  Sunflower
//
//  Created by makewei on 15/5/27.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLServerProxy : NSObject

+ (void)postWithUrl:(NSString*)urlStr parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed;

+ (void)getWithUrl:(NSString*)urlStr success:(void(^)(NSDictionary *responseJSON))success failed:(void(^)(NSError *error))failed;

@end
