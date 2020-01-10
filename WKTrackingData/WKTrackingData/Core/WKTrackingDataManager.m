//
//  WKTrackingDataManager.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020年 wkj. All rights reserved.
//

#import "WKTrackingDataManager.h"

#import "UIApplication+AppdelegateNote.h"
#import "UIApplication+UIControlEventPath.h"
#import "UITableView+Tracking.h"
#import "UICollectionView+Tracking.h"
#import "UIViewController+Tracking.h"
#import "UIView+GestureTracking.h"
#import "UIAlertAction+Tracking.h"
#import "UIAlertView+Tracking.h"
#import "UIActionSheet+Tracking.h"

#import "NSString+Util.h"

NSString *const kTrackingDataCachePath = @"WKData";

@interface WKTrackingDataManager()

@property (nonatomic, strong) NSMutableArray *trackingDataArrayM ;

@property (nonatomic, strong) NSArray *tempUploadDataArray ;

@property (nonatomic, copy) void (^removeUploadTrackingData)(void) ;

@end

@implementation WKTrackingDataManager

+ (instancetype)sharedManager {
    static WKTrackingDataManager *trackingDataManager;
    static dispatch_once_t onceToken;
    
    // thinking: why here is no retaincycle?
    dispatch_once(&onceToken, ^{
        trackingDataManager = [[WKTrackingDataManager alloc] init];
        trackingDataManager.memeryItemCount = 30;
        trackingDataManager.uploadType = WKTrackingDataUploadDefault;
        trackingDataManager.removeUploadTrackingData = ^{
            [trackingDataManager.trackingDataArrayM removeObjectsInArray:trackingDataManager.tempUploadDataArray];
        };
    });
    return trackingDataManager;
}

#pragma mark - public method

- (void)enableTracking {
    [UIApplication wk_enableTracking];
    [UIApplication wk_enableUIControlTracking];
    
    [UITableView wk_enableCellSelectTracking];
    [UICollectionView wk_enableCellSelectTracking];
    
    [UIViewController wk_enableTracking];
    [UIView wk_enableTracking];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    [UIAlertAction wk_enableTracking];
    [UIAlertView wk_enableTracking];
    [UIActionSheet wk_trackingData];
#pragma clang diagnostic pop
}

- (void)memeryCacheTrackingData:(NSDictionary *) trackingDataDict {
    
    [self.trackingDataArrayM addObject:trackingDataDict];
        
    [self trackingUploadOrNot];
}

- (void)readTrackingDataFromFile {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *tmpPath = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            
        NSString *trackingDataPath = [NSString stringWithFormat:@"%@/%@",tmpPath ,kTrackingDataCachePath];
         
         BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:trackingDataPath];
         
         if (!fileExist) {
             return;
         }
         
         NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:trackingDataPath error:NULL];
                         
         [contentOfFolder enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             
             NSString *fullPath = [trackingDataPath stringByAppendingPathComponent:obj];
             
             BOOL isDir = NO;
             
             if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir) {
                 *stop = YES;
                 NSArray *tempTrackingDataArray = [NSArray arrayWithContentsOfFile:fullPath];
                 
                 if (tempTrackingDataArray) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.trackingDataArrayM addObjectsFromArray:tempTrackingDataArray];
                         [self trackingUploadOrNot];
                     });
                 }
             }
         }];
    });
}

- (void)fileCacheTrackingData {
    
    NSString *doucmentPath = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *trackingDataPath = [NSString stringWithFormat:@"%@/%@",doucmentPath ,kTrackingDataCachePath];
    
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:trackingDataPath];
        
    if (!fileExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:trackingDataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",trackingDataPath,[NSString wk_dateFormartyyyy_Month_DD_HH_mm_ss_S]];
    
    [self.trackingDataArrayM writeToFile:fileName atomically:YES];
}

#pragma mark - private method

- (void)trackingUploadOrNot {
    
    if (self.trackingDataArrayM.count > self.memeryItemCount) {
        NSLog(@"over memeryItemCount, u can upload");
        switch (self.uploadType) {
            case WKTrackingDataUploadDefault:
            case WKTrackingDataUploadOverMemeryCount:
                [self beginUploadTrackingData];
                break;
            case WKTrackingDataUploadFinishLaunched:
                break;
        }
    }
}

- (void)beginUploadTrackingData {
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.memeryItemCount)];
    
    self.tempUploadDataArray = [self.trackingDataArrayM objectsAtIndexes:indexSet];
    
    self.uploadTrackingDataTrigger ? self.uploadTrackingDataTrigger(self.tempUploadDataArray , self.removeUploadTrackingData) : nil;
}

#pragma mark - getter

- (NSMutableArray *)trackingDataArrayM {
    if (!_trackingDataArrayM) {
        _trackingDataArrayM = [NSMutableArray array];
    }
    return _trackingDataArrayM;
}

@end

NSString *const kWKTrackingDataEventIDKey   = @"event_id";
NSString *const kWKTrackingDataEventPathKey = @"event_path";
NSString *const kWKTrackingDataEventTimeKey = @"event_time";

