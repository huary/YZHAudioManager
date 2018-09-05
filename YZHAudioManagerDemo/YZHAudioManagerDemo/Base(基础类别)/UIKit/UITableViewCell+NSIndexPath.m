//
//  UITableViewCell+NSIndexPath.m
//  yxx_ios
//
//  Created by yuan on 2017/4/15.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "UITableViewCell+NSIndexPath.h"
#import <objc/runtime.h>

static void *ptr_UITableViewCell_NSIndexPath_Key;

@implementation UITableViewCell (NSIndexPath)

-(void)setIndexPath:(NSIndexPath *)indexPath
{
//    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    objc_setAssociatedObject(self, ptr_UITableViewCell_NSIndexPath_Key, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSIndexPath*)indexPath
{
    return objc_getAssociatedObject(self, ptr_UITableViewCell_NSIndexPath_Key);
}

@end
