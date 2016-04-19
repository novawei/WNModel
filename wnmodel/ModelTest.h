//
//  ModelTest.h
//  wnmodel
//
//  Created by WeiXinxing on 16/4/19.
//  Copyright © 2016年 novawei. All rights reserved.
//

#import "WNModel.h"

@interface ModelTest : WNModel

@property (nonatomic, strong) NSString *testId;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) ModelTest *subTest;
@property (nonatomic, strong) NSArray *testArray;

@end
