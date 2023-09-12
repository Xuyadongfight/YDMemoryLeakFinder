//
//  CycleRefVC.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/9/1.
//

#import "CycleRefVC.h"
#import "Categories/UIViewController+YDCommon.h"

@interface CycleRefVC ()
@property(strong,nonatomic)UIViewController*vc;
@end

@implementation CycleRefVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
}

-(void)setUp{
    __weak typeof(self)weakSelf = self;
    
    [self addBtn:@"cycle self" frame:CGRectMake(100, 100, 100, 40) action:^(UIButton * _Nonnull btn) {
        weakSelf.vc = weakSelf;
    }];
    
    [self addBtn:@"dismiss self" frame:CGRectMake(100, 200, 100, 40) action:^(UIButton * _Nonnull btn) {
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
}

- (void)dealloc{
    NSLog(@"dealloc = %@",self);
}


@end
