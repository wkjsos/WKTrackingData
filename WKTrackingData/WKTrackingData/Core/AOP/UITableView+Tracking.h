//
//  UITableView+DelegateHook.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020 wkj. All rights reserved.
//  hook了tableView代理方法

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Tracking)

/// 开启列表点击事件的追踪，注意UITableView的点击追踪只能追踪设置过delegate的
+ (void)wk_enableCellSelectTracking;

@end

NS_ASSUME_NONNULL_END
