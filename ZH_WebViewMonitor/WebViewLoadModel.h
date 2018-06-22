//
//  WebViewLoadModel.h
//  UIWebViewMonitor
//
//  Created by 苗治会 on 2018/6/13.
//  Copyright © 2018年 苗治会. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewLoadModel : NSObject

/**
 网页加载链接
 */
@property (nonatomic, copy) NSString *urlString;

/**
 网页加载开始时间
 */
@property (nonatomic, assign) NSTimeInterval startTime;

/**
 网页加载结束时间
 */
@property (nonatomic, assign) NSTimeInterval endTime;

/**
 加载所用时间
 */
@property (nonatomic, readonly, assign) NSTimeInterval loadTime;

@end
