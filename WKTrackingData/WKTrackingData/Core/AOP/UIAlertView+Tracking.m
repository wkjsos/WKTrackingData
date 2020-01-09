//
//  UIAlertView+Tracking.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/7.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIAlertView+Tracking.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataViewPathHelper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@implementation UIAlertView (Tracking)

+ (void)wk_enableTracking {
    
    [self wk_swizzleInstanceSelector:@selector(setDelegate:) replaceSelector:@selector(wk_setAlertViewDelegate:)];
}

- (void)wk_setAlertViewDelegate:(id) delegate {
    [self wk_setAlertViewDelegate:delegate];
    
    [delegate wk_swizzleInstanceSelector:@selector(alertView:clickedButtonAtIndex:) fromClass:[self class] replaceSelector:@selector(tracking_alertView:clickedButtonAtIndex:) originNotImp:@selector(tracking_notImp_alertView:clickedButtonAtIndex:)];
}

- (void)tracking_alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [WKTrackingDataViewPathHelper viewPath_alertView:alertView clickedButtonAtIndex:buttonIndex];

    [self tracking_alertView:alertView clickedButtonAtIndex:buttonIndex];
}

#pragma mark - 如果未实现代理

- (void)tracking_notImp_alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [WKTrackingDataViewPathHelper viewPath_alertView:alertView clickedButtonAtIndex:buttonIndex];
}

@end

#pragma clang diagnostic pop

