//
//  CommunityChooseVC.h
//  Sunflower
//
//  Created by mark on 15/4/22.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpendCity.h"
#import "OpendArea.h"
#import "OpendCommunity.h"

@interface CommunityChooseVC : MKWViewController

@property(nonatomic,strong,readonly)OpendCommunityInfo    *community;

@property(nonatomic,strong)OpendCityInfo *city;
@property(nonatomic,strong)OpendAreaInfo *area;

@property(nonatomic,weak)IBOutlet UIButton      *okBtn;

@end
