//
//  WKTrackingDataViewPathHelper.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020 wkj. All rights reserved.
//  组装viewPath的帮助类

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKTrackingDataViewPathHelper : NSObject

/// UIControl事件追踪，根据传入UIControl生成viewpath
/// @param action 当前UIControl对应事件
/// @param to 响应事件的target
/// @param from 当前的UIControl对象
/// @param event 目标事件
+ (void)viewPath_sendAction:(SEL)action to:(nullable id)to from:(nullable id)from forEvent:(nullable UIEvent *)event;

/// gesture事件追踪，根据当前gesture的target以及action生成对应的viewPath
/// @param gestureRecgnizer 当前的UIGestureRecognizer对象
+ (void)viewPath_gestureRecognizer:(UIGestureRecognizer *)gestureRecgnizer;

/// 控制器生命周期追踪
/// @param viewController 当前控制器
/// @param selector 控制器生命周期selector
+ (void)viewPath_viewController:(UIViewController *)viewController actionSel:(SEL)selector ;

/// UITableView or UICollectionView 的 didSelectItem 追踪
/// @param sender 当前的UITableView or UICollectionView
/// @param indexPath 选中的某个indexPath
+ (void)viewPath_didSelectItemFrom:(id)sender forIndexPath:(NSIndexPath *)indexPath;

/// UIAlertAction 点击追踪，根据传入的action，生成viewPath
/// 1、获取到最上层的控制器视图树
/// 2、拼接上action的style以及title
/// @param action 当前的UIAlertAction对象
+ (void)viewPath_alertAction:(UIAlertAction *)action;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/// UIAlertView 的点击追踪
/// @param alertView 当前的UIAlertView对象
/// @param buttonIndex 点击的UIAlertView某个button
+ (void)viewPath_alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger )buttonIndex;

/// UIActionSheet 的点击追踪
/// @param actionSheet 当前的UIActionSheet对象
/// @param buttonIndex 点击的UIActionSheet某个button
+ (void)viewPath_actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger )buttonIndex;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
