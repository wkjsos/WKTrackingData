//
//  UICollectionView+DelegateHook.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020 wkj. All rights reserved.
//  hook了UICollectionView的代理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Tracking)

/// 开启UICollectionView点击事件的追踪，注意UICollectionView的点击追踪只能追踪设置过delegate的
+ (void)wk_enableCellSelectTracking;

@end

NS_ASSUME_NONNULL_END
