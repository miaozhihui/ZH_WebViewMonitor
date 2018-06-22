//
//  UIWebViewDelegateHook.h
//  UIWebViewMonitor
//
//  Created by 苗治会 on 2018/6/13.
//  Copyright © 2018年 苗治会. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIWebViewDelegateHook : NSObject

+ (void)exchangeUIWebViewDelegateMethod:(Class)aClass;

@end
