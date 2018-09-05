//
//  NSObject+WeakAssociationObject.m
//  jszs
//
//  Created by yuan on 2018/8/21.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import "NSObject+WeakAssociationObject.h"
#import <objc/runtime.h>

typedef id(^WeakAssociationObjectBlock)();


@implementation NSObject (WeakAssociationObject)

-(void)setWeakAssociationObject:(id)weakAssociationObject
{
    WEAK_NSOBJ(weakAssociationObject, weakObject);
    WeakAssociationObjectBlock block = ^{
        return weakObject;
    };
    objc_setAssociatedObject(self, @selector(weakAssociationObject), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(id)weakAssociationObject
{
    WeakAssociationObjectBlock block = objc_getAssociatedObject(self, _cmd);
    id weakObject = (block ? block() : nil);
    return weakObject;
}

@end
