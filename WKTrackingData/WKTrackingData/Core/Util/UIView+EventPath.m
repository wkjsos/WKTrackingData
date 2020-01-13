//
//  UIView+EventPath.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIView+EventPath.h"

@implementation UIView (EventPath)

#pragma mark - helper

- (UIViewController *)wk_currentViewController {
    
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end
