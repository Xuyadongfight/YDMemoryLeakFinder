//
//  UIViewController+YDCommon.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/9/1.
//

#import "UIViewController+YDCommon.h"
#import <objc/runtime.h>

@implementation UIViewController (YDCommon)
-(void)addBtn:(NSString *)title frame:(CGRect)frame action:(void(^)(UIButton*))action{
    static int action_i = 0;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    void(^btnConfig)(void)=^{
        void(^tempAction)(void) = ^{
            action(btn);
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
@end
