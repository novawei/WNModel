//
//  WNModelCommonRules.h
//  wnmodel
//
//  Created by WeiXinxing on 16/4/19.
//  Copyright © 2016年 novawei. All rights reserved.
//

#import "WNModelRule.h"

// `WNModelRulePropertyMapper` should be firstObject in `modelRules`
// map propery name to return dict key, e.g. mid -> id, since `id` is keyword in objc.
@interface WNModelRulePropertyMapper : WNModelRule

@property (nonatomic, strong) NSDictionary *propertyMap;

@end

// convert property with `URL` suffix to `NSURL`, e.g. thumbnailURL
@interface WNModelRuleConvertURLSuffixToNSURL : WNModelRule

@end

// convert value of property to `WNModel`
@interface WNModelRuleConvertValueToWNModel : WNModelRule

@property (nonatomic, strong) NSDictionary *propertyMap;

@end

// convert value of property to `NSArray` of `WNModel`
@interface WNModelRuleConvertValueToArrayOfWNModel : WNModelRuleConvertValueToWNModel

@end

