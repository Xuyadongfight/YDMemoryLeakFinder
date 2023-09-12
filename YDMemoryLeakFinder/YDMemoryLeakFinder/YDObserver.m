//
//  YDObserver.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/8/22.
//

#import "YDObserver.h"



@implementation YDKVOInfo


@end



@implementation YDObserver
+ (instancetype)shared{
    static YDObserver *_observer;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _observer = [[YDObserver alloc] init];
        _observer.kvoInfos = [[NSMutableArray alloc] init];
    });
    return _observer;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context) {
        YDKVOInfo *info = (__bridge id)context;
        if (info.block) {
            info.block(change);
        }
    }
}

@end
