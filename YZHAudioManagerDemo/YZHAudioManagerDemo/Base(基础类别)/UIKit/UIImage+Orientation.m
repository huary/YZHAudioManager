//
//  UIImage+Orientation.m
//  jszs
//
//  Created by yuan on 2018/3/26.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import "UIImage+Orientation.h"

@implementation UIImage (Orientation)

-(UIImage*)updateImageOrientation
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}

@end
