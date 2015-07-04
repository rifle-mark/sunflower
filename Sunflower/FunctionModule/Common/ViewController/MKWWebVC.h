//
//  MKWWebVC.h
//  Sunflower
//
//  Created by makewei on 15/5/17.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKWWebVC : MKWViewController

@property(nonatomic,strong)NSString     *naviTitle;
@property(nonatomic,strong)NSURL        *url;
@property(nonatomic,assign)BOOL         showControl;

@end
