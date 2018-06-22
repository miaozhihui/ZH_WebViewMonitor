//
//  UIWebView+Monitor.m
//  UIWebViewMonitor
//
//  Created by 苗治会 on 2018/6/13.
//  Copyright © 2018年 苗治会. All rights reserved.
//

#import "UIWebView+Monitor.h"
#import "UIWebViewDelegateHook.h"
#import <objc/runtime.h>

@implementation UIWebView (Monitor)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [super class];
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzledSelector = @selector(p_setDelegate:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)p_setDelegate:(id<UIWebViewDelegate>)delegate {
    [self p_setDelegate:delegate];
    Class delegateClass = [self.delegate class];
    [UIWebViewDelegateHook exchangeUIWebViewDelegateMethod:delegateClass];
}

@end
