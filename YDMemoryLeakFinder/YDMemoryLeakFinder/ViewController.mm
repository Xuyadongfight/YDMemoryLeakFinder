//
//  ViewController.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import "ViewController.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import "NSObject+YDHacking.h"
#import "YDFileMonitor.h"
#import "YDMemoryLeakFinder-Swift.h"



@interface ViewController ()
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
@end

@implementation ViewController

-(void)addBtn:(NSString *)title frame:(CGRect)frame action:(void(^)(UIButton*))action{
    static int action_i = 0;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    void(^btnConfig)(void)=^{
        void(^tempAction)(void) = ^{
            action(btn);
            NSLog(@"%@",btn.titleLabel.text);
        };
        SEL sel_action = sel_registerName([[NSString stringWithFormat:@"%@_%d",@"action",action_i++] UTF8String]);
        class_addMethod([btn class], sel_action,imp_implementationWithBlock(tempAction), "v@:@");
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:btn action:sel_action forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    };
    
    btnConfig();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    __weak typeof(self)weakSelf = self;
    CGRect mainRect = [UIScreen mainScreen].bounds;
    if (self.addBtns) {
        [self addBtn:@"点击设置 strong 属性强引用" frame:CGRectMake(0, 200, mainRect.size.width, 40) action:^(UIButton *btn){
            weakSelf.strongVC = weakSelf;
        }];
        [self addBtn:@"点击设置 block 强引用" frame:CGRectMake(0, 300, mainRect.size.width, 40) action:^(UIButton *btn){
            [weakSelf setUpCallback];
        }];
        [self addBtn:@"点击设置 timer 强引用" frame:CGRectMake(0, 400, mainRect.size.width, 40) action:^(UIButton *btn){
            [weakSelf createTimer];
        }];
        [self addBtn:@"点击设置 数组 强引用" frame:CGRectMake(0, 500, mainRect.size.width, 40) action:^(UIButton *btn){
            [weakSelf addSelf];
        }];
    }else{
        [self addBtn:@"push OC ViewController" frame:CGRectMake(0, 300, mainRect.size.width, 40) action:^(UIButton *btn){
            [weakSelf pushOC];
        }];
        
        [self addBtn:@"push swift ViewController" frame:CGRectMake(0, 400, mainRect.size.width, 40) action:^(UIButton *btn){
            [weakSelf pushSwift];
        }];
    }
}

-(void)pushOC{
    ViewController *vc = [[ViewController alloc] init];
    vc.addBtns = true;
    [self.navigationController pushViewController:vc animated:true];
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

-(void)addSelf{
    [self.mArray addObject:self];
}


-(void)timerAction{
    [self YD_logRetainCount];
}


- (void)dealloc{
    NSLog(@"dealloc:%@",self);
}



@end
