//
//  PropertyNotifyVC.h
//  Sunflower
//
//  Created by mark on 15/5/1.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityNote.h"

@interface PropertyNotifyVC : MKWViewController

@property(nonatomic,strong)NSNumber             *noteId;
@property(nonatomic,strong)CommunityNoteInfo    *note;

- (void)refreshNote;
@end
