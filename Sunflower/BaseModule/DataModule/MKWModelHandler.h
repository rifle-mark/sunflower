//
//  IPSModelHandler.h
//  IPSModel
//
//  Created by zhoujinqiang on 14-5-12.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>


@interface MKWModelHandler : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext* context;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* coordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel* model;

+ (instancetype)defaultHandler;
+ (NSNumber *)getMaxKeyIdForKey:(NSString *)key;

- (BOOL)saveContext;
- (void)logError:(NSError*)error;


- (id)insertNewObjectForEntityForName:(NSString *)entityName;

- (void)deleteObject:(NSManagedObject *)object;
- (void)deleteObjectsInEntity:(NSString *)entityName;

- (NSArray *)queryObjectsForEntity:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sorts
                             error:(NSError **)error;

- (NSArray *)queryObjectsForEntity:(NSString *)entityName
                         predicate:(NSPredicate *)predicate;

- (NSArray *)queryObjectsForEntity:(NSString *)entityName
                   sortDescriptors:(NSArray *)sorts;

- (NSArray *)queryObjectsForEntity:(NSString *)entityName;

@end
