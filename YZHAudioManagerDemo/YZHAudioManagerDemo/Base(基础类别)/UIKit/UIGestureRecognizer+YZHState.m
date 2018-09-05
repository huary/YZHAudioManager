//
//  UIGestureRecognizer+YZHState.m
//  yxx_ios
//
//  Created by yuan on 2017/4/8.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "UIGestureRecognizer+YZHState.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (YZHState)

-(void)setYZHState:(YZHUIGestureRecognizerState)YZHState
{
    objc_setAssociatedObject(self, @selector(YZHState), @(YZHState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(YZHUIGestureRecognizerState)YZHState
{
    return (YZHUIGestureRecognizerState)[objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
