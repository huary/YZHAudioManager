//
//  NSObject+KVO.h
//  yxx_ios
//
//  Created by victor siu on 17/3/24.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)

-(void)addKVOObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

-(void)removeKVOObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;


@end
