//
//  ViewController.m
//  YZHAudioManagerDemo
//
//  Created by yuan on 2018/9/4.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import "ViewController.h"
#import "YZHAudioController.h"
#import "YZHUIButton.h"
#import "YZHAudioManager.h"

static CGFloat maxRecorderFileDuration_s = 10.0;
static CGFloat minRecorderFileDuration_s = 1.0;
static CGFloat showRemRecorderDuaration_s = 3.0;

@interface ViewController () <YZHAudioManagerDelegate>

/* <#注释#> */
@property (nonatomic, strong) YZHAudioController *audioController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupChildView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)_setupChildView
{
    self.view.backgroundColor = WHITE_COLOR;
//    NSLog(@"screenBounds=%@",NSStringFromCGRect(SCREEN_BOUNDS));
    
    CGFloat x = 20;
    CGFloat h = 100;
    CGFloat y = SCREEN_HEIGHT - h;
    CGFloat w = SCREEN_WIDTH - 2 * x;
    UIColor *color = RGB_WITH_INT_WITH_NO_ALPHA(0X666666);
    YZHUIButton *recodeBtn = [YZHUIButton buttonWithType:UIButtonTypeCustom];
    recodeBtn.frame = CGRectMake(x, y, w, h);
    [recodeBtn setTitleColor:color forState:UIControlStateNormal];
    [recodeBtn setTitle:NSLOCAL_STRING(@"按住录音") forState:UIControlStateNormal];
    recodeBtn.layer.cornerRadius = 3.0;
    recodeBtn.layer.borderWidth = SINGLE_LINE_WIDTH * SCREEN_SCALE;
    recodeBtn.layer.borderColor = color.CGColor;
    [self.view addSubview:recodeBtn];
    
    WEAK_SELF(weakSelf);
    recodeBtn.beginTrackingBlock = ^BOOL(YZHUIButton *button, UITouch *touch, UIEvent *event) {
        return [weakSelf _beginTrackingAction:button touch:touch event:event];
    };
    
    recodeBtn.continueTrackingBlock = ^BOOL(YZHUIButton *button, UITouch *touch, UIEvent *evnet) {
        return [weakSelf _continueTrackingAction:button touch:touch event:evnet];
    };
    
    recodeBtn.endTrackingBlock = ^(YZHUIButton *button, UITouch *touch, UIEvent *event) {
        [weakSelf _endTrackingAction:button touch:touch event:event];
    };
    
    self.audioController = [[YZHAudioController alloc] init];
    self.audioController.maxRecordDuration = maxRecorderFileDuration_s;
    self.audioController.countDown =  (NSInteger)showRemRecorderDuaration_s;
}

-(BOOL)_beginTrackingAction:(UIButton*)button touch:(UITouch*)touch event:(UIEvent*)event
{
    NSLog(@"%s",__FUNCTION__);
    CGPoint pt = [touch locationInView:button];
    if (!CGRectContainsPoint(button.bounds, pt)) {
        return NO;
    }
    NSString *fileName = NEW_STRING_WITH_FORMAT(@"%@.wav",@"test");
    NSString *filePath = NSTemporaryDirectory();
    filePath = [filePath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    
    [[YZHAudioManager shareAudioManager] startRecordWithFilePath:filePath duration:maxRecorderFileDuration_s];
    [YZHAudioManager shareAudioManager].delegate = self;
    
    [self.audioController showWithState:YZHAudioRecordStateNULL title:@"手指上滑，取消发送"];
    
    button.layer.borderColor = PROJ_MAIN_COLOR.CGColor;
    return YES;
}

-(BOOL)_continueTrackingAction:(UIButton*)button touch:(UITouch*)touch event:(UIEvent*)event
{
    CGPoint pt = [touch locationInView:button];
    if (CGRectContainsPoint(button.bounds, pt)) {
        [self.audioController updateRecordViewWithState:YZHAudioRecordStateRecording title:@"手指上滑，取消发送"];
    }
    else {
        [self.audioController updateRecordViewWithState:YZHAudioRecordStateCancel title:@"松开手指，取消发送"];
    }
    button.layer.borderColor = PROJ_MAIN_COLOR.CGColor;
    return YES;
}

-(void)_endTrackingAction:(UIButton*)button touch:(UITouch*)touch event:(UIEvent*)event
{
    if ([[YZHAudioManager shareAudioManager] recordDuration] < minRecorderFileDuration_s) {
        [YZHAudioManager shareAudioManager].delegate = nil;
        [self.audioController updateRecordViewWithState:YZHAudioRecordStateTooShort title:NSLOCAL_STRING(@"录音时间太短")];
    }
    else {
        if (self.audioController.recordState == YZHAudioRecordStateCancel) {
            [YZHAudioManager shareAudioManager].delegate = nil;
        }
        [self.audioController updateRecordViewWithState:YZHAudioRecordStateEnd title:nil];
    }
    [[YZHAudioManager shareAudioManager] endRecord];
    button.layer.borderColor = RGB_WITH_INT_WITH_NO_ALPHA(0X666666).CGColor;
    [YZHAudioManager shareAudioManager].delegate = self;
}



#pragma mark - delegate
-(float)_getAveragePower
{
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -40.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels = [[YZHAudioManager shareAudioManager].audioRecorder averagePowerForChannel:0];
//    float   peakPower = [[YZHAudioManager shareAudioManager].audioRecorder peakPowerForChannel:0];
    //    NSLog(@"decibels=%f,peakPower=%f",decibels,peakPower);
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        level = powf(adjAmp, 1.0f / root);
        
    }
    float power = level * 120 / 100;
    return power;
}

-(void)audioManager:(YZHAudioManager *)audioManager audioRecorderUpdateMeters:(float)meters
{
    float power = [self _getAveragePower];
    [self.audioController updateRecordViewWithPower:power];
}

-(void)audioManager:(YZHAudioManager *)audioManager endRecordFilePath:(NSString *)filePath duration:(NSTimeInterval)duration
{
}

-(void)audioManager:(YZHAudioManager *)audioManager endPlayURL:(NSURL *)URL duration:(NSTimeInterval)duration
{
}

-(UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return UIRectEdgeBottom;
}

@end
