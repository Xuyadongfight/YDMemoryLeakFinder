//
//  YDMemoryLeakManager.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//
#if DEBUG

#import "YDMemoryLeakManager.h"

@implementation YDMemoryLeakManager
+ (instancetype)YDFunc(shared){
    static dispatch_once_t onceToken;
    static YDMemoryLeakManager *__shared;
    dispatch_once(&onceToken, ^{
        __shared = [[YDMemoryLeakManager alloc] init];
        __shared.ignores = [[NSMutableSet alloc] init];
    });
    return __shared;
}
@end

#endif
