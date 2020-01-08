//
//  UIApplication+AppdelegateHook.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/3.
//  Copyright © 2020 wkj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (AppdelegateNote)

/// 开启AppDelegate事件捕获
/// 目前追踪事件有
/// - UIApplicationDidFinishLaunchingNotification、UIApplicationWillEnterForegroundNotification、UIApplicationDidBecomeActiveNotification、UIApplicationDidEnterBackgroundNotification、UIApplicationWillTerminateNotification
+ (void)wk_enableTracking;

@end

NS_ASSUME_NONNULL_END
