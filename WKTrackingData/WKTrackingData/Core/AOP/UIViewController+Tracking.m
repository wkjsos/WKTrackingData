//
//  UIViewController+AnalyticsReport.m
//  loanCustomer
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020年 wkj. All rights reserved.
//

#import "UIViewController+Tracking.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataManager.h"
#import "WKTrackingDataViewPathHelper.h"

@implementation UIViewController (Tracking)

#pragma mark - helper

+ (UIViewController *)wk_topViewController {
    
    UIViewController *rootViewController = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        return [(UINavigationController *)rootViewController topViewController];
        
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]){
        
        UIViewController *selectViewController = [(UITabBarController *)rootViewController selectedViewController];
        
        if ([selectViewController isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController *)selectViewController topViewController];
        }else{
            return selectViewController;
        }
    } else {
        return rootViewController;
    }
}

#pragma mark - Tracking config

+ (void)wk_enableTracking {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self wk_swizzleInstanceSelector:@selector(viewDidAppear:) replaceSelector:@selector(wk_tracking_viewDidAppear:)];
        [self wk_swizzleInstanceSelector:@selector(viewDidDisappear:) replaceSelector:@selector(wk_tracking_viewDidDisappear:)];
    });
}

#pragma mark - swizzled method

- (void)wk_tracking_viewDidAppear:(BOOL)animated{
    
    [self wk_tracking_viewDidAppear:animated];
    
    if (!kWKTrackingDataManager.disableViewControllerBlackList && [self isContainBlackList]) {
        return;
    }
    
    [WKTrackingDataViewPathHelper viewPath_viewController:self actionSel:@selector(viewDidAppear:)];
}

- (void)wk_tracking_viewDidDisappear:(BOOL)animated{

    [self wk_tracking_viewDidDisappear:animated];
    
    if (!kWKTrackingDataManager.disableViewControllerBlackList && [self isContainBlackList]) {
        return;
    }
    
    [WKTrackingDataViewPathHelper viewPath_viewController:self actionSel:@selector(viewDidDisappear:)];
}

#pragma mark - private method

- (BOOL)isContainBlackList {
    
    static NSSet *publicIgnoredClasses = nil;
    static NSSet *privateIgnoredClasses = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *bundlePath = [[NSBundle bundleForClass:NSClassFromString(@"WKTrackingDataManager")] pathForResource:@"WKTrackingData" ofType:@"bundle"];
        
        NSBundle *sensorsBundle = [NSBundle bundleWithPath:bundlePath];
        
        NSString *jsonPath = [sensorsBundle pathForResource:@"viewcontroller_blacklist.json" ofType:nil];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
        @try {
            NSDictionary *ignoredJsonClasses = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingAllowFragments  error:nil];
            publicIgnoredClasses = [NSSet setWithArray:ignoredJsonClasses[@"public"]];
            privateIgnoredClasses = [NSSet setWithArray:ignoredJsonClasses[@"private"]];
        } @catch(NSException *exception) {
            NSLog(@"%@ error: %@" , self , exception);
        }
    });
    
    // check ignored classes contains viewController or not
    for (NSString *ignoreClass in publicIgnoredClasses) {
        if ([self isKindOfClass:NSClassFromString(ignoreClass)]) {
            return YES;
        }
    }
    
    for (NSString *ignoreClass in privateIgnoredClasses) {
        if ([self isKindOfClass:NSClassFromString(ignoreClass)]) {
            return YES;
        }
    }
    
    return NO;
}

@end
