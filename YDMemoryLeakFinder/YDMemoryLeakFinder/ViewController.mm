//
//  ViewController.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import <stdio.h>
#import "ViewController.h"
#import <dlfcn.h>
#import "NSObject+YDHacking.h"
#import "YDFileMonitor.h"
#import "YDMemoryLeakFinder-Swift.h"
#import "CoreFoundation/CFRunLoop.h"
#import "MyThread.h"
#import <pthread.h>
#import "Teacher.h"
#import "NSObject+category1.h"
#import <objc/runtime.h>
#import "Test.h"
//#import "UIView+category.h"
#import "ExtendView.h"
#import "Person+category1.h"
#import "NSObject+YDRuntime.h"
#import "ZFBugFix.h"
#import <mach/mach.h>
#import "YDObserver.h"
#import "NSObject+YDRuntime.h"
#import <pthread.h>
#import "Categories/UIViewController+YDCommon.h"
#import "CycleRefVC.h"
#import "TestViewController.h"

//typedef struct my_objc_test* MyTest;


@interface MNPerson : NSObject

@property (nonatomic, copy)NSString *name;

- (void)print;

@end

@implementation MNPerson

- (void)print{
    NSLog(@"self.name = %@",self.name);
}
+(void)print{
    NSLog(@"self.name = %@",self);
}

@end




@interface ViewController()<CALayerDelegate>
@property(strong,nonatomic)NSArray *arrayA;
@property(assign,nonatomic)int numA;
@property(strong,nonatomic)UIButton *backBtn;
@property(strong,nonatomic)UIButton *unload;
@property(strong,nonatomic)UIViewController *strongVC;
@property (copy,nonatomic)void(^callBack1)(void);
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic,retain)NSString *str;
@property(strong,nonatomic)NSNumber *number;
@property(assign,nonatomic)BOOL addBtns;
@property(strong,nonatomic)NSMutableArray*mArray;
@property(strong,nonatomic)ViewController*vc;
@property(weak,nonatomic)MyThread *thread;
@property(strong,nonatomic)NSMachPort *mainPort;
@property(strong,nonatomic)CALayer *layer1;
@property(strong,nonatomic)NSURLSession *session;
@property(strong,nonatomic)Person *myPerson;
@property(strong,nonatomic)NSMutableDictionary *myDic;
@property(strong,nonatomic)UIViewController *strongVC1;
@end

@implementation ViewController


+ (void)load{
    
}



/*
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
     kCFRunLoopEntry = (1UL << 0),
     kCFRunLoopBeforeTimers = (1UL << 1),
     kCFRunLoopBeforeSources = (1UL << 2),
     kCFRunLoopBeforeWaiting = (1UL << 5),
     kCFRunLoopAfterWaiting = (1UL << 6),
     kCFRunLoopExit = (1UL << 7),
     kCFRunLoopAllActivities = 0x0FFFFFFFU
 
 UITrackingRunLoopMode,
 GSEventReceiveRunLoopMode,
 kCFRunLoopDefaultMode,
 kCFRunLoopCommonModes
 };
 */
void *thread_task(void *arg){
    /*
     //缓冲区使用的是栈内存，当方法返回结束时候，指向的内存就被回收了。返回的指针成为悬空指针，指向了未定义的内存。
     char buffer[64];
     return (void*)buffer;
     */
    
    /*
    //缓冲区被设置为静态，这样在方法返回之后它将继续存在。就不会有悬空指针的问题。但是当多个线程运行同一个线程函数的情况。第二个线程将用它自己的数据覆盖静态缓冲区，并销毁第一个线程留下的数据。全局变量也面临同样的问题。
     static char buffer[64];
     return buffer;
     */
    
    //最通用和健壮的做法
    //此版本动态分配缓冲区空间。即使有多个线程执行线程函数，这种方法也能正常工作。每个都会分配一个不同的数组，并将该数组的地址存储在堆栈变量中。每一个线程有自己的栈，因此每个线程的自动数据对象是不同的。
    char *buffer = (char*)malloc(64);
    return buffer;
}

void thread_test(void){
    pthread_t tid;
    void *res = NULL;
    pthread_create(&tid, NULL, thread_task, NULL);
    pthread_join(tid, &res);
    free(res);
    return ;
}

void addObserver(){
    NSArray * allModes = (__bridge NSArray*)CFRunLoopCopyAllModes(CFRunLoopGetMain());
    for (int i = 0; i < allModes.count; i++) {
        NSLog(@"%@",allModes[i]);
    }
    NSDictionary *observerStatus = @{@(1<<0):@"kCFRunLoopEntry",@(1<<1):@"kCFRunLoopBeforeTimers",@(1<<2):@"kCFRunLoopBeforeSources",
                                 @(1<<5):@"kCFRunLoopBeforeWaiting",@(1<<6):@"kCFRunLoopAfterWaiting",@(1<<7):@"kCFRunLoopExit"};
    CFRunLoopObserverRef observerCommon = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"common loop = %@",observerStatus[@(activity)]);
    });
    CFRunLoopObserverRef observerDefault = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"default loop = %@",observerStatus[@(activity)]);
    });
    CFRunLoopObserverRef observerTracking = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"tracking loop = %@",observerStatus[@(activity)]);
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), observerCommon, kCFRunLoopCommonModes);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observerDefault, kCFRunLoopDefaultMode);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observerTracking, (CFRunLoopMode)UITrackingRunLoopMode);
}

#define MAXNUM 1024*1024

