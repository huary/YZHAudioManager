//
//  NSWeakProxy.h
//  UIPaintingViewDemo
//
//  Created by yuan on 2018/6/6.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSWeakProxy : NSProxy

/** <#注释#> */
@property (nonatomic, weak, readonly) id target;

-(instancetype)initWithTarget:(id)target;

+(instancetype)proxyWithTarget:(id)target;

@end
