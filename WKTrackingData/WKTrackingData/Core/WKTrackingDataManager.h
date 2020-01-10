//
//  WKTrackingDataManager.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020年 wkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TrackingData.h"

#define kWKTrackingDataManager [WKTrackingDataManager sharedManager]

typedef enum : NSUInteger {
    WKTrackingDataUploadDefault = 0,            // 默认上传规则，启动时上传，超过内存缓存数量后再次触发上传
    WKTrackingDataUploadOverMemeryCount ,       // 只有触发内存缓存数量时才会上传
    WKTrackingDataUploadFinishLaunched          // 只有启动时上传
} WKTrackingDataUploadType;

@interface WKTrackingDataManager : NSObject

/// 上传规则，默认为WKTrackingDataUploadDefault
@property (nonatomic, assign, readwrite) WKTrackingDataUploadType uploadType ;

/// 内存中缓存数量，默认为30条，超过默认会开启上报，并触发
@property (nonatomic, assign, readwrite) NSUInteger memeryItemCount ;

/// 是否关闭控制器黑名单，默认为NO，黑名单为开启状态
@property (nonatomic, assign, readwrite) BOOL disableViewControllerBlackList ;

/// 会根据uploadType触发上传
/// 注意需要主动调用^remove才能将已消费的trackingDataArray删除
@property (nonatomic, copy, readwrite) void (^uploadTrackingDataTrigger)(NSArray *trackingDataArray , void (^remove)(void)) ;

+ (instancetype)sharedManager;

/// 开启事件统计
- (void)enableTracking;

/// 将产生的trackingData保存下来
/// @param trackingDataDict 不同event所产生的trackingData
- (void)memeryCacheTrackingData:(NSDictionary *) trackingDataDict;

/// 从本地读取缓存数据到内存
- (void)readTrackingDataFromFile ;

/// 将内存中的数据缓存到本地
- (void)fileCacheTrackingData;

@end

FOUNDATION_EXPORT NSString *const kWKTrackingDataEventIDKey;        
FOUNDATION_EXPORT NSString *const kWKTrackingDataEventPathKey;
FOUNDATION_EXPORT NSString *const kWKTrackingDataEventTimeKey;



