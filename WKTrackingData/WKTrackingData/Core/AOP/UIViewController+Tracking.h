//
//  UIViewController+AnalyticsReport.h
//  loanCustomer
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020年 wkj. All rights reserved.
//   

#import <UIKit/UIKit.h>

@interface UIViewController (Tracking)

/// 获取到 window 的 rootViewController 最上层控制器
/// 1、如果 rootViewController 为 nav，则返回 nav 的栈顶控制器
/// 2、如果 rootViewController 为 tabbar，则返回 tabbar 的 select，如果 select 为 nav，仍返回栈顶控制器
/// 3、否则返回 rootViewController
+ (UIViewController *)wk_topViewController;

/// 考虑到侧滑手势到一半带来的影响，目前只追踪viewDidAppear和viewDidDisappear
+ (void)wk_enableTracking;

@end
