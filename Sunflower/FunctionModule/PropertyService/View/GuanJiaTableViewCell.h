//
//  GuanJiaTableViewCell.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Guanjia.h"

@interface GuanJiaTableViewCell : UITableViewCell

@property(nonatomic,strong)GuanjiaInfo          *guanjia;
@property(nonatomic,assign)BOOL                 isUped;
@property(nonatomic,copy)void(^upActionBlock)();

+ (NSString *)reuseIdentify;
- (void)updateUpState;
@end
