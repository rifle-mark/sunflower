//
//  NormalRegisterVC.h
//  Sunflower
//
//  Created by mark on 15/5/9.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@interface NormalRegisterVC : MKWViewController

@property(nonatomic,assign)UserRegisterType type;
@property(nonatomic,strong)NSString         *naviTitle;

@end
