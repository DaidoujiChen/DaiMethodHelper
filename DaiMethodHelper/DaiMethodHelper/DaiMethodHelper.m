//
//  DaiMethodHelper.m
//  DaiMethodHelper
//
//  Created by 啟倫 陳 on 2015/9/6.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "DaiMethodHelper.h"
#import <objc/runtime.h>
#import "DaiMethodInfomation.h"

@implementation DaiMethodHelper

#pragma mark - private class method

// 整理出該 class 中所有的 methods, filter 可以決定是不是有需要過濾掉的東西
+ (NSDictionary *)methodsInClass:(Class)aClass filterRule:(BOOL (^)(Method method))filter {
    
    // 列出所有 methods
    unsigned int count = 0;
    Method *methods = class_copyMethodList(aClass, &count);
    NSMutableDictionary *addressMappingTable = [NSMutableDictionary dictionary];
    for (unsigned int index = 0; index < count; index++) {
        
        // 需要過濾, 且過濾判斷為不需要時, 跳過這個 method
        if (filter && !filter(methods[index])) {
            continue;
        }
        
        NSString *methodName = [NSString stringWithUTF8String:sel_getName(method_getName(methods[index]))];
        NSMutableArray *addresses = addressMappingTable[methodName];
        if (!addresses) {
            addresses = [NSMutableArray array];
            addressMappingTable[methodName] = addresses;
        }
        [addresses addObject:@((NSUInteger)method_getImplementation(methods[index]))];
    }
    free(methods);
    return addressMappingTable;
}

// 掃描某一個固定的 class
+ (void)scan:(Class)aClass {
    
    // 先將 methods 按照名字分類
    NSDictionary *addressMappingTable = [self methodsInClass:aClass filterRule:nil];
    
    [addressMappingTable enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSMutableArray *addresses, BOOL *stop) {
        
        // 找出重複兩次以上的 method name, 並且區分為 category methods 與 nativa methods
        if (addresses.count > 1) {
            NSMutableArray *categoryMethods = [NSMutableArray array];
            NSMutableArray *nativeMethods = [NSMutableArray array];
            [addresses enumerateObjectsUsingBlock: ^(NSNumber *address, NSUInteger idx, BOOL *stop) {
                DaiMethodInfomation *information = [[DaiMethodInfomation alloc] initWithAddress:address.unsignedIntegerValue];
                if (information) {
                    if (information.categoryName) {
                        [categoryMethods addObject:information];
                    }
                    else {
                        [nativeMethods addObject:information];
                    }
                }
            }];
            
            printf("===== Duplicate in %s =====\n", class_getName(aClass));
            [categoryMethods enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
                printf("%s\n", [obj description].UTF8String);
            }];
            
            [nativeMethods enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
                printf("%s\n", [obj description].UTF8String);
            }];
        }
    }];
}

// 驗證指定的 selector 運行哪一個 implementation
+ (void)verify:(Class)aClass selector:(SEL)selector {
    
    // 過濾掉不需要的 method name
    NSDictionary *addressMappingTable = [self methodsInClass:aClass filterRule: ^BOOL(Method method) {
        return (strcmp(sel_getName(selector), sel_getName(method_getName(method))) == 0);
    }];
    
    IMP currentIMP = class_getMethodImplementation(aClass, selector);
    [addressMappingTable[NSStringFromSelector(selector)] enumerateObjectsUsingBlock: ^(NSNumber *address, NSUInteger idx, BOOL *stop) {
        DaiMethodInfomation *information = [[DaiMethodInfomation alloc] initWithAddress:address.unsignedIntegerValue];
        if (information) {
            printf("%c %s\n", ((NSUInteger)currentIMP == address.unsignedIntegerValue) ? '*' : ' ', [information description].UTF8String);
        }
    }];
}

// 有些 class 會被轉成像是 __NSCFConstantString, 但是本質上他是 NSString 的一個子類
// 這邊可以把一些狀況導正
+ (Class)tollFreeClass:(id)object {
    if ([object isKindOfClass:[NSCalendar class]]) {
        return [NSCalendar class];
    }
    else if ([object isKindOfClass:[NSData class]]) {
        return [NSData class];
    }
    else if ([object isKindOfClass:[NSError class]]) {
        return [NSError class];
    }
    else if ([object isKindOfClass:[NSLocale class]]) {
        return [NSLocale class];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        return [NSArray class];
    }
    else if ([object isKindOfClass:[NSMutableArray class]]) {
        return [NSMutableArray class];
    }
    else if ([object isKindOfClass:[NSAttributedString class]]) {
        return [NSAttributedString class];
    }
    else if ([object isKindOfClass:[NSMutableAttributedString class]]) {
        return [NSMutableAttributedString class];
    }
    else if ([object isKindOfClass:[NSCharacterSet class]]) {
        return [NSCharacterSet class];
    }
    else if ([object isKindOfClass:[NSMutableCharacterSet class]]) {
        return [NSMutableCharacterSet class];
    }
    else if ([object isKindOfClass:[NSDate class]]) {
        return [NSDate class];
    }
    else if ([object isKindOfClass:[NSMutableData class]]) {
        return [NSMutableData class];
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary class];
    }
    else if ([object isKindOfClass:[NSMutableDictionary class]]) {
        return [NSMutableDictionary class];
    }
    else if ([object isKindOfClass:[NSSet class]]) {
        return [NSSet class];
    }
    else if ([object isKindOfClass:[NSMutableSet class]]) {
        return [NSMutableSet class];
    }
    else if ([object isKindOfClass:[NSString class]]) {
        return [NSString class];
    }
    else if ([object isKindOfClass:[NSMutableString class]]) {
        return [NSMutableString class];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        return [NSNumber class];
    }
    else if ([object isKindOfClass:[NSInputStream class]]) {
        return [NSInputStream class];
    }
    else if ([object isKindOfClass:[NSTimer class]]) {
        return [NSTimer class];
    }
    else if ([object isKindOfClass:[NSTimeZone class]]) {
        return [NSTimeZone class];
    }
    else if ([object isKindOfClass:[NSURL class]]) {
        return [NSURL class];
    }
    else if ([object isKindOfClass:[NSOutputStream class]]) {
        return [NSOutputStream class];
    }
    else {
        return [object class];
    }
}

