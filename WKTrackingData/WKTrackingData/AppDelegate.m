//
//  AppDelegate.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/2.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "AppDelegate.h"
#import "WKTrackingDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [kWKTrackingDataManager enableTracking];
    
    return YES;
}



@end
