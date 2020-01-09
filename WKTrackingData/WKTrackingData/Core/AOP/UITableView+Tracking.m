//
//  UITableView+DelegateHook.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UITableView+Tracking.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataViewPathHelper.h"
#import <objc/runtime.h>

@implementation UITableView (Tracking)

+ (void)wk_enableCellSelectTracking {
    
    [self wk_swizzleInstanceSelector:@selector(setDelegate:) replaceSelector:@selector(wk_setTableViewDelegate:)];
}

- (void)wk_setTableViewDelegate:(id)delegate {
    [self wk_setTableViewDelegate:delegate];
    
    SEL origSel_ = @selector(tableView:didSelectRowAtIndexPath:);
    Method originalMethod = class_getInstanceMethod([delegate class], origSel_);
    
    if (originalMethod) {
        
        [delegate wk_swizzleInstanceSelector:origSel_ fromClass:[self class] replaceSelector:@selector(tracking_tableView:didSelectRowAtIndexPath:)];
    } else {
        
        /**
         如果 UITableView 的 delegate 未实现 tableView:didSelectRowAtIndexPath
         那么 UITableViewCell 发生点击之后，不会再 respondsToSelector tableView:didSelectRowAtIndexPath
         直接给未实现 method 的 SEL 添加实现的方式不再适用，单独处理：
         这里直接选取了 @selector(_selectRowAtIndexPath:animated:scrollPosition:notifyDelegate:) 进行交换
         */
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL privateSel_ = @selector(_selectRowAtIndexPath:animated:scrollPosition:notifyDelegate:);
#pragma clang diagnostic pop
        
        [self wk_swizzleInstanceSelector:privateSel_ replaceSelector:@selector(tracking_selectRowAtIndexPath:animated:scrollPosition:notifyDelegate:)];
    }
}

- (void)tracking_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [WKTrackingDataViewPathHelper viewPath_didSelectItemFrom:tableView forIndexPath:indexPath];

    [self tracking_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 如果未实现代理

- (void)tracking_selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(CGPoint)position notifyDelegate:(id)delegate {
    
    [WKTrackingDataViewPathHelper viewPath_didSelectItemFrom:self forIndexPath:indexPath];

    [self tracking_selectRowAtIndexPath:indexPath animated:animated scrollPosition:position notifyDelegate:delegate];
}

@end
