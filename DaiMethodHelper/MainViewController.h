//
//  MainViewController.h
//  DaiMethodHelper
//
//  Created by 啟倫 陳 on 2015/9/6.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

+ (void)swizzling:(Class)aClass from:(SEL)before to:(SEL)after;
- (NSString *)iLoveDaidouji:(NSString *)input;

@end
