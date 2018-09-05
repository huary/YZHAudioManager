//
//  YZHUITextView.h
//  YZHUIAlertViewDemo
//
//  Created by yuan on 2018/8/9.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZHUITextView;

typedef void(^YZHUITextViewTextDidChangeBlock)(YZHUITextView *textView, CGSize textSize);
typedef void(^YZHUITextViewTextSizeDidChangeBlock)(YZHUITextView *textView, CGSize textSize);
typedef void(^YZHUITextViewContentSizeDidChangeBlock)(YZHUITextView *textView, CGSize lastContentSize);

@interface YZHUITextView : UITextView

/* <#注释#> */
@property (nonatomic, strong) NSString *placeholder;

/* <#注释#> */
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

/* <#注释#> */
@property (nonatomic, copy) YZHUITextViewTextDidChangeBlock textChangeBlock;

/* <#注释#> */
@property (nonatomic, copy) YZHUITextViewTextSizeDidChangeBlock textSizeChangeBlock;

/* <#注释#> */
@property (nonatomic, copy) YZHUITextViewContentSizeDidChangeBlock contentSizeChangeBlock;

@end
