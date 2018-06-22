//
//  SYWebViewMonitor.h
//  UIWebViewMonitor
//
//  Created by 苗治会 on 2018/6/13.
//  Copyright © 2018年 苗治会. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYWebViewMonitor;

@protocol SYWebViewMonitorDelegate <NSObject>

@optional

- (void)webViewMonitor:(SYWebViewMonitor *)webViewMonitor uploadMonitorDataForURL:(NSString *)urlString loadTime:(NSTimeInterval)loadTime;

@end

@interface SYWebViewMonitor : NSObject

@property (nonatomic, weak) id<SYWebViewMonitorDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)startMonitor;

- (void)stopMonitor;

@end
