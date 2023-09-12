//
//  ExtendView.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/8/8.
//

#import "ExtendView.h"

@implementation ExtendView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    UIEdgeInsets insets = UIEdgeInsetsMake(100, 100, 100, 100);
    CGRect newRect = CGRectMake(self.bounds.origin.x - insets.left, self.bounds.origin.y - insets.top, self.bounds.size.width + insets.right, self.bounds.size.height + insets.bottom);
    BOOL inside = CGRectContainsPoint(newRect, point);
    NSLog(@"inside = %d",inside);
    return inside;
}

@end
