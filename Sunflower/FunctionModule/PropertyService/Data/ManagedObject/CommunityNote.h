//
//  CommunityNote.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MKWInfoObject.h"

#define k_ENTITY_COMMUNITYNOTE      @"CommunityNote"


@class CommunityNoteInfo;

@interface CommunityNote : NSManagedObject

@property (nonatomic, retain) NSNumber * communityId;
@property (nonatomic, retain) NSNumber * noticeId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * isRead;

@end


@interface CommunityNoteInfo : MKWInfoObject

- (void)readNote;

@property (nonatomic, strong) NSNumber * communityId;
@property (nonatomic, strong) NSNumber * noticeId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * isRead;

@end