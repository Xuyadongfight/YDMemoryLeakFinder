//
//  NSTimer+Category.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2022/10/19.
//

#import "NSTimer+Category.h"

@implementation NSTimer (Category)
- (void)dealloc{
    NSLog(@"dealloc timer");
}
@end
