//
//  UIImage+TintColor.m
//  YZHUINavigationController
//
//  Created by yuan on 2018/4/27.
//  Copyright © 2018年 dlodlo. All rights reserved.
//

#import "UIImage+TintColor.h"

@implementation UIImage (TintColor)

-(UIImage*)tintColor:(UIColor*)color
{
    return [self tintColor:color alpha:1.0 inRect:CGRectMake(0, 0, self.size.width, self.size.height)];
}

-(UIImage*)tintColor:(UIColor*)color alpha:(CGFloat)alpha inRect:(CGRect)rect
{
    CGRect graphicsImageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(graphicsImageRect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawInRect:graphicsImageRect];

    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetAlpha(ctx, alpha);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage*)createImageWithSize:(CGSize)size tintColor:(UIColor*)color
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage*)resizeImageToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, size}];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}

@end
