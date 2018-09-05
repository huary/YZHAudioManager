//
//  UIButton+BGColorForState.h
//  易打分
//
//  Created by yuan on 2017/6/2.
//  Copyright © 2017年 yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BGColorForState)

//@property (nonatomic, copy) NSMutableDictionary *BGColorStateDict;

- (void)setBGColor:(nullable UIColor *)bgColor forState:(UIControlState)state;

@end
