//
//  CSTableViewCell.m
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "CSTableViewCell.h"
#import "MKWColorHelper.h"

#import "GCExtension.h"

@implementation CSTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.selectedImgV.hidden = !self.isSelected;
    [self _setupObserver];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self selectedStyleWithSelected:selected];
}

- (void)selectedStyleWithSelected:(BOOL)selected {
    self.selectedImgV.hidden = !selected;
    // Configure the view for the selected state
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            if (selected) {
                self.backgroundColor = k_COLOR_GALLERY;
            }
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            self.backgroundColor = k_COLOR_WHITE;
            
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)_setupObserver {
    [self startObserveObject:self forKeyPath:@"titleText" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        self.titleL.text = self.titleText;
    }];
    
    [self startObserveObject:self forKeyPath:@"type" usingBlock:^(NSObject *target, NSString *keyPath, NSDictionary *change) {
        self.iconImgV.hidden = YES;
        if (self.type == Community) {
            self.iconImgV.hidden = NO;
        }
    }];
}

@end
