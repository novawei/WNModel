//
//  WNModelCommonRules.m
//  wnmodel
//
//  Created by WeiXinxing on 16/4/19.
//  Copyright © 2016年 novawei. All rights reserved.
//

#import "WNModelCommonRules.h"
#import "WNModel.h"

@implementation WNModelRulePropertyMapper

- (instancetype)init
{
    if (self = [super init]) {
        self.exclusive = NO;
    }
    return self;
}

- (BOOL)match:(NSString *)property
{
    return (self.propertyMap[property] != nil);
}

- (id)configValue:(id)value forProperty:(NSString *)property withDict:(NSDictionary *)dict
{
    return dict[self.propertyMap[property]];
}

@end

@implementation WNModelRuleConvertURLSuffixToNSURL

- (BOOL)match:(NSString *)property
{
    return ([property hasSuffix:@"URL"]);
}

- (id)configValue:(id)value forProperty:(NSString *)property withDict:(NSDictionary *)dict
{
    NSURL *retValue = nil;
    if (value && [value isKindOfClass:[NSString class]]) {
        retValue = [[NSURL alloc] initWithString:value];
    }
    return retValue;
}

@end

@implementation WNModelRuleConvertValueToWNModel

- (BOOL)match:(NSString *)property
{
    return (self.propertyMap[property] != nil);
}

- (id)configValue:(id)value forProperty:(NSString *)property withDict:(NSDictionary *)dict
{
    if ([value isKindOfClass:[NSString class]]) { // sometime server return json string
        value = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] options:0 error:nil];
    }
    Class cls = self.propertyMap[property];
    WNModel *retValue = nil;
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        retValue = [cls newInstance:value];
    }
    return retValue;
}

@end

@implementation WNModelRuleConvertValueToArrayOfWNModel

- (id)configValue:(id)value forProperty:(NSString *)property withDict:(NSDictionary *)dict
{
    if ([value isKindOfClass:[NSString class]]) { // sometime server return json string
        value = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] options:0 error:nil];
    }
    NSMutableArray *retValue = nil;
    if ([value isKindOfClass:[NSArray class]]) {
        Class cls = self.propertyMap[property];
        retValue = [[NSMutableArray alloc] initWithCapacity:[(NSArray *)value count]];
        [(NSArray *)value enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [retValue addObject:[cls newInstance:obj]];
            }
        }];
    }
    return retValue;
}

@end