//
//  MainViewController+DaidoujiCategory1.m
//  DaiMethodHelper
//
//  Created by DaidoujiChen on 2015/9/8.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "MainViewController+DaidoujiCategory1.h"

@implementation MainViewController (DaidoujiCategory1)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzling:[self class] from:@selector(iLoveDaidouji:) to:@selector(swi1_iLoveDaidouji:)];
    });
}

- (NSString *)swi1_iLoveDaidouji:(NSString *)input {
    NSLog(@"SwizzlingDaidoujiCategory1");
    return [self swi1_iLoveDaidouji:input];
}

@end