-(void)testFuncNO{
    
}
-(void)testFunc1{
    BOOL a;
}
-(void)testFunc4{
    BOOL a;
    BOOL b;
    BOOL c;
    BOOL d;
}


- (instancetype)init{
    if (self = [super init]) {
        
    }
    return  self;
}







- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.strongVC1 = self;
    self.strongVC = self;
    self.callBack1 = ^{
        NSLog(@"%@",self);
    };
    __weak typeof(self)weakSelf = self;
    
    [self addBtn:@"push cycleVC" frame:CGRectMake(100, 100, 200, 40) action:^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController pushViewController:[TestViewController new] animated:true];
    }];
    
    [self addBtn:@"push swiftVC" frame:CGRectMake(100, 200, 200, 40) action:^(UIButton * _Nonnull) {
        [weakSelf.navigationController pushViewController:[TestVC new] animated:true];
    }];
    
    [self addBtn:@"present cycleVC" frame:CGRectMake(100, 300, 200, 40) action:^(UIButton * _Nonnull) {
        [weakSelf presentViewController:[CycleRefVC new] animated:true completion:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000), dispatch_get_main_queue(), ^{
//            [weakSelf dismissViewControllerAnimated:true completion:nil];
//        });
    }];
    
    [self addBtn:@"test" frame:CGRectMake(100, 400, 200, 40) action:^(UIButton * _Nonnull) {
        [weakSelf actionOfTest];
    }];
    
}

-(void)actionOfTest{
    [self getClassInfos:[TestVC class]];
}

-(void)getClassInfos:(Class)tmp{
    NSPointerArray*arrIvars = [tmp YDIvars];
    for (int i = 0; i < arrIvars.count; i++) {
        YDIvar *pro = (YDIvar *)[arrIvars pointerAtIndex:i];
        printf("ivar name = %s -  attr = %s\n",pro->name,pro->type);
    }
    
    NSPointerArray*arrPs = [tmp YDProperties];
    for (int i = 0; i < arrPs.count; i++) {
        YDProperty *pro = (YDProperty *)[arrPs pointerAtIndex:i];
        printf("pro name = %s -  attr = %s\n",pro->name,pro->attributes);
    }
    
    NSPointerArray*arrMs = [tmp YDMethods];
    for (int i = 0; i < arrMs.count; i++) {
        YDMethod *pro = (YDMethod *)[arrMs pointerAtIndex:i];
        printf("method name = %s -  attr = %s\n",pro->name,pro->typeEncoding);
    }
}

-(void)crash{
    NSArray *arr = [NSArray new];
    [arr objectAtIndex:1];
}

-(void)testArr:(NSArray*)arg1 next:(void*)ptr{
    
}



-(void)pushOC{
    ViewController *vc = [[ViewController alloc] init];
    vc.addBtns = true;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:true];
    
}
-(void)pushOCGesture{
    NSLog(@"gesture");
}
-(void)pushSwift{
    TestVC *vc = [[TestVC alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

-(void)setUpCallback{
    self.callBack1 = ^{
        NSLog(@"%@",self);
    };
}

-(void)createTimer{
    id weakTarget = [[ZFWeakProxy alloc] initWithTarget:self];
    __weak typeof(self)weakSelf = self;
//    id temp = [NSTimer scheduledTimerWithTimeInterval:3.0 target:weakSelf selector:@selector(timerAction) userInfo:nil repeats:YES];
//    id temp = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf timerAction];
//    }];
    
    id temp = [[NSTimer alloc] initWithFireDate:[NSDate now] interval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf timerAction];
    }];
    __weak typeof(temp)weakTimer = temp;
    [[NSRunLoop currentRunLoop] addTimer:weakTimer forMode:NSDefaultRunLoopMode];
}

-(void)addSelf{
    [self.mArray addObject:self];
}


-(void)timerAction{
    [self YD_logRetainCount];
}

- (void)NSThreadTest{
    for (int i =0; i<10000; i++) {
        @autoreleasepool {
            id temp = [self getVC];
        }
            
    }
}
-(void)doSomeThing{
    [NSThread sleepForTimeInterval:2];
    NSLog(@"do something %@",[[NSThread currentThread] name]);

    [self performSelectorOnMainThread:@selector(backMainThread) withObject:nil waitUntilDone:true];
}
-(void)backMainThread{
    NSLog(@"back main thread");
}


-(void)threadTask{
    int count = 100;
    static int taskCount = 0;
    do{
        count--;
    }while(count);
    NSLog(@"task = %d count = %d",taskCount++,count);
    [self.thread getRunLoop];
}


- (void)test:(id)param1 next:(id)param2{
    NSLog(@"param1 = %@ 2 = %@",param1,param2);
}



void my_weak(void**ptr){
    *ptr = nil;
}

-(Person*)getPerson{
    Person *p = [[Person alloc] init];
    return p;
}

-(ViewController*)getVC{
    id temp = [[NSObject alloc] init];
    return temp;
}

- (void)dealloc{
    [self.timer invalidate];
    NSLog(@"dealloc:%@",self);
}

-(void)funcTest:(NSObject*)object with:(id)idObject{
    ZFWeakProxy *proxy = [ZFWeakProxy alloc];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    object = idObject;
//    object = proxy;
    idObject = proxy;
    
}

- (void)displayLayer:(CALayer *)layer;{
    NSLog(@"%@ %@",layer,self.view.layer);
}


-(void)hotTest{

}

-(void)changeBackground{
    self.view.backgroundColor = [UIColor redColor];
}

@end



