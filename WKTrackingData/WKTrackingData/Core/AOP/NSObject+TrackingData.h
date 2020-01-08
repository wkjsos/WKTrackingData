//
//  NSObject+TrackingData.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/2.
//  Copyright © 2020 wkj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TrackingData)

/// 用于生成view_path时的额外拼接参数，key-value由业务方自定义。
/// Dictionary中的key-value最终会拼接到view_path后
/// 原view_path为：#viewController#view#label.....
/// 实现了trackingDataDictionary后，view_path拼接为：#viewController#view#label?key1=value1&key2=value2
@property (nonatomic, strong) NSDictionary *wk_trackingData ;

@end

NS_ASSUME_NONNULL_END
