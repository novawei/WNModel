//
//  WNModel.m
//  wnmodel
//
//  Created by WeiXinxing on 16/4/19.
//  Copyright © 2016年 novawei. All rights reserved.
//

#import "WNModel.h"
#import "WNModelRule.h"
#import <objc/runtime.h>

// cache rules and properties of class
static NSMutableDictionary *wn_propertiesOfClass;
static NSMutableDictionary *wn_rulesOfClass;
#ifdef MULTITHREAD_SUPPORT
static dispatch_queue_t wn_modelQueue;
#endif

@implementation WNModel

+ (void)load
{
#ifdef MULTITHREAD_SUPPORT
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wn_modelQueue = dispatch_queue_create("com.novawei.model", DISPATCH_QUEUE_SERIAL);
#endif
        wn_propertiesOfClass = [[NSMutableDictionary alloc] initWithCapacity:10];
        wn_rulesOfClass = [[NSMutableDictionary alloc] initWithCapacity:10];
#ifdef MULTITHREAD_SUPPORT
    });
#endif
}

+ (void)clearCache
{
#ifdef MULTITHREAD_SUPPORT
    dispatch_barrier_async(wn_modelQueue, ^{
#endif
        [wn_propertiesOfClass removeAllObjects];
        [wn_rulesOfClass removeAllObjects];
#ifdef MULTITHREAD_SUPPORT
    });
#endif
}

+ (NSArray *)modelProperties
{
    NSString *className = NSStringFromClass(self);
    __block NSMutableArray *properties = nil;
#ifdef MULTITHREAD_SUPPORT
    dispatch_sync(wn_modelQueue, ^{
#endif
        properties = wn_propertiesOfClass[className];
#ifdef MULTITHREAD_SUPPORT
    });
#endif
    if (properties == nil) {
        properties = [[NSMutableArray alloc] initWithCapacity:10];
        Class nextClass = self;
        while ([nextClass isSubclassOfClass:[WNModel class]]) {
            unsigned int count = 0;
            objc_property_t *objcProperties = class_copyPropertyList(nextClass, &count);
            for (int i = 0; i < count; i++) {
                objc_property_t p = objcProperties[i];
                const char *c_name = property_getName(p);
                NSString *name = [[NSString alloc] initWithCString:c_name encoding:NSUTF8StringEncoding];
                if (![name hasPrefix:WNModelExcludedPropertyPrefix]
                    && ![name isEqualToString:@"hash"]
                    && ![name isEqualToString:@"superclass"]
                    && ![name isEqualToString:@"description"]
                    && ![name isEqualToString:@"debugDescription"]) {
                    [properties addObject:name];
                }
            }
            free(objcProperties);
            // next
            nextClass = [nextClass superclass];
        }
#ifdef MULTITHREAD_SUPPORT
        dispatch_barrier_async(wn_modelQueue, ^{
#endif
            wn_propertiesOfClass[className] = properties;
#ifdef MULTITHREAD_SUPPORT
        });
#endif
    }
    return properties;
}

+ (NSArray *)modelRules
{
    return nil;
}

+ (NSArray *)wn_modelRules
{
    NSString *className = NSStringFromClass(self);
    __block NSArray *rules = nil;
#ifdef MULTITHREAD_SUPPORT
    dispatch_sync(wn_modelQueue, ^{
#endif
        rules = wn_rulesOfClass[className];
#ifdef MULTITHREAD_SUPPORT
    });
#endif
    if (!rules) {
        rules = [self modelRules];
        if (rules) {
#ifdef MULTITHREAD_SUPPORT
            dispatch_barrier_async(wn_modelQueue, ^{
#endif
                wn_rulesOfClass[className] = rules;
#ifdef MULTITHREAD_SUPPORT
            });
#endif
        }
    }
    return rules;
}

+ (instancetype)newInstance:(NSDictionary *)dict
{
    id instance = [[self alloc] init];
    @autoreleasepool {
        NSArray *wn_properties = [self modelProperties];
        NSArray *wn_rules = [self wn_modelRules];
        
        for (NSString *property in wn_properties) {
            @try {
                id value = dict[property];
                for (WNModelRule *rule in wn_rules) {
                    if ([rule match:property]) {
                        value = [rule configValue:value forProperty:property withDict:dict];
                        if (rule.isExclusive) {
                            break;
                        }
                    }
                }
                if ([value isKindOfClass:[NSNull class]]) {
                    value = nil;
                }
                if (value) {
                    [instance setValue:value forKey:property];
                }
            }
            @catch (NSException *exception) {
                continue;
            }
        }
    }
    return instance;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"ERROR! UndefinedKey : \"%@\"", key);
    return nil;
}

#ifdef DEBUG
- (NSString *)description
{
    NSArray *props = [[self class] modelProperties];
    NSMutableString *desc = [[NSMutableString alloc] initWithString:NSStringFromClass([self class])];
    [desc appendFormat:@"{"];
    for (NSString *prop in props) {
        [desc appendFormat:@"%@: %@, ", prop, [self valueForKey:prop]];
    }
    [desc appendFormat:@"}"];
    return desc;
}
#endif

@end
