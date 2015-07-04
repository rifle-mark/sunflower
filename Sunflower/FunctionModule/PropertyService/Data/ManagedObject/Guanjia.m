//
//  Guanjia.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "Guanjia.h"
#import "MKWModelHandler.h"



@implementation Guanjia

@dynamic guanjiaId;
@dynamic image;
@dynamic name;
@dynamic title;
@dynamic phone;
@dynamic communityId;
@dynamic actionCount;

@end

@implementation GuanjiaInfo

-(NSDictionary *)mappingKeys {
    return @{
             @"CommunityId":@"communityId",
             @"Id":@"guanjiaId",
             @"Job":@"title",
             @"Image":@"image",
             @"Tel":@"phone",
             @"UserName":@"name",
             @"ActionCount":@"actionCount",
             };
}

-(NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic {
    return dic;
}

-(NSManagedObject *)getOrInsertManagedObject {
    Guanjia *guanjia = [[[MKWModelHandler defaultHandler] queryObjectsForEntity:k_ENTITY_GUANJIA predicate:[NSPredicate predicateWithFormat:@"communityId=%@ AND guanjiaId=%@", self.communityId, self.guanjiaId]] firstObject];
    if (!guanjia) {
        guanjia = [[MKWModelHandler defaultHandler] insertNewObjectForEntityForName:k_ENTITY_GUANJIA];
    }
    return guanjia;
}

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array {
    if (!array || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        GuanjiaInfo *info = [[GuanjiaInfo alloc] init];
        info = [info infoWithJSONDic:dic];
        [retVal addObject:info];
    }
    return retVal;
}

+ (instancetype)infoWithManagedObj:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    GuanjiaInfo *retVal = [[GuanjiaInfo alloc] init];
    return [retVal infoFromManagedObject:obj];
}

@end
