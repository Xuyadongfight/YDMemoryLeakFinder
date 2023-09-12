//
//  YDObserver.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface YDKVOInfo : NSObject
@property(nonatomic,weak)id observed;
@property(nonatomic,weak)id observer;
@property(nonatomic,strong)NSString *keyPath;
@property(nonatomic,assign)NSKeyValueObservingOptions options;
@property(nonatomic,copy)void(^block)(NSDictionary<NSKeyValueChangeKey,id> *);
@end

@interface YDObserver : NSObject
@property(strong,nonatomic)NSMutableArray *kvoInfos;
+(instancetype)shared;
@end

NS_ASSUME_NONNULL_END
