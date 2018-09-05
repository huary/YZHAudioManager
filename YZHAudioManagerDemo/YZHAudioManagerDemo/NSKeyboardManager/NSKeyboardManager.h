//
//  NSKeyboardManager.h
//  易阅卷
//
//  Created by yuan on 2017/6/22.
//  Copyright © 2017年 yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class NSKeyboardManager;
typedef void(^NSKeyboardWillShowBlock)(NSKeyboardManager *keyboardManager, NSNotification *keyboardNotification);
typedef void(^NSKeyboardWillHideBlock)(NSKeyboardManager *keyboardManager, NSNotification *keyboardNotification);
typedef void(^NSKeyboardWillUpdateBlock)(NSKeyboardManager *keyboardManager, NSNotification *keyboardNotification, BOOL isShow);
typedef void(^NSKeyboardDidHideBlock)(NSKeyboardManager *keyboardManager, NSNotification *keyboardNotification);
typedef void(^NSKeyboardDidShowBlock)(NSKeyboardManager *keyboardManager, NSNotification *keyboardNotification);

@interface NSKeyboardManager : NSObject

@property (nonatomic, weak) UIView *relatedShiftView;

//既可以指定也可以不用指定，就是keyboard不要遮挡的view,默认会自动去获取
@property (nonatomic, weak) UIView *firstResponderView;
//指的是keyboard和firstResponder的最小距离,默认为0;
@property (nonatomic, assign) CGFloat keyboardTopToResponder;

@property (nonatomic, copy) NSKeyboardWillShowBlock willShowBlock;
@property (nonatomic, copy) NSKeyboardWillHideBlock willHideBlock;
@property (nonatomic, copy) NSKeyboardWillUpdateBlock willUpdateBlock;
@property (nonatomic, copy) NSKeyboardDidShowBlock didShowBlock;
@property (nonatomic, copy) NSKeyboardDidHideBlock didHideBlock;
@end






/*****************************************************************************
 *NSShareKeyboardManager
 *****************************************************************************/
@interface NSShareKeyboardManager : NSObject

@property (nonatomic, strong, readonly) NSKeyboardManager *keyboardManager;

+(instancetype)shareKeyboardManager;

@end
