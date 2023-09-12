//
//  NSObject+category1.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/3/2.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (category1)


-(void)test;

- (id)performSelector:(SEL)aSelector withObjects:(NSArray<id>*)objects;

-(void)YDObserveKeyPath:(NSString*)keyPath observer:(id)observer options:(NSKeyValueObservingOptions)options block:(void(^)(NSDictionary<NSKeyValueChangeKey,id> *))block;

@end

NS_ASSUME_NONNULL_END
