//
//  UIWebViewDelegateHook.m
//  UIWebViewMonitor
//
//  Created by 苗治会 on 2018/6/13.
//  Copyright © 2018年 苗治会. All rights reserved.
//

#import "UIWebViewDelegateHook.h"
#import <objc/runtime.h>

@implementation UIWebViewDelegateHook

+ (void)exchangeUIWebViewDelegateMethod:(Class)aClass {
    p_exchangeMethod(aClass, @selector(webView:shouldStartLoadWithRequest:navigationType:), self, @selector(replaced_webView:shouldStartLoadWithRequest:navigationType:));
    p_exchangeMethod(aClass, @selector(webViewDidStartLoad:), self, @selector(replaced_webViewDidStartLoad:));
    p_exchangeMethod(aClass, @selector(webViewDidFinishLoad:), self, @selector(replaced_webViewDidFinishLoad:));
    p_exchangeMethod(aClass, @selector(webView:didFailLoadWithError:), self, @selector(replaced_webView:didFailLoadWithError:));
}

- (BOOL)replaced_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestURL = nil;
    NSString *requestString = request.URL.absoluteString;
    if (requestString) {
        NSRange range = [requestString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            requestURL = [requestString substringToIndex:range.location];
        } else {
            requestURL = requestString;
        }
    } else {
        requestURL = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewStartLoad" object:requestURL];
    return [self replaced_webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)replaced_webViewDidStartLoad:(UIWebView *)webView {
    if (!webView.request.URL.absoluteString) {
        NSString *requestURL = nil;
        NSString *requestString = webView.request.URL.absoluteString;
        NSRange range = [requestString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            requestURL = [requestString substringToIndex:range.location];
        } else {
            requestURL = requestString;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewStartLoad" object:requestURL];
    }
    [self replaced_webViewDidStartLoad:webView];
}

- (void)replaced_webViewDidFinishLoad:(UIWebView *)webView {
    NSString *requestURL = nil;
    NSString *requestString = webView.request.URL.absoluteString;
    NSRange range = [requestString rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        requestURL = [requestString substringToIndex:range.location];
    } else {
        requestURL = requestString;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewFinishLoad" object:requestURL];
    [self replaced_webViewDidFinishLoad:webView];
}

- (void)replaced_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *requestURL = nil;
    NSString *requestString = webView.request.URL.absoluteString;
    NSRange range = [requestString rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        requestURL = [requestString substringToIndex:range.location];
    } else {
        requestURL = requestString;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewFinishLoad" object:requestURL];
    [self replaced_webView:webView didFailLoadWithError:error];
}

static void p_exchangeMethod(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel) {
    static NSMutableArray *classList = nil;
    if (classList == nil) {
        classList = [NSMutableArray array];
    }
    NSString *className = [NSString stringWithFormat:@"%@_%@",NSStringFromClass(originalClass),NSStringFromSelector(originalSel)];
    for (NSString *item in classList) {
        if ([className isEqualToString:item]) {
            return;
        }
    }
    [classList addObject:className];
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method replacedMethod = class_getInstanceMethod(replacedClass, replacedSel);
    IMP replacedMethodIMP = method_getImplementation(replacedMethod);
    class_addMethod(originalClass, replacedSel, replacedMethodIMP, method_getTypeEncoding(replacedMethod));
    Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

@end
