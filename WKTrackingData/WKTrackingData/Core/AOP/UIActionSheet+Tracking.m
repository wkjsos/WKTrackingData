//
//  UIActionSheet+Tracking.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/7.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIActionSheet+Tracking.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataViewPathHelper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@implementation UIActionSheet (Tracking)

+ (void)wk_enableTracking {
    
    [self wk_swizzleInstanceSelector:@selector(setDelegate:) replaceSelector:@selector(wk_setActionSheetDelegate:)];
}

- (void)wk_setActionSheetDelegate:(id) delegate {
    [self wk_setActionSheetDelegate:delegate];
    
    [delegate wk_swizzleInstanceSelector:@selector(actionSheet:clickedButtonAtIndex:) fromClass:[self class] replaceSelector:@selector(delegateTracking_actionSheet:clickedButtonAtIndex:) originNotImp:@selector(delegateTracking_notImp_actionSheet:clickedButtonAtIndex:)];
}

- (void)delegateTracking_actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [WKTrackingDataViewPathHelper viewPath_actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];

    [self delegateTracking_actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
}

#pragma mark - 如果未实现代理

- (void)delegateTracking_notImp_actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [WKTrackingDataViewPathHelper viewPath_actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
}

@end

#pragma clang diagnostic pop
