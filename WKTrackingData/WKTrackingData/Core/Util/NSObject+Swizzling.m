//
//  NSObject+Swizzling.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/7.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "NSObject+Swizzling.h"

#import <objc/runtime.h>

@implementation NSObject (Swizzling)

// This implementation of swizzling was lifted from http://nshipster.com/method-swizzling
- (void)wk_swizzleInstanceSelector:(SEL)origSel_ replaceSelector:(SEL)replaceSel_ {
    Method origMethod = class_getInstanceMethod([self class], origSel_);
    Method replaceMethod = class_getInstanceMethod([self class], replaceSel_);

    BOOL didAddMethod =
    class_addMethod([self class],
                    origSel_,
                    method_getImplementation(replaceMethod),
                    method_getTypeEncoding(replaceMethod));
    
    if (didAddMethod) {
        class_replaceMethod([self class],
                            replaceSel_,
                            method_getImplementation(replaceMethod),
                            method_getTypeEncoding(replaceMethod));
    } else {
        method_exchangeImplementations(origMethod, replaceMethod);
    }
}

- (void)wk_swizzleClassSelector:(SEL)origSel_ replaceSelector:(SEL)replaceSel_ {
    [object_getClass(self) wk_swizzleInstanceSelector:origSel_ replaceSelector:replaceSel_];
}

- (void)wk_swizzleInstanceSelector:(SEL)origSel_ fromClass:(Class)fromClass replaceSelector:(SEL)replaceSel_ {
    
    Method origMethod = class_getInstanceMethod([self class], origSel_);
    Method replaceMethod = class_getInstanceMethod(fromClass, replaceSel_);
    
    NSAssert(origMethod, NSStringFromClass([self class]) , @" did not imp method ", NSStringFromSelector(origSel_));
    NSAssert(replaceMethod, NSStringFromClass([fromClass class]) , @" did not imp method ", NSStringFromSelector(replaceSel_));

    // 给self添加 replaceSel_ 的实现，如果添加成功，则交换self的 replaceSel_ 和 origSel_
    BOOL didAddMethod =
    class_addMethod([self class],
                    replaceSel_,
                    method_getImplementation(replaceMethod),
                    method_getTypeEncoding(replaceMethod));
    
    if (didAddMethod) {
        Method origReplaceMeth = class_getInstanceMethod([self class], replaceSel_);
        method_exchangeImplementations(origMethod, origReplaceMeth);
    } else {
        method_exchangeImplementations(origMethod, replaceMethod);
    }
}

- (void)wk_swizzleClassSelector:(SEL)origSel_ fromClass:(Class)fromClass replaceSelector:(SEL)replaceSel_ {
    [object_getClass(self) wk_swizzleInstanceSelector:origSel_ fromClass:fromClass replaceSelector:replaceSel_];
}

- (void)wk_swizzleInstanceSelector:(SEL)origSel_ fromClass:(Class)fromClass replaceSelector:(SEL)replaceSel_ originNotImp:(SEL)notImpSel_ {
    
    Method originalMethod = class_getInstanceMethod([self class], origSel_);
    
    if (originalMethod) {
        [self wk_swizzleInstanceSelector:origSel_ fromClass:fromClass replaceSelector:replaceSel_];
    } else {
        Method notImpMethod = class_getInstanceMethod(fromClass, notImpSel_);

        // 如果delegateClass没有实现 origSel_ 方法
        // 则给delegateClass的 origSel_ 添加 orginReplaceMethod 的实现
        BOOL didAddNotImpMethod =
        class_addMethod([self class],
                        origSel_,
                        method_getImplementation(notImpMethod),
                        method_getTypeEncoding(notImpMethod));
        if (didAddNotImpMethod) {
            NSLog(@"%@ did add not imp method %@" , NSStringFromClass([self class]) , NSStringFromSelector(notImpSel_));
        }
    }
}

@end
