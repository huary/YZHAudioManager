//
//  UIImagePickerController+Orientation.m
//  jszs
//
//  Created by yuan on 2018/3/13.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import "UIImagePickerController+Orientation.h"
#import <objc/runtime.h>

@implementation UIImagePickerController (Orientation)

-(void)setTag:(NSUInteger)tag
{
    objc_setAssociatedObject(self, @selector(tag), @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSUInteger)tag
{
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

-(void)setOrientationsBlock:(SupportedInterfaceOrientationsBlock)orientationsBlock
{
    objc_setAssociatedObject(self, @selector(orientationsBlock), orientationsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(SupportedInterfaceOrientationsBlock)orientationsBlock
{
    return objc_getAssociatedObject(self, _cmd);
}


-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.orientationsBlock) {
        UIInterfaceOrientationMask mask = self.orientationsBlock(self);
        if (mask >= UIInterfaceOrientationMaskPortrait && mask <= UIInterfaceOrientationMaskAll) {
            return mask;
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
