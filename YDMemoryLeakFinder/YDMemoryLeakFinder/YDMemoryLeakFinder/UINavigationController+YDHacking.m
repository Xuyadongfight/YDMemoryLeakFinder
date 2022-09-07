//
//  UINavigationController+YDHacking.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//
#if DEBUG

#import "UINavigationController+YDHacking.h"
#import <objc/runtime.h>
#import "NSObject+YDHacking.h"

@implementation UINavigationController (YDHacking)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        
        SEL originalSel = @selector(popViewControllerAnimated:);
        SEL swizzledSel = @selector(YD_popViewControllerAnimated:);
        
        Method originalMethod = class_getInstanceMethod(cls, originalSel);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSel);
        
        BOOL didAddMethod = class_addMethod(cls, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod){
//            class_replaceMethod(cls, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}
- (nullable UIViewController *)YDFunc(popViewControllerAnimated):(BOOL)animated{
    UIViewController *temp = [self YD_popViewControllerAnimated:animated];
    [temp YD_willDealloc];
    return temp;
}

@end

#endif
