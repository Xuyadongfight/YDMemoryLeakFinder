//
//  UIViewController+YDHacking.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/11/22.
//
#if DEBUG

#import "UIViewController+YDHacking.h"
#import <objc/runtime.h>
#import "NSObject+YDHacking.h"
@implementation UIViewController (YDHacking)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        
        SEL originalSel = @selector(dismissViewControllerAnimated:completion:);
        SEL swizzledSel = @selector(YD_dismissViewControllerAnimated:completion:);
        
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
- (void)YDFunc(dismissViewControllerAnimated):(BOOL)flag completion:(void (^)(void))completion{
    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        [self YD_dismissViewControllerAnimated:flag completion:completion];
    }else{
        [self YD_willDealloc];
        [self YD_dismissViewControllerAnimated:flag completion:completion];
    }
}
@end

#endif
