//
//  AreaChooseVC.h
//  Sunflower
//
//  Created by mark on 15/4/22.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpendCity.h"
#import "OpendArea.h"

@interface AreaChooseVC : MKWViewController

@property(nonatomic,strong,readonly)OpendAreaInfo    *area;
@property(nonatomic,strong)OpendCityInfo *city;


@property(nonatomic,weak)IBOutlet UIButton      *okBtn;
@end
