//
//  NSObject+TrackingData.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/2.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "NSObject+TrackingData.h"

#import <objc/runtime.h>

@implementation NSObject (TrackingData)

- (NSDictionary *)wk_trackingData {
    return (NSDictionary *)objc_getAssociatedObject(self, @selector(wk_trackingData));
}

- (void)setWk_trackingData:(NSDictionary *)wk_trackingData {
    objc_setAssociatedObject(self, @selector(wk_trackingData), wk_trackingData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
