//
//  UIAlertView+DaiMethodHelper.m
//  DaiMethodHelper
//
//  Created by DaidoujiChen on 2015/9/8.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "UIAlertView+DaiMethodHelper.h"

#import <objc/runtime.h>

@implementation UIAlertView (Hentai)

@dynamic clicked, cancelled;

#pragma mark - dynamic

- (void)setClicked:(ClickBlock)clicked {
	objc_setAssociatedObject(self, @selector(clicked), clicked, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ClickBlock)clicked {
	return objc_getAssociatedObject(self, _cmd);
}

- (void)setCancelled:(CancelBlock)cancelled {
	objc_setAssociatedObject(self, @selector(cancelled), cancelled, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CancelBlock)cancelled {
	return objc_getAssociatedObject(self, _cmd);
}

- (void)setAccount:(AccountBlock)hentai_account {
    objc_setAssociatedObject(self, @selector(account), hentai_account, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (AccountBlock)account {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - instance method

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message {
	return [UIAlertView alertViewWithTitle:title message:message cancelButtonTitle:@"取消"];
}

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	[alert show];
	return alert;
}

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtons onClickIndex:(ClickBlock)clicked onCancel:(CancelBlock)cancelled {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:[self class] cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	alert.clicked = clicked;
	alert.cancelled = cancelled;
    
	for (NSString *buttonTitle in otherButtons) {
		[alert addButtonWithTitle:buttonTitle];
	}
	[alert show];
	return alert;
}

#pragma mark - UIAlertViewDelegate

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
		if (alertView.cancelled) {
			alertView.cancelled();
		}
	}
	else {
		if (alertView.clicked) {
			alertView.clicked(buttonIndex - 1);
		}
	}
}

@end
