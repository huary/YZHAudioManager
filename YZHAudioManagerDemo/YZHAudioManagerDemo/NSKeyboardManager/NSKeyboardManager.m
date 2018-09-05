//
//  NSKeyboardManager.m
//  易阅卷
//
//  Created by yuan on 2017/6/22.
//  Copyright © 2017年 yuan. All rights reserved.
//

#import "NSKeyboardManager.h"

//static NSKeyboardManager *_shareKeyboardManager_s=nil;

@interface NSKeyboardManager ()

@property (nonatomic, assign) BOOL isSpecialFirstResponderView;

/* <#name#> */
@property (nonatomic, assign) CGAffineTransform relatedShiftViewBeforeShowTransform;

/* <#注释#> */
@property (nonatomic, strong) NSNotification *keyboardNotification;

@end

@implementation NSKeyboardManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpDefault];
    }
    return self;
}

-(void)setUpDefault
{
    self.isSpecialFirstResponderView = NO;
    [self _registerAllNotification:YES];
}

-(void)setFirstResponderView:(UIView *)firstResponderView
{
    _firstResponderView = firstResponderView;
    if (_firstResponderView != nil) {
        self.isSpecialFirstResponderView = YES;
    }
    else {
        self.isSpecialFirstResponderView = NO;
    }
}

-(void)_registerAllNotification:(BOOL)regist
{
    [self _registerFirstResponderViewNotification:regist didBecomeFirstResponderNotificationName:UITextFieldTextDidBeginEditingNotification didResignFirstResponderNotificationName:UITextFieldTextDidEndEditingNotification];
    [self _registerFirstResponderViewNotification:regist didBecomeFirstResponderNotificationName:UITextViewTextDidBeginEditingNotification didResignFirstResponderNotificationName:UITextViewTextDidEndEditingNotification];
    
    [self _registerKeyboardNotification:regist];
}

-(void)_registerKeyboardNotification:(BOOL)regist
{
    if (regist) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    }
}

-(void)_registerFirstResponderViewNotification:(BOOL)regist didBecomeFirstResponderNotificationName:(NSString*)becomeNotificationName didResignFirstResponderNotificationName:(NSString*)resignNotificationName
{
    if (regist) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didBecomeFirstResponder:) name:becomeNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didResignFirstResponder:) name:resignNotificationName object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:becomeNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:resignNotificationName object:nil];
    }
}

-(void)_registerStatusBarNotification:(BOOL)regist
{
    if (regist) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didChangeStatusBarFrame:) name:UIApplicationDidChangeStatusBarFrameNotification object:[UIApplication sharedApplication]];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:[UIApplication sharedApplication]];
    }
}

-(BOOL)_doUpdateWithKeyboardFrame:(CGRect)keyboardFrame duration:(NSTimeInterval)duration isHide:(BOOL)isHide
{
    if (self.firstResponderView == nil) {
        return NO;
    }
    
    if (self.willUpdateBlock) {
        self.willUpdateBlock(self, self.keyboardNotification, !isHide);
    }
    
    CGRect firstResponderViewFrame = self.firstResponderView.frame;
    firstResponderViewFrame = [self.firstResponderView.superview convertRect:firstResponderViewFrame toView:[UIApplication sharedApplication].keyWindow];
    
    void (^animateCompletionBlock)(BOOL finished) = ^(BOOL finished){
//        if (isHide && self.didHideBlock) {
//            self.didHideBlock(self);
//        }
        
//        if (isHide) {
//            if (self.didHideBlock) {
//                self.didHideBlock(self);
//            }
//        }
//        else {
//            if (self.didShowBlock) {
//                self.didShowBlock(self);
//            }
//        }
    };
    
    CGFloat diffY = keyboardFrame.origin.y - CGRectGetMaxY(firstResponderViewFrame) - self.keyboardTopToResponder;
//    NSLog(@"==========diffY=%f",diffY);
    if (diffY > 0) {
        if (isHide) {
            [UIView animateWithDuration:duration animations:^{
                self.relatedShiftView.transform = self.relatedShiftViewBeforeShowTransform;
            } completion:animateCompletionBlock];
        }
        return YES;
    }
    
    CGFloat oldTranslationX = self.relatedShiftView.transform.tx;
    CGFloat oldTranslationY = self.relatedShiftView.transform.ty;
    CGFloat ty = oldTranslationY + diffY;
    
//    NSLog(@"============ty=%f,oldTranslationY=%f,thread=%@",ty,oldTranslationY,[NSThread currentThread]);
    
    [UIView animateWithDuration:duration animations:^{
        self.relatedShiftView.transform = CGAffineTransformMakeTranslation(oldTranslationX, ty);
    } completion:animateCompletionBlock];
    
    return YES;
}

