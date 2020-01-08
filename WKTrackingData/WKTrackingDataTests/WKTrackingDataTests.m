//
//  WKTrackingDataTests.m
//  WKTrackingDataTests
//
//  Created by wkj on 2020/1/2.
//  Copyright © 2020 wkj. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WKTrackingDataManager.h"

@interface WKTrackingDataTests : XCTestCase

@end

@implementation WKTrackingDataTests

- (void)testExample {
    
    [WKTrackingDataManager sharedTrackingDataManager].needUploadTrackingData = ^(NSArray *trackingDataArray, void (^remove)(void)) {
        NSLog(@"trackingDataArray");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            remove ? remove() : nil;
        });
    };
    
    for (int i = 0; i < 30; i++) {
        [[WKTrackingDataManager sharedTrackingDataManager] cacheTrackingData:@{
            [NSString stringWithFormat:@"key:%@" , @(i)] : [NSString stringWithFormat:@"value:%@" , @(i)]
        }];
    }
}


@end
