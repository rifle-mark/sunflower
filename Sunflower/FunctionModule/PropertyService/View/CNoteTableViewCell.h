//
//  CNoteTableViewCell.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityNoteInfo;
@interface CNoteTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView           *readIcon;
@property(nonatomic,weak)IBOutlet UILabel               *titleL;
@property(nonatomic,weak)IBOutlet UILabel               *timeL;
@property(nonatomic,weak)IBOutlet UIView                *splitV;

@property(nonatomic,strong)CommunityNoteInfo                *note;

@end
