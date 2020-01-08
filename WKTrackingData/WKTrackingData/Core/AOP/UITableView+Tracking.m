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
    [self wk_swizzleMethod:@selector(setDelegate:) withMethod:@selector(wk_setTableViewDelegate:)];
}

- (void)wk_setTableViewDelegate:(id)delegate {
    [self wk_setTableViewDelegate:delegate];
    
    [NSObject wk_swizzlingDelegate:[delegate class] originSel:@selector(tableView:didSelectRowAtIndexPath:) replacedClass:[self class] replaceSel:@selector(tracking_tableView:didSelectRowAtIndexPath:) delegateNotImp:@selector(tracking_notImp_tableView:didSelectRowAtIndexPath:)];
}

- (void)tracking_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [WKTrackingDataViewPathHelper viewPath_didSelectItemFrom:tableView forIndexPath:indexPath];

    [self tracking_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 如果未实现代理

- (void)tracking_notImp_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [WKTrackingDataViewPathHelper viewPath_didSelectItemFrom:tableView forIndexPath:indexPath];
}

@end
