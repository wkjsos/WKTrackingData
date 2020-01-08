//
//  UIView+GestureHook.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020 wkj. All rights reserved.
//  hook给view添加Gesture的方法

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EventPath)

- (UIViewController *)wk_currentViewController;

@end

NS_ASSUME_NONNULL_END
