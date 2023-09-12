//
//  MyThread.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/1/13.
//

#import "MyThread.h"
#import <Foundation/NSCoder.h>

@interface MyThread()<NSCopying,NSMutableCopying>

@end

@implementation MyThread

- (instancetype)init{
    if (self == [super init]) {
    
    }
    return self;
}
- (void)addTask:(void (^)(void))taskBlock{
    
    [self performSelector:@selector(task:) onThread:self withObject:taskBlock waitUntilDone:NO];
}
-(void)task:(id)param{
    void(^temp)(void) = param;
    temp();
}

-(void)getRunLoop{
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    self.port = [[NSMachPort alloc] init];
    self.port.delegate = self;
    [runloop addPort:self.port forMode:NSDefaultRunLoopMode];
//    [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
}

//- (void)handlePortMessage:(NSPortMessage *)message{
//    NSLog(@"port message = %@",message);
//    NSArray *arr = [message valueForKey:@"components"];
//}

-(void)stop{
//    CFRunLoopRef temp = CFRunLoopGetCurrent();
//    CFRunLoopStop(temp);
}

- (void)dealloc{
    NSLog(@"dealloc mythread %@",self);
}
@end
