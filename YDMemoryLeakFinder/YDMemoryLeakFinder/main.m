//
//  main.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <dlfcn.h>
#import "Person.h"
#import <pthread.h>



//    [p2 retain];
//    [p1 retain];
//
//    p1.ptr_Person = nil;
//    [p2 release];
//    p2.ptr_Person = nil;
//    [p1 release];
//
//    [p1 copy];
//    p1 mutableCopy




int main(int argc, char * argv[]) {
//    struct s1 temp1 = {'a',1,10};
//    struct s2 temp2 = {'c',2,3.14};
//    struct s3 temp3 = {'c'};
//    struct s3 temp4 = {'b'};
//    long base1 = &temp1;
//    long base2 = &temp2;
//    long p1a = &temp1.a;
//    long p1b = &temp1.b;
//    long p1c = &temp1.c;
//    long p2a = &temp2.a;
//    long p2b = &temp2.b;
//    long p2c = &temp2.c;
//
//
//    printf("temp1 = %p address a = %p,address b = %p,address c = %p sizeof = %d \n",base1,p1a - base1,p1b - base1,p1c - base1,sizeof(temp1));
//    printf("temp2 = %p address a = %p,address b = %p,address c = %p sizeof = %d \n",base2,p2a - base2,p2b - base2,p2c - base2,sizeof(temp2));
//    printf("temp3 = %p temp4 = %p\n",&temp3,&temp4);
    
    
    
     NSString * appDelegateClassName;
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

