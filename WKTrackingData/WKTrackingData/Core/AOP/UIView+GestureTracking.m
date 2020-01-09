//
//  UIView+GestureTracking.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/8.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIView+GestureTracking.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataViewPathHelper.h"

@implementation UIView (GestureTracking)

+ (void)wk_enableTracking {

    [self wk_swizzleInstanceSelector:@selector(addGestureRecognizer:) replaceSelector:@selector(gestureHook_addGestureRecognizer:)];
}

- (void)gestureHook_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self gestureHook_addGestureRecognizer:gestureRecognizer];
    
    [gestureRecognizer addTarget:self action:@selector(gestureHook_handleGesture:)];
}

- (void)gestureHook_handleGesture:(UIGestureRecognizer*)gestureRecognizer {
    
    [WKTrackingDataViewPathHelper viewPath_gestureRecognizer:gestureRecognizer];
}

@end
