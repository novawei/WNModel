//
//  WNModelRule.h
//  wnmodel
//
//  Created by WeiXinxing on 16/4/19.
//  Copyright © 2016年 novawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WNModelRule : NSObject

// if rule is exclusive and matched, the following rules in `modelRules` will not be exec for the property
@property (nonatomic, assign, getter=isExclusive) BOOL exclusive; //Default YES

- (BOOL)match:(NSString *)property;

// dict is the param in `newInstance:`
- (id)configValue:(id)value forProperty:(NSString *)property withDict:(NSDictionary *)dict;

@end
