//
//  DaiMethodInfomation.m
//  DaiMethodHelper
//
//  Created by 啟倫 陳 on 2015/9/6.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "DaiMethodInfomation.h"
#import <dlfcn.h>

@interface DaiMethodInfomation ()

@property (nonatomic, assign) BOOL isClassMethod;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) NSString *fromPath;
@property (nonatomic, assign) NSUInteger address;

@end

@implementation DaiMethodInfomation

#pragma mark - method override

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"%@", self.isClassMethod ? @"+" : @"-"];
    [description appendFormat:@"%@ ", self.methodName];
    [description appendFormat:@"(%p) ", (void *)self.address];
    [description appendFormat:@"in %@", self.className];
    if (self.categoryName) {
        [description appendFormat:@"(%@)", self.categoryName];
    }
    [description appendFormat:@" from %@", [self.fromPath lastPathComponent]];
    return description;
}

#pragma mark - private instance method

// symbol like -[ClassName(CategoryName) MethodName]
- (BOOL)fillInfomation:(NSString *)symbol {
    self.isClassMethod = ([symbol characterAtIndex:0] == '+');
    
    NSCharacterSet *removeCharacter = [NSCharacterSet characterSetWithCharactersInString:@"+-[]"];
    NSArray *splitNames = [[symbol stringByTrimmingCharactersInSet:removeCharacter] componentsSeparatedByString:@" "];
    if (splitNames.count < 2) {
        return NO;
    }
    self.methodName = splitNames[1];
    
    NSRange startOfCategoryName = [splitNames[0] rangeOfString:@"("];
    if (startOfCategoryName.location == NSNotFound) {
        self.className = splitNames[0];
        self.categoryName = nil;
    }
    else {
        NSRange endOfCategoryName = [splitNames[0] rangeOfString:@")"];
        self.className = [splitNames[0] substringToIndex:startOfCategoryName.location];
        NSUInteger location = startOfCategoryName.location + 1;
        NSUInteger length = endOfCategoryName.location - location;
        self.categoryName = [splitNames[0] substringWithRange:NSMakeRange(location, length)];
    }
    return YES;
}

#pragma mark - instance method

- (id)initWithAddress:(NSUInteger)address {
    self = [super init];
    if (self) {
        Dl_info info;
        if (dladdr((const void *)(NSUInteger)address, &info)) {
            self.address = address;
            
            BOOL isSuccess = YES;
            if (info.dli_fname) {
                self.fromPath = [NSString stringWithUTF8String:info.dli_fname];
            }
            else {
                isSuccess = NO;
            }
            
            if (info.dli_sname) {
                isSuccess = [self fillInfomation:[NSString stringWithUTF8String:info.dli_sname]];
            }
            else {
                isSuccess = NO;
            }
            
            if (!isSuccess) {
                return nil;
            }
        }
        else {
            return nil;
        }
    }
    return self;
}

@end
