//
//  DaiMethodInfomation.h
//  DaiMethodHelper
//
//  Created by 啟倫 陳 on 2015/9/6.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiMethodInfomation : NSObject

@property (nonatomic, readonly) BOOL isClassMethod;
@property (nonatomic, readonly) NSString *className;
@property (nonatomic, readonly) NSString *categoryName;
@property (nonatomic, readonly) NSString *methodName;
@property (nonatomic, readonly) NSString *fromPath;
@property (nonatomic, readonly) NSUInteger address;

- (id)initWithAddress:(NSUInteger)address;

@end
