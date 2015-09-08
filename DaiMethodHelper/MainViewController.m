//
//  MainViewController.m
//  DaiMethodHelper
//
//  Created by 啟倫 陳 on 2015/9/6.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "MainViewController.h"
#import <objc/runtime.h>
#import "DaiMethodHelper.h"
#import "UIAlertView+DaiMethodHelper.h"
#import "NSString+Daidouji1.h"
#import "NSString+Daidouji2.h"

@interface MainViewController ()

@property (nonatomic, assign) NSInteger status;

@end

@implementation MainViewController

#pragma mark - ibaction

- (IBAction)pressButtonAction:(id)sender {
    printf("\n--------------- Status%td ---------------\n\n\n", self.status);
    switch (self.status) {
        case 0:
        {
            printf("call [DaiMethodHelper scanClasses]\n\n");
            [DaiMethodHelper scanClasses];
            [UIAlertView alertViewWithTitle:@"Scan Methods In All Classes" message:@"You would find duplicate method in console log (if there's any)" cancelButtonTitle:@"Done"];
            break;
        }
            
        case 1:
        {
            printf("call [DaiMethodHelper scanClass:[NSString class]]\n\n");
            [DaiMethodHelper scanClass:[NSString class]];
            [UIAlertView alertViewWithTitle:@"Scan Methods In Specific Class" message:@"There are three methods duplicate named iLoveDaidouji in NSString" cancelButtonTitle:@"Done"];
            break;
        }
            
        case 2:
        {
            [UIAlertView alertViewWithTitle:nil message:@"We would not know which method will be implemented at runtime." cancelButtonTitle:@"Done"];
            break;
        }
            
        case 3:
        {
            printf("call [DaiMethodHelper verifyClass:[NSString class] selector:@selector(iLoveDaidouji:)]\n\n");
            [DaiMethodHelper verifyClass:[NSString class] selector:@selector(iLoveDaidouji)];
            [UIAlertView alertViewWithTitle:@"Verify This Method" message:@"Now we know, it will run the method implement in category Daidouji3 when we call method iLoveDaidouji" cancelButtonTitle:@"Done"];
            break;
        }
            
        case 4:
        {
            NSString *string = [NSString new];
            printf("print [string iLoveDaidouji].UTF8String\n");
            printf("=> %s\n\n", [string iLoveDaidouji].UTF8String);
            [UIAlertView alertViewWithTitle:nil message:@"The return value is \"iLoveDaidouji\" when iLoveDaidouji is called directly" cancelButtonTitle:@"Done"];
            break;
        }
            
        case 5:
        {
            NSString *string = [NSString new];
            printf("print [(NSString *)[DaiMethodHelper perform:string selector:@selector(iLoveDaidouji) category:@\"Daidouji1\"] UTF8String]\n");
            printf("=> %s\n\n", [(NSString *)[DaiMethodHelper perform:string selector:@selector(iLoveDaidouji) category:@"Daidouji1"] UTF8String]);
            [UIAlertView alertViewWithTitle:nil message:@"Or we can force to run the method iLoveDaidouji in \"Daidouji1\"" cancelButtonTitle:@"Done"];
            break;
        }
            
        case 6:
        {
            printf("run [self iLoveDaidouji:@\"love\"]\n\n");
            NSLog(@"%@", [self iLoveDaidouji:@"love"]);
            [UIAlertView alertViewWithTitle:nil message:@"Swizzling is a powerful tool to help us, and have better understanding of third party source. Our method might be injected into any code that we would not know." cancelButtonTitle:@"Done"];
            break;
        }
            
        case 7:
        {
            printf("run [self iLoveDaidouji:@\"love\"]\n\n");
            NSLog(@"%@", [DaiMethodHelper perform:self selector:@selector(iLoveDaidouji:) category:nil, @"love"]);
            [UIAlertView alertViewWithTitle:nil message:@"We can protect our method!" cancelButtonTitle:@"Done"];
            break;
        }
            
        default:
            break;
    }
    printf("\n\n\n--------------- Status%td ---------------", self.status++);
}

#pragma mark - class method

+ (void)swizzling:(Class)aClass from:(SEL)before to:(SEL)after {
    SEL originalSelector = before;
    SEL swizzledSelector = after;
    
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - instance method

- (NSString *)iLoveDaidouji:(NSString *)input {
    NSLog(@"OriginDaidouji");
    return [NSString stringWithFormat:@"iLoveDaidouji+%@", input];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.status = 0;
}

@end
