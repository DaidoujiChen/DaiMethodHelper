//
//  DaiMethodHelper.h
//  DaiMethodHelper
//
//  Created by 啟倫 陳 on 2015/9/6.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiMethodHelper : NSObject

// 掃描所有的 classes, 檢查是否有重複定義的 methods
// 會同時檢查 class methods 與 instance methods
+ (void)scanClasses;

// 掃描特定 class, 會同時檢查 class methods 與 instance methods
+ (void)scanClass:(Class)aClass;

// 驗證 method 確實運行在哪一個 implementation 上, 會同時檢查 class methods 與 instance methods
+ (void)verifyClass:(Class)aClass selector:(SEL)selector;

// 排除萬難的執行某一個 method
+ (void *)perform:(id)object selector:(SEL)selector category:(NSString *)category, ...;

@end
