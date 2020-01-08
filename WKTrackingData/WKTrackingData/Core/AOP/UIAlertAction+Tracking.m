//
//  UIAlertAction+Tracking.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/7.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIAlertAction+Tracking.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataViewPathHelper.h"

typedef void (^WKActionHandler)(UIAlertAction *action);

@implementation UIAlertAction (Tracking)

+ (void)wk_enableTracking {
    [self wk_swizzleClassMethod:@selector(actionWithTitle:style:handler:) withClassMethod:@selector(wk_actionWithTitle:style:handler:)];
}

+ (instancetype)wk_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler {
    
    // 追踪UIAlertAction的点击事件，需要替换其handler
    WKActionHandler actionHandler = ^(UIAlertAction *action) {
        handler ? handler(action) : nil;
        [WKTrackingDataViewPathHelper viewPath_alertAction:action];
    };
    
    UIAlertAction *alertAction = [[self class] wk_actionWithTitle:title style:style handler:actionHandler];
    
    return alertAction;
}

@end
