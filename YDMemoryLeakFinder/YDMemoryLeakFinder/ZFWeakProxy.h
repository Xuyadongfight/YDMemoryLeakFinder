//
//  ZFWeakProxy.h
//  ZFBaseModule
//
//  Created by 徐亚东 on 2021/6/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFWeakProxy : NSProxy
@property (nonatomic, weak, readonly, nullable) id target;

- (nonnull instancetype)initWithTarget:(nonnull id)target;
+ (nonnull instancetype)proxyWithTarget:(nonnull id)target;
@end

NS_ASSUME_NONNULL_END
