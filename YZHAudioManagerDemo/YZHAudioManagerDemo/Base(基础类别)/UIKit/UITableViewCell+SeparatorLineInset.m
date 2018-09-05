//
//  UITableViewCell+SeparatorLineInset.m
//  jszs
//
//  Created by yuan on 2018/8/20.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import "UITableViewCell+SeparatorLineInset.h"

@implementation UITableViewCell (SeparatorLineInset)

-(void)setSeparatorLineInsets:(UIEdgeInsets)insets
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:insets];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:insets];
    }
}


@end
