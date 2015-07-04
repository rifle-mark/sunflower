//
//  MKWInfoObject.m
//  Sunflower
//
//  Created by mark on 15/5/3.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#import "MKWInfoObject.h"
#import <objc/runtime.h>

#import "MKWStringHelper.h"
#import "MKWModelHandler.h"

@implementation MKWInfoObject


- (instancetype)infoFromManagedObject:(NSManagedObject *)obj {
    if (!obj) {
        return nil;
    }
    
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        
        // ignore compined variables
        const char* attr = property_getAttributes(property);
        NSString *attrStr = [NSString stringWithUTF8String:attr];
        if([attrStr rangeOfString:NSStringFromClass([NSArray class])].location != NSNotFound)
            continue;
        else if([attrStr rangeOfString:NSStringFromClass([NSMutableArray class])].location != NSNotFound)
            continue;
        else if([attrStr rangeOfString:NSStringFromClass([NSDictionary class])].location != NSNotFound)
            continue;
        else if([attrStr rangeOfString:NSStringFromClass([NSMutableDictionary class])].location != NSNotFound)
            continue;
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [self setValue:[obj valueForKey:propertyName] forKey:propertyName];
    }
    return self;
}
- (instancetype)infoWithJSONDic:(NSDictionary *)dic {
    NSDictionary *keyValues = dic;
    if ([self respondsToSelector:@selector(keyValsFromJSONDic:)]) {
        keyValues = [self keyValsFromJSONDic:dic];
    }
    [self setValuesForKeysWithDictionary:keyValues];
    return self;
}

- (void)saveToDb {
    NSManagedObject *obj = nil;
    if ([self respondsToSelector:@selector(getOrInsertManagedObject)]) {
        obj = [self getOrInsertManagedObject];
    }
    
    if (obj) {
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = propertyList[i];
            
            // ignore compined variables
            const char* attr = property_getAttributes(property);
            NSString *attrStr = [NSString stringWithUTF8String:attr];
            if([attrStr rangeOfString:NSStringFromClass([NSArray class])].location != NSNotFound)
                continue;
            else if([attrStr rangeOfString:NSStringFromClass([NSMutableArray class])].location != NSNotFound)
                continue;
            else if([attrStr rangeOfString:NSStringFromClass([NSDictionary class])].location != NSNotFound)
                continue;
            else if([attrStr rangeOfString:NSStringFromClass([NSMutableDictionary class])].location != NSNotFound)
                continue;
            
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [obj setValue:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
}

#pragma mark - over write 
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([self respondsToSelector:@selector(mappingKeys)]){
        NSString *k = [[self mappingKeys] valueForKey:key];
        if(nil != k){
            [self setValue:value forKey:k];
            return;
        }
    }
#ifdef DEBUG
#if LOG_4_UNDEFINED_KEY
    printf("~> %s setValue for Undefined Key : %s\n", [NSStringFromClass([self class]) UTF8String], [key UTF8String]);
#endif
#endif
}

#if IGNORE_NULL_JSON_VALUE
- (void)setValue:(id)value forKey:(NSString *)key{
    if(value && value != [NSNull null]){
        [super setValue:value forKey:key];
    }
}
#endif

- (id)valueForUndefinedKey:(NSString*)key{
    if([self respondsToSelector:@selector(mappingKeys)]){
        NSString *k = [[self mappingKeys] valueForKey:key];
        if(nil != k){
            return [self valueForKey:k];
        }
    }
#ifdef DEBUG
#if LOG_4_UNDEFINED_KEY
    printf("~> %s value for Undefined Key : %s\n", [NSStringFromClass([self class]) UTF8String], [key UTF8String]);
#endif
#endif
    return nil;
}

@end
