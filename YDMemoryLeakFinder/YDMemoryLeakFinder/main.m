//
//  main.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <dlfcn.h>



int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
//    void (^blk)(void) = ^{
//
//    };
//    blk();
//    NSLog(@"%@",blk);
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}


//#import <stdio.h>
//static int testFunc(){
//    printf("test out put");
//    return 0;
//}
//int main(int argc, char * argv[]) {
//    testFunc();
//    printf("hello world");
//    printf("hello world2");
//}

