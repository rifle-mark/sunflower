//
//  WeiCommentAction.h
//  Sunflower
//
//  Created by makewei on 15/6/7.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


#define k_ENTITY_WEICOMMENTACTION   @"WeiCommentAction"

@interface WeiCommentAction : NSManagedObject

@property (nonatomic, retain) NSNumber * commentId;
@property (nonatomic, retain) NSNumber * isUped;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * userId;

@end