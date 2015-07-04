//
//  WeiComment.h
//  Sunflower
//
//  Created by makewei on 15/6/4.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MKWInfoObject.h"


#define k_ENTITY_WEICOMMENT     @"WeiComment"

@interface WeiComment : NSManagedObject

@property (nonatomic, retain) NSNumber * actionCount;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSNumber * commentId;
@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSString * images;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * parentId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * subCommentCount;

@end


@interface WeiCommentInfo : MKWInfoObject

@property (nonatomic, strong) NSNumber * actionCount;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSNumber * adminId;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSNumber * commentId;
@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSNumber * parentId;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSNumber * subCommentCount;
@end