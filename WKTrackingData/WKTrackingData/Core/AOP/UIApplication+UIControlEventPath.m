//
//  UIApplication+UIControlEventPath.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/6.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIApplication+UIControlEventPath.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataViewPathHelper.h"

@implementation UIApplication (UIControlEventPath)

+ (void)wk_enableUIControlTracking {
    
    [self wk_swizzleInstanceSelector:@selector(sendAction:to:from:forEvent:) replaceSelector:@selector(wk_sendAction:to:from:forEvent:)];
}

- (BOOL)wk_sendAction:(SEL)action
                   to:(nullable id)to
                 from:(nullable id)from
             forEvent:(nullable UIEvent *)event {
    
    // 暂时只追踪UIResponder事件，忽略 UIBarItem 和 UINavigationItem
    if ([from isKindOfClass:[UIResponder class]]) {

        // UITabBarButton 会多次触发，只统计无 event 传入的事件
        if ([from isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (!event) {
                [WKTrackingDataViewPathHelper viewPath_sendAction:action to:to from:from forEvent:event];
            }
            
        } else {
            [WKTrackingDataViewPathHelper viewPath_sendAction:action to:to from:from forEvent:event];
        }
    }
    
    return [self wk_sendAction:action to:to from:from forEvent:event];
}


@end
