//
//  MainViewController+DaidoujiCategory2.m
//  DaiMethodHelper
//
//  Created by DaidoujiChen on 2015/9/8.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "MainViewController+DaidoujiCategory2.h"

@implementation MainViewController (DaidoujiCategory2)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzling:[self class] from:@selector(iLoveDaidouji:) to:@selector(swi2_iLoveDaidouji:)];
    });
}

- (NSString *)swi2_iLoveDaidouji:(NSString *)input {
    NSLog(@"SwizzlingDaidoujiCategory2");
    return [self swi2_iLoveDaidouji:input];
}

@end
