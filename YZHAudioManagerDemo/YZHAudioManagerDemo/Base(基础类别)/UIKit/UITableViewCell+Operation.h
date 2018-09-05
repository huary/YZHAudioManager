//
//  UITableViewCell+Operation.h
//  yxx_ios
//
//  Created by victor siu on 17/3/30.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Operation)

-(void)addOperation:(NSOperation*)operation forKey:(id)key;

-(void)cancelOperationForKey:(id)key;

-(void)removeAllOperation;

@end
