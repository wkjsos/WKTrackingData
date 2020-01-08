//
//  UIResponder+ViewPath.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/3.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UIResponder+EventPath.h"

@implementation UIResponder (EventPath)

- (NSString *)wk_eventPathIdentifier {

    if (self == nil) {
        return @"";
    }
    
    NSMutableString *viewPath = [NSMutableString string];
    
    UIResponder *responder = self;
    
    do {
        [viewPath appendFormat:@"#%@" , NSStringFromClass([responder class])] ;
        
        if ([responder isKindOfClass:[UIView class]]) {
            
            NSInteger index = [[(UIView *)responder superview].subviews indexOfObject:(UIView *)responder];
            [viewPath appendFormat:@"[%@]" , @(index)];
        }
        
    } while ((responder = [responder nextResponder]));
    
    return viewPath;
}

@end
