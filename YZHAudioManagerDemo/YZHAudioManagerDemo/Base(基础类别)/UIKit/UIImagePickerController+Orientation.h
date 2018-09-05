//
//  UIImagePickerController+Orientation.h
//  jszs
//
//  Created by yuan on 2018/3/13.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIInterfaceOrientationMask(^SupportedInterfaceOrientationsBlock)(UIImagePickerController *imagePickerController);

@interface UIImagePickerController (Orientation)

@property (nonatomic, assign) NSUInteger tag;

@property (nonatomic, copy) SupportedInterfaceOrientationsBlock orientationsBlock;

@end
