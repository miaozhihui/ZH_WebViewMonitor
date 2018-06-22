//
//  ViewController.m
//  UIWebViewMonitor
//
//  Created by 苗治会 on 2018/6/13.
//  Copyright © 2018年 苗治会. All rights reserved.
//

#import "ViewController.h"
#import "H5VC.h"
#import "SYWebViewMonitor.h"

@interface ViewController ()<SYWebViewMonitorDelegate>

@property (nonatomic, strong) UIButton *secondBtn;

@property (nonatomic, strong) SYWebViewMonitor *monitor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.monitor = [SYWebViewMonitor sharedInstance];
    self.monitor.delegate = self;
    [self.monitor startMonitor];
    
    self.secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondBtn setTitle:@"点击" forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.secondBtn.backgroundColor = [UIColor yellowColor];
    self.secondBtn.frame = CGRectMake(150, 150, 100, 100);
    [self.secondBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.secondBtn];
}

- (void)click {
    H5VC *vc = [[H5VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webViewMonitor:(SYWebViewMonitor *)webViewMonitor uploadMonitorDataForURL:(NSString *)urlString loadTime:(NSTimeInterval)loadTime {
    // 上报数据
    NSLog(@"监控的URL为：%@----------加载时间为：%f",urlString,loadTime);
}

@end
