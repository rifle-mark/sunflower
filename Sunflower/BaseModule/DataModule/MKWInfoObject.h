//
//  MKWInfoObject.h
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define IGNORE_NULL_JSON_VALUE 1
#define LOG_4_UNDEFINED_KEY 0

@protocol MKWObject <NSObject>

@optional
- (NSDictionary *)mappingKeys;
- (NSDictionary *)keyValsFromJSONDic:(NSDictionary *)dic;
- (NSManagedObject *)getOrInsertManagedObject;

+ (NSArray *)infoArrayWithJSONArray:(NSArray *)array;
+ (instancetype)infoWithManagedObj:(NSManagedObject*)obj;

@end

@interface MKWInfoObject : NSObject<MKWObject>

- (instancetype)infoFromManagedObject:(NSManagedObject *)obj;
- (instancetype)infoWithJSONDic:(NSDictionary *)dic;

- (void)saveToDb;

@end
