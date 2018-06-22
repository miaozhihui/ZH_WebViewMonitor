//
//  SYWebViewMonitor.m
//  UIWebViewMonitor
//
//  Created by 苗治会 on 2018/6/13.
//  Copyright © 2018年 苗治会. All rights reserved.
//

#import "SYWebViewMonitor.h"
#import "WebViewLoadModel.h"

@interface SYWebViewMonitor ()

/**
 所有网页加载请求字典
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *,WebViewLoadModel *> *loadModelDic;

@end

@implementation SYWebViewMonitor

+ (instancetype)sharedInstance {
    static SYWebViewMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SYWebViewMonitor alloc] init];
    });
    return instance;
}

- (void)startMonitor {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewStartLoad:) name:@"webViewStartLoad" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewFinishLoad:) name:@"webViewFinishLoad" object:nil];

}

- (void)stopMonitor {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.loadModelDic removeAllObjects];
}

- (void)webViewStartLoad:(NSNotification *)notification {
    NSString *urlString = (NSString *)notification.object;
    NSURL *url = [NSURL URLWithString:urlString];
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        WebViewLoadModel *loadModel = [[WebViewLoadModel alloc] init];
        loadModel.urlString = url.absoluteString;
        loadModel.startTime = CFAbsoluteTimeGetCurrent();
        [self.loadModelDic setObject:loadModel forKey:loadModel.urlString];
    }
}

- (void)webViewFinishLoad:(NSNotification *)notification {
    NSString *urlString = (NSString *)notification.object;
    WebViewLoadModel *loadModel = [self.loadModelDic objectForKey:urlString];
    if (loadModel) {
        loadModel.endTime = CFAbsoluteTimeGetCurrent();
        if ([self.delegate respondsToSelector:@selector(webViewMonitor:uploadMonitorDataForURL:loadTime:)]) {
            [self.delegate webViewMonitor:self uploadMonitorDataForURL:loadModel.urlString loadTime:loadModel.loadTime];
        }
        [self.loadModelDic removeObjectForKey:urlString];
    }
}

- (NSMutableDictionary<NSString *,WebViewLoadModel *> *)loadModelDic {
    if (!_loadModelDic) {
        _loadModelDic = [[NSMutableDictionary alloc] init];
    }
    return _loadModelDic;
}

@end
