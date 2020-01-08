//
//  UIGestureRecognizer+Tracking.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/6.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIGestureRecognizer+Tracking.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataViewPathHelper.h"

@implementation UIGestureRecognizer (Tracking)

+ (void)wk_enableTracking {
    [self wk_swizzleMethod:@selector(addGestureRecognizer:) withMethod:@selector(gestureHook_addGestureRecognizer:)];
}

- (void)gestureHook_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self gestureHook_addGestureRecognizer:gestureRecognizer];
    
    [gestureRecognizer addTarget:self action:@selector(gestureHook_handleGesture:)];
}

- (void)gestureHook_handleGesture:(UIGestureRecognizer*)gestureRecognizer {
    
    [WKTrackingDataViewPathHelper viewPath_gestureRecognizer:gestureRecognizer];
}

@end