+ (NSString *)spaceGenerator:(NSInteger)spaceCount {
    NSMutableString *spaceString = [NSMutableString string];
    for (NSInteger space = 0; space < spaceCount; space++) {
        [spaceString appendString:@" "];
    }
    return spaceString;
}

#pragma mark - class method

+ (void)scanClasses {
    unsigned int count;
    count = objc_getClassList(NULL, 0);
    
    // 取得所有存活的 classes
    if (count) {
        Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * count);
        count = objc_getClassList(classes, count);
        for (unsigned int index = 0; index < count; index++) {
            [self scanClass:classes[index]];
        }
        free(classes);
    }
}

+ (void)scanClass:(Class)aClass {
    [self scan:aClass];
    [self scan:objc_getMetaClass(class_getName(aClass))];
}

+ (void)verifyClass:(Class)aClass selector:(SEL)selector {
    
    // 分別對 class methods 與 instance methods 驗證
    [self verify:aClass selector:selector];
    [self verify:objc_getMetaClass(class_getName(aClass)) selector:selector];
}

+ (void *)perform:(id)object selector:(SEL)selector category:(NSString *)category, ... {
    
    // 先找到鎖定的那個 method implementation
    __block DaiMethodInfomation *information = nil;
    __block BOOL swizzlingDetect = NO;
    __block SEL targetSelector = selector;
    __block NSInteger swizzlingCount = 0;
    do {
        swizzlingDetect = NO;
        [self methodsInClass:[self tollFreeClass:object] filterRule: ^BOOL(Method method) {
            if (strcmp(sel_getName(targetSelector), sel_getName(method_getName(method))) == 0) {
                DaiMethodInfomation *newInformation = [[DaiMethodInfomation alloc] initWithAddress:(NSUInteger)method_getImplementation(method)];
                
                // 最後需要判別該 method 有沒有被 swizzling
                swizzlingDetect = (![newInformation.methodName isEqualToString:NSStringFromSelector(selector)]);
                if (swizzlingDetect) {
                    printf("%sswizzling by %s\n", [self spaceGenerator:swizzlingCount++].UTF8String, [newInformation description].UTF8String);
                    targetSelector = NSSelectorFromString(newInformation.methodName);
                }
                else {
                    
                    // 判斷是不是正確選定的 category
                    BOOL isCorrectCategory = (!category && !newInformation.categoryName) || ([newInformation.categoryName isEqualToString:category]);
                    
                    if (isCorrectCategory) {
                        printf("%sfound %s\n", [self spaceGenerator:swizzlingCount++].UTF8String, [newInformation description].UTF8String);
                        information = newInformation;
                    }
                }
            }
            return NO;
        }];
    } while (swizzlingDetect);

    // 如果有找到該一個 implementation
    if (information) {
        
        // 建立 invocation
        id dummyObject = [[self tollFreeClass:object] new];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[dummyObject methodSignatureForSelector:targetSelector]];
        [invocation setTarget:object];
        [invocation setSelector:targetSelector];
        
        // 填入參數
        va_list list;
        va_start(list, category);
        for (NSUInteger index = 2; index < invocation.methodSignature.numberOfArguments; index++) {
            void *var = va_arg(list, void *);
            [invocation setArgument:&var atIndex:index];
        }
        va_end(list);
        
        // 運行
        NSArray *invokeComponents = @[@"in", @"vok", @"eUsi", @"ngI", @"MP", @":"];
        SEL invokeSelector = NSSelectorFromString([invokeComponents componentsJoinedByString:@""]);
        void (*invokeIMP)(id, SEL, void *) = (void (*)(id, SEL, void *))class_getMethodImplementation([self tollFreeClass:invocation], invokeSelector);
        invokeIMP(invocation, invokeSelector, (void *)information.address);
        
        // 如果有回傳值
        if (invocation.methodSignature.methodReturnType[0] != 'v') {
            void *returnValue;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        }
    }
    return 0;
}

@end
