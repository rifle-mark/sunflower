//
//  IPSModelHandler.m
//  IPSModel
//
//  Created by zhoujinqiang on 14-5-12.
//  Copyright (c) 2014年 zhoujinqiang. All rights reserved.
//

#import "MKWModelHandler.h"


@interface MKWModelHandler ()

@property (nonatomic, strong) dispatch_queue_t coredataOperationQueue;

@end

@implementation MKWModelHandler

#pragma mark - class public method
+ (id)defaultHandler {
    static MKWModelHandler* handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[MKWModelHandler alloc] init];
    });
    return handler;
}

+ (NSNumber *)getMaxKeyIdForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *keyId = [userDefault objectForKey:key];
    if (keyId) {
        NSNumber *ret = [NSNumber numberWithInt:[keyId intValue]+1];
        [userDefault setObject:ret forKey:key];
        [userDefault synchronize];
        return ret;
    }
    else {
        NSNumber *ret = [NSNumber numberWithInt:0];
        [userDefault setObject:ret forKey:key];
        [userDefault synchronize];
        return ret;
    }
}

#pragma mark - class private method

+ (NSURL *)_applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)logError:(NSError*)error {
    NSLog(@"[ERROR][%s->%d] Domain: %@, Desc: %@",__FUNCTION__, __LINE__, error.domain, error.description);
}

#pragma mark - instance public method
- (id)init {
    if (self = [super init]) {
        NSURL* const modelURL = [[NSBundle mainBundle] URLForResource:@"SunflowerModel"
                                                        withExtension:@"momd"];
        NSURL* const storeURL = [[MKWModelHandler _applicationDocumentsDirectory]
                                 URLByAppendingPathComponent:@"IPSData.sqlite"];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:_coordinator];
        
        NSDictionary* const optionsDictionary = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                                                  NSInferMappingModelAutomaticallyOption : @YES};
        NSError* error;
        if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:storeURL
                                              options:optionsDictionary
                                                error:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        _coredataOperationQueue = dispatch_queue_create("coredata_operation_queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (BOOL)saveContext {
    NSDate* date = [NSDate date];
    NSLog(@"save coredata context......");
    NSError* error;
    if ([_context hasChanges] && ![_context save:&error]) {
        [self logError:error];
        NSLog(@"save time %f", [date timeIntervalSinceNow]);
        return NO;
    }
    NSLog(@"save time %f", [date timeIntervalSinceNow]);
    return YES;
}

- (id)insertNewObjectForEntityForName:(NSString *)entityName {
    __block id insertedNewObject = nil;
    dispatch_barrier_sync(_coredataOperationQueue, ^{
        insertedNewObject = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                          inManagedObjectContext:_context];
    });
    return insertedNewObject;
}
- (void)deleteObject:(NSManagedObject *)object {
    dispatch_barrier_sync(_coredataOperationQueue, ^{
        [_context deleteObject:object];
    });
}
- (void)deleteObjectsInEntity:(NSString *)entityName {
    NSArray *array = [self queryObjectsForEntity:entityName];
    for (NSManagedObject *obj in array) {
        [self deleteObject:obj];
    }
}
- (NSArray *)queryObjectsForEntity:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sorts
                             error:(NSError **)error {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName
                                 inManagedObjectContext:_context];
    request.predicate = predicate;
    request.sortDescriptors = sorts;
    
    __block NSArray* objects = nil;
    dispatch_barrier_sync(_coredataOperationQueue, ^{
        objects = [_context executeFetchRequest:request error:error];
    });
    return objects;
}
- (NSArray *)queryObjectsForEntity:(NSString *)entityName
                         predicate:(NSPredicate *)predicate {
    return [self queryObjectsForEntity:entityName predicate:predicate sortDescriptors:nil error:nil];
}
- (NSArray *)queryObjectsForEntity:(NSString *)entityName
                   sortDescriptors:(NSArray *)sorts {
    
    return [self queryObjectsForEntity:entityName predicate:nil sortDescriptors:sorts error:nil];
}
- (NSArray *)queryObjectsForEntity:(NSString *)entityName {
    return [self queryObjectsForEntity:entityName predicate:nil sortDescriptors:nil error:nil];
}

@end