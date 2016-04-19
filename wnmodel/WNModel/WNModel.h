//
//  WNModel.h
//  wnmodel
//
//  Created by WeiXinxing on 16/4/19.
//  Copyright © 2016年 novawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNModelCommonRules.h"

#define MULTITHREAD_SUPPORT
// propery name start with `wn_` will not include in `modelProperties`
static NSString *const WNModelExcludedPropertyPrefix = @"wn_";

@interface WNModel : NSObject

+ (instancetype)newInstance:(NSDictionary *)dict;

// do not override this method. (usage: e.g. `copyWithZone:`)
+ (NSArray *)modelProperties;

// rules used in `newInstance:`, subclass can override and return rules
+ (NSArray<WNModelRule *> *)modelRules;

// object's properties is cached, call this method to free memory when received memory warning
+ (void)clearCache;

@end
