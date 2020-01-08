//
//  UICollectionView+DelegateHook.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/1.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "UICollectionView+Tracking.h"

#import "NSObject+Swizzling.h"
#import "WKTrackingDataViewPathHelper.h"

@implementation UICollectionView (Tracking)

+ (void)wk_enableCellSelectTracking {
    [self wk_swizzleMethod:@selector(setDelegate:) withMethod:@selector(wk_setCollectionViewDelegate:)];
}

- (void)wk_setCollectionViewDelegate:(id)delegate {
    
    [self wk_setCollectionViewDelegate:delegate];
    
    [NSObject wk_swizzlingDelegate:[delegate class] originSel:@selector(collectionView:didSelectItemAtIndexPath:) replacedClass:[self class] replaceSel:@selector(delegateTracking_collectionView:didSelectItemAtIndexPath:) delegateNotImp:@selector(delegateTracking_notImp_collectionView:didSelectItemAtIndexPath:)];
}

- (void)delegateTracking_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [WKTrackingDataViewPathHelper viewPath_didSelectItemFrom:collectionView forIndexPath:indexPath];
    
    [self delegateTracking_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - 如果未实现代理

- (void)delegateTracking_notImp_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [WKTrackingDataViewPathHelper viewPath_didSelectItemFrom:collectionView forIndexPath:indexPath];
}

@end
