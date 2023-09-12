//
//  MyThread.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyThread : NSThread <NSMachPortDelegate>
@property(strong,nonatomic)NSMachPort *port;

-(void)stop;
-(void)getRunLoop;
-(void)addTask:(void(^)(void))taskBlock;
@end

NS_ASSUME_NONNULL_END
