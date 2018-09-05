//
//  UIImage+TintColor.h
//  YZHUINavigationController
//
//  Created by yuan on 2018/4/27.
//  Copyright © 2018年 dlodlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TintColor)

-(UIImage*)tintColor:(UIColor*)color;

-(UIImage*)tintColor:(UIColor*)color alpha:(CGFloat)alpha inRect:(CGRect)rect;

-(UIImage*)createImageWithSize:(CGSize)size tintColor:(UIColor*)color;

-(UIImage*)resizeImageToSize:(CGSize)size;

@end
