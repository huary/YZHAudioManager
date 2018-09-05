//
//  UIButton+BGColorForState.m
//  易打分
//
//  Created by yuan on 2017/6/2.
//  Copyright © 2017年 yuan. All rights reserved.
//

#import "UIButton+BGColorForState.h"
#import "NSObject+KVO.h"
#import <objc/runtime.h>

@implementation UIButton (BGColorForState)

//-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
//{
//    NSLog(@"keyPath=%@,options=%@",options);
//}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selected"]) {
        
        NSInteger state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        UIColor *bgColor = nil;
        if (state == 1) {
            bgColor = self.BGColorStateDict[@(UIControlStateSelected)];
        }
        else{
            bgColor = self.BGColorStateDict[@(UIControlStateNormal)];
        }
        self.backgroundColor = bgColor;
    }
}



-(void)setBGColorStateDict:(NSMutableDictionary *)BGColorStateDict
{
    objc_setAssociatedObject(self, @selector(BGColorStateDict), BGColorStateDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary*)BGColorStateDict
{
    NSMutableDictionary *mutDict = objc_getAssociatedObject(self, _cmd);
    if (mutDict == nil) {
        mutDict = [NSMutableDictionary dictionary];
        self.BGColorStateDict = mutDict;
    }
    return mutDict;
}

- (void)setBGColor:(nullable UIColor *)bgColor forState:(UIControlState)state
{
    if (bgColor == nil) {
        bgColor = BLACK_COLOR;
    }
    [self.BGColorStateDict setObject:bgColor forKey:@(state)];
    NSLog(@"self.BGColorStateDict=%@",self.BGColorStateDict);
    [self addKVOObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
}



@end
