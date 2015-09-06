//
//  UIAlertView+Hentai.h
//  DaiMethodHelper
//
//  Created by DaidoujiChen on 2015/9/8.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock)(NSInteger clickIndex);
typedef void (^CancelBlock)(void);
typedef void (^AccountBlock)(NSString *userName, NSString *password);

@interface UIAlertView (Hentai) <UIAlertViewDelegate>

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtons onClickIndex:(ClickBlock)clicked onCancel:(CancelBlock)cancelled;

@property (nonatomic, copy) ClickBlock clicked;
@property (nonatomic, copy) CancelBlock cancelled;
@property (nonatomic, copy) AccountBlock account;

@end
