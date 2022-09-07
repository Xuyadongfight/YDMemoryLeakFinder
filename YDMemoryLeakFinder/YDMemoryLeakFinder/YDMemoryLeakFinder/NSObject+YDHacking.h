//
//  NSObject+YDHacking.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define YDFunc(x) YD_##x

@interface NSObject (YDHacking)
-(void)YDFunc(willDealloc);
-(void)YDFunc(logRetainCount);
-(long)YDFunc(getRetainCount);
@end

NS_ASSUME_NONNULL_END
