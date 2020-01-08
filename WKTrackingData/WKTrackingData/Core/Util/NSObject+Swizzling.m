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

+ (BOOL)wk_swizzleMethod:(SEL)origSel_ withMethod:(SEL)replaceSel_ {
    
    Method origMethod = class_getInstanceMethod(self, origSel_);
    Method replaceMethod = class_getInstanceMethod(self, replaceSel_);

    BOOL didAddMethod =
    class_addMethod(self,
                    origSel_,
                    method_getImplementation(replaceMethod),
                    method_getTypeEncoding(replaceMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            replaceSel_,
                            method_getImplementation(replaceMethod),
                            method_getTypeEncoding(replaceMethod));
    } else {
        method_exchangeImplementations(origMethod, replaceMethod);
    }
    return YES;
}

+ (BOOL)wk_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)replaceSel_ {
    return [object_getClass(self) wk_swizzleMethod:origSel_ withMethod:replaceSel_];
}

+ (void)wk_swizzlingDelegate:(Class) delegateClass originSel:(SEL) origSel_ replacedClass:(Class) replacedClass replaceSel:(SEL) replaceSel_ delegateNotImp:(SEL) notImpSel_ {
    
    Method originalMethod = class_getInstanceMethod(delegateClass, origSel_);
    Method replacedMethod = class_getInstanceMethod(replacedClass, replaceSel_);
    
    if (!originalMethod) {
        Method notImpMethod = class_getInstanceMethod(replacedClass, notImpSel_);
        
        // 如果delegateClass没有实现 origSel_ 方法
        // 则给delegateClass的 origSel_ 添加 orginReplaceMethod 的实现
        BOOL didAddNotImpMethod =
        class_addMethod(delegateClass,
                        origSel_,
                        method_getImplementation(notImpMethod),
                        method_getTypeEncoding(notImpMethod));
        if (didAddNotImpMethod) {
            NSLog(@"%@ did add not imp method %@" , NSStringFromClass(delegateClass) , NSStringFromSelector(notImpSel_));
        }
        return;
    }
    
    // delegateClass 已经实现了 origSel_ 方法
    // 给 delegateClass 的 replacedSel 添加 replacedMethod 实现
    BOOL didAddMethod =
    class_addMethod(delegateClass,
                    replaceSel_,
                    method_getImplementation(replacedMethod),
                    method_getTypeEncoding(replacedMethod));
    
    if (didAddMethod) {
        // 如果添加成功，则交换 originalMethod 和 replacedMethod
        Method newMethod = class_getInstanceMethod(delegateClass, replaceSel_);
        method_exchangeImplementations(originalMethod, newMethod);
    }else{
        // 添加失败，则说明已经给 delegateClass 添加过 replacedMethod，防止多次交换。
        NSLog(@"%@ already hook",NSStringFromClass(delegateClass));
    }
}

@end
