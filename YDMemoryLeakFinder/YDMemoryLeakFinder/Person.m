//
//  Person.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/1/17.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

- (void)sayHello{
    void(*temp)(void) = 0x0;
    temp();
}

- (void)sayHello:(NSString *)person comment:(NSString *)comment{
    NSLog(@"%@ sayHello %@",person,comment);
    void(*temp)(void) = 0x0;
    temp();
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@ change = %@ object = %@",self,change,object);
}

- (void)dealloc{
    NSLog(@"dealloc %@",self);
}


@end
