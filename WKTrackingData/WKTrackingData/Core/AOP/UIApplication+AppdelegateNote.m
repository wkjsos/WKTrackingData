//
//  UIApplication+AppdelegateHook.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/3.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIApplication+AppdelegateNote.h"

#import "WKTrackingDataManager.h"
#import "NSString+Util.h"

@implementation UIApplication (AppdelegateNote)

#pragma mark - public method

+ (void)wk_enableTracking {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (int i = 0; i < [self noteSelectorArray].count; i++) {
            SEL lifeCycleNoteSelector = NSSelectorFromString([self noteSelectorArray][i]);
            NSString *noteName = [self noteStringArray][i];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:lifeCycleNoteSelector name:noteName object:nil];
        }
    });
}

#pragma mark - lifeCycleNote

+ (BOOL)lifeCycleNote_applicationDidFinishLaunchingWithOptions:(NSNotification *)launchOptions {
    
    NSString *eventPath = @"#applicationDidFinishLaunchingWithOptions";
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : eventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : eventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
    
    [kWKTrackingDataManager readTrackingDataFromFile];
    
    return YES;
}

// 即将进入前台
+ (void)lifeCycleNote_applicationWillEnterForeground:(NSNotification *) note {
    
    NSString *eventPath = @"#applicationWillEnterForeground";
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : eventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : eventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

// 已经进入激活状态
+ (void)lifeCycleNote_applicationDidBecomeActive:(NSNotification *) note {
    
    NSString *eventPath = @"#applicationDidBecomeActive";
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : eventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : eventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

// 即将进入后台
+ (void)lifeCycleNote_applicationDidEnterBackground:(NSNotification *) note {

    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    // 正常切换app退出
    NSInteger logoutType = 1;
    
    if (state == UIApplicationStateBackground) {
        
        CGFloat screenBrightness = [[UIScreen mainScreen] brightness];
        
        // 锁屏退出
        if (screenBrightness <= 0.0) {
            logoutType = 2;
        }
    }
    
    NSString *eventPath = [NSString stringWithFormat:@"#applicationDidBecomeActive#EnterBackgroundType=%@" , @(logoutType)];
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : eventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : eventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

+ (void)lifeCycleNote_applicationWillTerminate:(NSNotification *)note {
    
    NSString *eventPath = @"#applicationWillTerminate";
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : eventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : eventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
    
    [kWKTrackingDataManager fileCacheTrackingData];
}

#pragma mark - selector array

+ (NSArray *)noteSelectorArray {
    return @[
        @"lifeCycleNote_applicationDidFinishLaunchingWithOptions:" ,
        @"lifeCycleNote_applicationWillEnterForeground:" ,
        @"lifeCycleNote_applicationDidBecomeActive:" ,
        @"lifeCycleNote_applicationDidEnterBackground:",
        @"lifeCycleNote_applicationWillTerminate:"
    ];
}

+ (NSArray *)noteStringArray {
    return @[
        UIApplicationDidFinishLaunchingNotification ,
        UIApplicationWillEnterForegroundNotification ,
        UIApplicationDidBecomeActiveNotification ,
        UIApplicationDidEnterBackgroundNotification ,
        UIApplicationWillTerminateNotification
    ];
}


@end
