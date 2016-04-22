//
//  ModelTest.m
//  wnmodel
//
//  Created by WeiXinxing on 16/4/19.
//  Copyright © 2016年 novawei. All rights reserved.
//

#import "ModelTest.h"

@implementation ModelTest

+ (NSArray *)modelRules
{
    WNModelRulePropertyMapper *rule1 = [WNModelRulePropertyMapper new];
    rule1.propertyMap = @{@"testId": @"id",
                          @"photoURL": @"photo"};
    
    WNModelRuleConvertURLSuffixToNSURL *rule2 = [WNModelRuleConvertURLSuffixToNSURL new];
    
    WNModelRuleConvertValueToWNModel *rule3 = [WNModelRuleConvertValueToWNModel new];
    rule3.propertyMap = @{@"subTest": [ModelTest class]};
    
    WNModelRuleConvertValueToArrayOfWNModel *rule4 = [WNModelRuleConvertValueToArrayOfWNModel new];
    rule4.propertyMap = @{@"testArray": [ModelTest class]};
    return @[rule1, rule2, rule3, rule4];
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] initWithCapacity:10];
    [desc appendFormat:@"\n%@\n{", NSStringFromClass([self class])];
    for (NSString *prop in [[self class] modelProperties]) {
        [desc appendFormat:@"\t%@ = %@\n", prop, [self valueForKey:prop]];
    }
    [desc appendString:@"}\n"];
    return desc;
}

@end
