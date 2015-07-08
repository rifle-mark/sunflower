//
//  ShopInfoCell.m
//  Sunflower
//
//  Created by mark on 15/5/12.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "ShopInfoCell.h"

#import "ShopStore.h"


@implementation ShopInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)reuseIdentify {
    return @"pc_shop_info_cell";
}

+ (NSAttributedString *)shopDescAttributeStringWithDesc:(NSString *)desc {
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", desc ?: @""] attributes:[ShopInfoCell shopDescAttributes]];
    return str;
}
+ (CGFloat)shopDescCellHeighWithDescStr:(NSString *)desc width:(CGFloat)width {
    
    CGRect rect = [[ShopInfoCell shopDescAttributeStringWithDesc:desc] boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size.height + 40;
}

+ (NSDictionary *)shopDescAttributes {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 4;
    ps.alignment = NSTextAlignmentLeft;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.lineHeightMultiple = 1;
    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                          NSForegroundColorAttributeName:k_COLOR_GALLERY_F,
                          NSBackgroundColorAttributeName:k_COLOR_CLEAR,
                          NSParagraphStyleAttributeName:ps,};
    return att;
}

+ (NSAttributedString *)shopStoreAttributeStringWithStores:(NSArray *)stores {
    NSMutableString *desc = [[NSMutableString alloc] init];
    NSInteger idx = 0;
    for (ShopStoreInfo *store in stores) {
        [desc appendString:store.name];
        [desc appendString:@"\n"];
        [desc appendString:store.address];
        [desc appendString:@"\n"];
        [desc appendString:store.tel];
        [desc appendString:@"\n"];
        if (idx != [stores count]-1) {
            [desc appendString:@"\n"];
        }
    }
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", desc] attributes:[ShopInfoCell shopDescAttributes]];
    return str;
}
+ (CGFloat)shopStorHeightWithStores:(NSArray *)stores width:(CGFloat)width {
    CGRect rect = [[ShopInfoCell shopStoreAttributeStringWithStores:stores] boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size.height + 40;
}

@end
