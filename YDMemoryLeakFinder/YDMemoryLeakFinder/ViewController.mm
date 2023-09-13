//
//  ViewController.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import <stdio.h>
#import "ViewController.h"
#import "YDMemoryLeakFinder-Swift.h"
#import "Categories/UIViewController+YDCommon.h"
#import "TestViewController.h"

@interface ViewController()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    __weak typeof(self)weakSelf = self;
    
    [self addBtn:@"push cycleVC" frame:CGRectMake(100, 100, 200, 40) action:^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController pushViewController:[TestViewController new] animated:true];
    }];
    
    [self addBtn:@"push swiftVC" frame:CGRectMake(100, 200, 200, 40) action:^(UIButton * _Nonnull) {
        [weakSelf.navigationController pushViewController:[TestVC new] animated:true];
    }];
    
    [self addBtn:@"present cycleVC" frame:CGRectMake(100, 300, 200, 40) action:^(UIButton * _Nonnull) {
        [weakSelf presentViewController:[TestViewController new] animated:true completion:nil];
    }];
    
    [self addBtn:@"present swiftVC" frame:CGRectMake(100, 400, 200, 40) action:^(UIButton * _Nonnull) {
        [weakSelf presentViewController:[TestVC new] animated:true completion:nil];
    }];
    
}

@end



