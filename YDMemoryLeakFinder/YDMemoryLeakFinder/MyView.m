//
//  MyView.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/3/16.
//

#import "MyView.h"

@implementation MyView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return true;
}

@end
