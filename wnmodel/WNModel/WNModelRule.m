//
//  WNModelRule.m
//  wnmodel
//
//  Created by WeiXinxing on 16/4/19.
//  Copyright © 2016年 novawei. All rights reserved.
//

#import "WNModelRule.h"

@implementation WNModelRule

- (instancetype)init
{
    if (self = [super init]) {
        self.exclusive = YES;
    }
    return self;
}

- (BOOL)match:(NSString *)property
{
    return NO;
}

- (id)configValue:(id)value forProperty:(NSString *)property withDict:(NSDictionary *)dict
{
    if (!value) {
        value = dict[property];
    }
    return value;
}

@end
