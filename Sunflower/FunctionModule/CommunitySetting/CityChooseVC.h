//
//  CityChooseVC.h
//  Sunflower
//
//  Created by mark on 15/4/22.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpendCity.h"

@interface CityChooseVC : MKWViewController

@property(nonatomic,strong,readonly)OpendCityInfo    *city;


@property(nonatomic,strong)NSString *locatedCity;

@property(nonatomic,weak)IBOutlet UIButton      *okBtn;

@end
