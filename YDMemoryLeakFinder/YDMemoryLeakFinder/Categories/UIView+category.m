//
//  UIView+category.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/3/31.
//

#import "UIView+category.h"
#import <objc/runtime.h>
#import "ExtendView.h"

@implementation UIView (category)

-(void)extendRect:(CGRect)rect{
    const char* newClassName = "extend_view";
    

    
//    if (newClass) {
//        Method extend = class_getInstanceMethod([ExtendView class], @selector(pointInside:withEvent:));
//        
//        BOOL ok = class_addMethod(newClass, @selector(pointInside:withEvent:), method_getImplementation(extend), method_getTypeEncoding(extend));
//        NSLog(@"ok %d",ok);
//        
//        objc_registerClassPair(newClass);
//        
//        object_setClass(self, newClass);
//    }
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    UIEdgeInsets insets = UIEdgeInsetsMake(100, 100, 100, 100);
//    CGRect newRect = CGRectMake(self.bounds.origin.x - insets.left, self.bounds.origin.y - insets.top, self.bounds.size.width + insets.right, self.bounds.size.height + insets.bottom);
//    BOOL inside = CGRectContainsPoint(newRect, point);
//    NSLog(@"category inside = %d",inside);
//    return inside;
//}

@end
