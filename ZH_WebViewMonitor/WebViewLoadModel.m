//
//  WebViewLoadModel.m
//  UIWebViewMonitor
//
//  Created by 苗治会 on 2018/6/13.
//  Copyright © 2018年 苗治会. All rights reserved.
//

#import "WebViewLoadModel.h"

@implementation WebViewLoadModel

- (NSTimeInterval)loadTime {
    if (self.startTime != 0 && self.endTime != 0) {
        return self.endTime - self.startTime;
    }
    return 0;
}

@end
