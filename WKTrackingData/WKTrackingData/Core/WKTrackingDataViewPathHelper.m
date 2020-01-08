//
//  WKTrackingDataViewPathHelper.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "WKTrackingDataViewPathHelper.h"
#import "WKTrackingDataManager.h"

#import "NSString+Util.h"

#import "NSObject+TrackingData.h"
#import "UIView+EventPath.h"
#import "UIResponder+EventPath.h"
#import "UIViewController+Tracking.h"

@implementation WKTrackingDataViewPathHelper

#pragma mark - public method

+ (void)viewPath_sendAction:(SEL)action to:(nullable id)to from:(nullable id)from forEvent:(nullable UIEvent *)event {
    
    NSMutableString *eventPathM = [NSMutableString string];

    [eventPathM appendString:[NSString stringWithFormat:@"#%@",NSStringFromSelector(action)]];
    [eventPathM appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([from class])]];
    
    [eventPathM appendString:[from wk_eventPathIdentifier]];
    
    NSString *finalEventPath = [self combineTrackingDataFromSender:from path:eventPathM];
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : finalEventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : finalEventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

+ (void)viewPath_gestureRecognizer:(UIGestureRecognizer *)gestureRecgnizer {
    
    if (gestureRecgnizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    NSMutableString *eventPathM = [[NSMutableString alloc] init];
    
    [eventPathM appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([gestureRecgnizer class])]];

    [eventPathM appendString:gestureRecgnizer.view.wk_eventPathIdentifier];
    
    NSString *finalEventPath = [self combineTrackingDataFromSender:gestureRecgnizer.view path:eventPathM];
    
    NSLog(@"viewPath_gestureRecognizer:%@" , finalEventPath);

    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : finalEventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : finalEventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

+ (void)viewPath_viewController:(UIViewController *)viewController actionSel:(SEL)selector {
    
    NSMutableString *eventPathM = [[NSMutableString alloc] init];
    [eventPathM appendFormat:@"#%@",NSStringFromSelector(selector)];
    [eventPathM appendString:viewController.wk_eventPathIdentifier];
    
    NSString *finalEventPath = [self combineTrackingDataFromSender:viewController path:eventPathM];

    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : finalEventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : finalEventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

+ (void)viewPath_didSelectItemFrom:(id)sender forIndexPath:(NSIndexPath *) indexPath {
    
    NSMutableString *eventPathM = [NSMutableString string];
    
    NSObject *target = nil;
    
    if ([sender isKindOfClass:[UITableView class]]) {
        
        UITableViewCell *tableCell = [(UITableView *)sender cellForRowAtIndexPath:indexPath];
        [eventPathM appendString:tableCell.wk_eventPathIdentifier];
        target = tableCell;
        
    } else if ([sender isKindOfClass:[UICollectionView class]]){
        
        UICollectionViewCell *collectionCell = [(UICollectionView *)sender cellForItemAtIndexPath:indexPath];
        [eventPathM appendString:collectionCell.wk_eventPathIdentifier];
        target = collectionCell;
    }
    
    [eventPathM appendFormat:@"#section=%@#item=%@", @(indexPath.section), @(indexPath.item)];
    
    NSString *finalEventPath = [self combineTrackingDataFromSender:target path:eventPathM];
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : finalEventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : finalEventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

+ (void)viewPath_alertAction:(UIAlertAction *)action {
    
    NSMutableString *eventPathM = [NSMutableString string];
    
    [eventPathM appendFormat:@"topVc_%@", [UIViewController wk_topViewController].wk_eventPathIdentifier];
    
    [eventPathM appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([action class])]];
    
    switch (action.style) {
        case UIAlertActionStyleDefault:
            [eventPathM appendString:@"#UIAlertActionStyleDefault"];
            break;
        case UIAlertActionStyleCancel:
            [eventPathM appendString:@"#UIAlertActionStyleCancel"];
            break;
        case UIAlertActionStyleDestructive:
            [eventPathM appendString:@"#UIAlertActionStyleDestructive"];
            break;
        default:
            break;
    }
    
    [eventPathM appendString:[NSString stringWithFormat:@"#title=%@",action.title]];
    
    NSString *finalEventPath = [self combineTrackingDataFromSender:action path:eventPathM];
    
    NSLog(@"viewPath_alertAction:%@" , finalEventPath);

    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : finalEventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : finalEventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (void)viewPath_alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger )buttonIndex {
    
    NSMutableString *eventPathM = [NSMutableString string];
    
    [eventPathM appendString:[alertView wk_eventPathIdentifier]];
    
    [eventPathM appendFormat:@"#title=%@" , alertView.title];
    [eventPathM appendFormat:@"#message=%@" , alertView.message];
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    [eventPathM appendFormat:@"#buttonTitle=%@" , buttonTitle];
    [eventPathM appendFormat:@"#buttonIndex=%@" , @(buttonIndex)];

    NSString *finalEventPath = [self combineTrackingDataFromSender:alertView path:eventPathM];
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : finalEventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : finalEventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

+ (void)viewPath_actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger )buttonIndex {
    NSMutableString *eventPathM = [NSMutableString string];
    
    [eventPathM appendString:[actionSheet wk_eventPathIdentifier]];
    [eventPathM appendFormat:@"#title=%@" , actionSheet.title];
    
    NSString *actionSheetStyle = @"";
    
    switch (actionSheet.actionSheetStyle) {
        case UIActionSheetStyleAutomatic:
            actionSheetStyle = @"UIActionSheetStyleAutomatic";
            break;
        case UIActionSheetStyleDefault:
            actionSheetStyle = @"UIActionSheetStyleDefault";
            break;
        case UIActionSheetStyleBlackTranslucent:
            actionSheetStyle = @"UIActionSheetStyleBlackTranslucent";
            break;
        case UIActionSheetStyleBlackOpaque:
            actionSheetStyle = @"UIActionSheetStyleBlackOpaque";
            break;
    }
    
    [eventPathM appendFormat:@"#actionSheetStyle=%@" , actionSheetStyle];
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    [eventPathM appendFormat:@"#buttonTitle=%@" , buttonTitle];
    [eventPathM appendFormat:@"#buttonIndex=%@" , @(buttonIndex)];

    NSString *finalEventPath = [self combineTrackingDataFromSender:actionSheet path:eventPathM];
        
    [kWKTrackingDataManager memeryCacheTrackingData:@{
        kWKTrackingDataEventIDKey : finalEventPath.wk_md5Uppercase,
        kWKTrackingDataEventPathKey : finalEventPath,
        kWKTrackingDataEventTimeKey : [NSString wk_currentTimestamp]
    }];
}

#pragma clang diagnostic pop

#pragma mark - private method

/// 将业务方自定义业务参数拼接到event_path里
/// @param sender 带业务参数的目标
/// @param eventPathM 源event_path
+ (NSString *)combineTrackingDataFromSender:(NSObject *) sender path:(NSMutableString *) eventPathM {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton *)sender;
        
        [eventPathM appendFormat:@"#currentTitle=%@" , button.currentTitle];
        [eventPathM appendFormat:@"#state=%@" , @(button.state)];
        [eventPathM appendFormat:@"#enabled=%@" , @(button.enabled)];
        [eventPathM appendFormat:@"#selected=%@" , @(button.selected)];

    } else if ([sender isKindOfClass:[UISwitch class]]) {
        
        UISwitch *senderSwitch = (UISwitch *)sender;
        
        [eventPathM appendFormat:@"#isOn=%@" , @(senderSwitch.isOn)];
        [eventPathM appendFormat:@"#state=%@" , @(senderSwitch.state)];
        [eventPathM appendFormat:@"#enabled=%@" , @(senderSwitch.enabled)];
        
    } else if ([sender isKindOfClass:[UISegmentedControl class]]) {
        
        UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
        [eventPathM appendFormat:@"#selectedSegmentIndex=%@" , @(        segmentedControl.selectedSegmentIndex)];
        
    } else if ([sender isKindOfClass:[UIStepper class]]) {
        
        UIStepper *stepper = (UIStepper *)sender;
        
        [eventPathM appendFormat:@"#value=%@" , @(stepper.value)];
        [eventPathM appendFormat:@"#minimumValue=%@" , @(stepper.minimumValue)];
        [eventPathM appendFormat:@"#maximumValue=%@" , @(stepper.maximumValue)];
    }
    
    [[sender wk_trackingData] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [eventPathM appendFormat:@"#%@=%@" , key , obj];
    }];
    
    return eventPathM.copy;
}


@end