#pragma mark firstResponder
-(void)_didBecomeFirstResponder:(NSNotification*)notification
{
    if (self.isSpecialFirstResponderView && self.firstResponderView != nil) {
        goto _DID_BECOME_FIRST_RESPONDER_END;
    }
    self.isSpecialFirstResponderView = NO;
    _firstResponderView = notification.object;
    
_DID_BECOME_FIRST_RESPONDER_END:
    [self _keyboardAction:self.keyboardNotification show:YES];
}

-(void)_didResignFirstResponder:(NSNotification*)notification
{
//    if (self.isSpecialFirstResponderView) {
//        return;
//    }
//    _firstResponderView = nil;
}

#pragma mark statusBarFrame
-(void)_didChangeStatusBarFrame:(NSNotification*)notification
{
}


#pragma mark keyBoard

-(void)_keyboardAction:(NSNotification*)notification show:(BOOL)show
{
    if (!notification) {
        return;
    }
    
//    NSLog(@"notification=%@",notification);
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardFrame = CGRectZero;
    [notification.userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if (show) {
        CGRect keyboardBeginFrame = CGRectZero;
        [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];
//        NSLog(@"begin.frame=%@,screenH=%f",NSStringFromCGRect(keyboardBeginFrame),SCREEN_HEIGHT);
        if (keyboardBeginFrame.origin.y == SCREEN_HEIGHT) {
            self.relatedShiftViewBeforeShowTransform = self.relatedShiftView.transform;
        }
        
        self.keyboardNotification = notification;
        
        BOOL OK = [self _doUpdateWithKeyboardFrame:keyboardFrame duration:time isHide:NO];
        
        if (OK) {
            self.keyboardNotification = nil;
        }
    }
    else {
        self.keyboardNotification = notification;
        
        BOOL OK = [self _doUpdateWithKeyboardFrame:keyboardFrame duration:time isHide:YES];
        
        if (OK) {
            self.keyboardNotification = nil;
            self.relatedShiftViewBeforeShowTransform = CGAffineTransformIdentity;
            
            if (!self.isSpecialFirstResponderView) {
                _firstResponderView = nil;
            }
        }
    }
}

-(void)_keyboardWillShow:(NSNotification*)notification
{
//    NSLog(@"notification=%@",notification);
    if (self.willShowBlock) {
        self.willShowBlock(self, notification);
    }
    
    [self _keyboardAction:notification show:YES];

}

-(void)_keyboardWillHide:(NSNotification*)notification
{
//    NSLog(@"notification=%@",notification);
    if (self.willHideBlock) {
        self.willHideBlock(self, notification);
    }
    [self _keyboardAction:notification show:NO];
}

-(void)_keyboardDidShow:(NSNotification*)notification
{
//    NSLog(@"notification=%@",notification);
    if (self.didShowBlock) {
        self.didShowBlock(self, notification);
    }
}

-(void)_keyboardDidHide:(NSNotification*)notification
{
//    NSLog(@"notification=%@",notification);
    if (self.didHideBlock) {
        self.didHideBlock(self, notification);
    }
}

-(void)dealloc
{
    [self _registerAllNotification:NO];
}

@end





/*****************************************************************************
 *NSShareKeyboardManager
 *****************************************************************************/
static NSShareKeyboardManager *_shareKeyboardManager_s=nil;


@implementation NSShareKeyboardManager

+(instancetype)shareKeyboardManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareKeyboardManager_s = [[super allocWithZone:NULL] init];
        [_shareKeyboardManager_s _setUpDefault];
    });
    return _shareKeyboardManager_s;
}

-(void)_setUpDefault
{
    _keyboardManager = [[NSKeyboardManager alloc] init];
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [NSShareKeyboardManager shareKeyboardManager];
}

-(id)copyWithZone:(struct _NSZone *)zone
{
    return [NSShareKeyboardManager shareKeyboardManager];
}

@end
