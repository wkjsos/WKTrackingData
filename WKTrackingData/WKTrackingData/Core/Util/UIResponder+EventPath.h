//
//  UIResponder+ViewPath.h
//  WKTrackingData
//
//  Created by wkj on 2020/1/3.
//  Copyright © 2020 wkj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (EventPath)

- (NSString *)wk_eventPathIdentifier ;

@end

NS_ASSUME_NONNULL_END
