//
//  YZHAudioController.h
//  YZHAudioManagerDemo
//
//  Created by yuan on 2018/9/5.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YZHAudioRecordState)
{
    YZHAudioRecordStateNULL         = 0,
    YZHAudioRecordStateRecording    = 1,
    YZHAudioRecordStateCancel       = 2,
    YZHAudioRecordStateCountDown    = 3,
    YZHAudioRecordStateTooShort     = 4,
    YZHAudioRecordStateEnd          = 5,
};


@interface YZHAudioController : NSObject

/* <#name#> */
@property (nonatomic, assign) NSInteger countDown;

/* <#name#> */
@property (nonatomic, assign) NSTimeInterval maxRecordDuration;

-(void)showWithState:(YZHAudioRecordState)state title:(NSString*)title;

-(void)updateRecordViewWithState:(YZHAudioRecordState)recordState title:(NSString*)title;

/*
 *power的范围为0-1
 */
-(void)updateRecordViewWithPower:(CGFloat)power;

-(void)dismiss;

@end
