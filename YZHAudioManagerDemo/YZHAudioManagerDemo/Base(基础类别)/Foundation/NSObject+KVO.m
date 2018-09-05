//
//  NSObject+KVO.m
//  yxx_ios
//
//  Created by victor siu on 17/3/24.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>

@implementation NSObject (KVO)

-(void)addKVOObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if (![self observerForObserver:observer KeyPath:keyPath]) {
        [self addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

-(void)removeKVOObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    if ([self observerForObserver:observer KeyPath:keyPath]) {
        [self removeObserver:observer forKeyPath:keyPath context:context];
    }
}

-(BOOL)observerForObserver:(id)observer KeyPath:(NSString*)keyPath
{
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id properties = [objc valueForKeyPath:@"_property"];
        id observerTmp = [objc valueForKeyPath:@"_observer"];
        
        NSString *keyPathTmp = [properties valueForKeyPath:@"_keyPath"];
        if ([keyPathTmp isEqualToString:keyPath] && [observerTmp isEqual:observer]) {
            return YES;
        }
    }
    return NO;
}

@end
