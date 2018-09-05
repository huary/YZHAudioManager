//
//  UITableViewCell+Operation.m
//  yxx_ios
//
//  Created by victor siu on 17/3/30.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "UITableViewCell+Operation.h"
#import <objc/runtime.h>

static char UITableViewCellOperationKey;

@implementation UITableViewCell (Operation)


-(NSMutableDictionary*)operationDictionary
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &UITableViewCellOperationKey);
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, &UITableViewCellOperationKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

-(void)setOperationDictionary:(NSMutableDictionary*)operationDictionary
{
    objc_setAssociatedObject(self, &UITableViewCellOperationKey, operationDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)addOperation:(NSOperation*)operation forKey:(id)key;
{
    if (operation) {
        [self cancelOperationForKey:key];
        [self.operationDictionary setObject:operation forKey:key];
    }
}

-(void)cancelOperationForKey:(id)key
{
    if (key == nil) {
        return;
    }
    NSOperation *operation = [self.operationDictionary objectForKey:key];
    [operation cancel];
    [self.operationDictionary removeObjectForKey:key];
}

-(void)removeAllOperation
{
    [self.operationDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSOperation *  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [self.operationDictionary removeAllObjects];
    self.operationDictionary = nil;
}

@end
