//
//  UIView+UITableViewCell.m
//  yxx_ios
//
//  Created by victor siu on 17/3/23.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "UIView+UITableViewCell.h"
#import "NSObject+WeakAssociationObject.h"
#import <objc/runtime.h>

static char UIView_UITableViewCell_Key;

@implementation UIView (UITableViewCell)

-(UITableViewCell*)tableViewCell
{
    return self.weakAssociationObject;
}

-(void)setTableViewCell:(UITableViewCell *)tableViewCell
{
    self.weakAssociationObject = tableViewCell;
}

@end
