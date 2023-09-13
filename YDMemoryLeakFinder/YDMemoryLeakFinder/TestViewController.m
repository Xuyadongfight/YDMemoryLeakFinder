//
//  TestViewController.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/9/12.
//

#import "TestViewController.h"
#import "Categories/UIViewController+YDCommon.h"

@interface TestViewController ()
@property(strong,nonatomic)UIViewController *strongVC;
@property(strong,nonatomic)void(^block)(void);
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)CADisplayLink *displayLink;
@property(assign,nonatomic)int age;
@property(readonly)id temp;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
}

-(void)setUp{
    __weak typeof(self)weakSelf = self;
    [self addBtn:@"cycleVC" frame:CGRectMake(100, 100, 100, 40) action:^(UIButton * btn) {
        [weakSelf cycleVC];
    }];
    [self addBtn:@"cycleBlock" frame:CGRectMake(100, 200, 100, 40) action:^(UIButton * btn) {
        [weakSelf cycleBlock];
    }];
    [self addBtn:@"cycleTimer" frame:CGRectMake(100, 300, 100, 40) action:^(UIButton * btn) {
        [weakSelf cycleTimer];
    }];
    [self addBtn:@"cycleDisplayLink" frame:CGRectMake(100, 400, 100, 40) action:^(UIButton * btn) {
        [weakSelf cycleDisplayLink];
    }];
}

-(void)cycleVC{
    self.strongVC = self;
}
-(void)cycleBlock{
    self.block = ^{
        NSLog(@"%@",self);
    };
}
-(void)cycleTimer{
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(actionOfTimer) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

-(void)actionOfTimer{
    NSLog(@"timer action %@",self.timer);
}

-(void)cycleDisplayLink{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionOfDisplayLink)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)actionOfDisplayLink{
    NSLog(@"action displaylink");
}

- (void)dealloc{
    NSLog(@"dealloc %@",self);
}
@end
