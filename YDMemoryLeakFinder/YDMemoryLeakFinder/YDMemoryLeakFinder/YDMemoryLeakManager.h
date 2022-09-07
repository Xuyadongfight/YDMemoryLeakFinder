//
//  YDMemoryLeakManager.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import <Foundation/Foundation.h>
#import "NSObject+YDHacking.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YDMemoryLeakManager : NSObject<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSMutableSet *ignores;
+(instancetype)YDFunc(shared);
@end

NS_ASSUME_NONNULL_END
