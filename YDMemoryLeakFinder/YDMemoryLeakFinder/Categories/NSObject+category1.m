//
//  NSObject+category1.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/3/2.
//

#import "NSObject+category1.h"
#import "YDObserver.h"



@implementation NSObject (category1)

-(void)YDObserveKeyPath:(NSString*)keyPath observer:(id)observer options:(NSKeyValueObservingOptions)options block:(void(^)(NSDictionary<NSKeyValueChangeKey,id> *))block{
    YDKVOInfo *info = [[YDKVOInfo alloc] init];
    info.observed = self;
    info.observer = observer;
    info.keyPath = keyPath;
    info.block = block;
    info.options = options;
    YDObserver *shared = [YDObserver shared];
    [shared.kvoInfos addObject:info];
    [self addObserver:shared forKeyPath:keyPath options:options context:(__bridge void*)info];
}

- (void)test{
    [self performSelector:@selector(address)];
    
}

- (id)performSelector:(SEL)aSelector withObjects:(NSArray<id>*)objects{
    
    NSMethodSignature *methodSig = [self methodSignatureForSelector:aSelector];
    if (methodSig == nil) {
        return nil;
    }
    
    
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"%s%s%s",@encode(id),@encode(id),@encode(SEL)];
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mStr appendFormat:@"%s",@encode(id)];
    }];
    const char* typeCode = [mStr UTF8String];
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:typeCode];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation setArgument:&obj atIndex:idx + 2];
    }];
    [invocation invoke];
    id result;
    [invocation getReturnValue:&result];
    if (!result) {
        NSAssert(result != nil,@"调用的方法返回值必须为对象");
    }
    return result;
}
@end
