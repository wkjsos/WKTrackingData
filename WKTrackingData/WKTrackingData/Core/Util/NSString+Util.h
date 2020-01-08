//
//  NSString+Util.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/3.
//  Copyright © 2020 wkj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Util)

/// 将字符串转为MD5
- (NSString *)wk_md5Uppercase;

/// 获取当前时间字符串
+ (NSString *)wk_dateFormartyyyy_Month_DD_HH_mm_ss_S ;

/// 当前时间戳
+ (NSString *)wk_currentTimestamp ;

@end

NS_ASSUME_NONNULL_END
