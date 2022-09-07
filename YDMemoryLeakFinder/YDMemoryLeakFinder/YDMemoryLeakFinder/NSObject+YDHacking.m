//
//  NSObject+YDHacking.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import "NSObject+YDHacking.h"
#import <UIKit/UIKit.h>
#import "YDMemoryLeakManager.h"
#import <objc/runtime.h>
#import "YDTableView.h"

#define YD_FreeArr(x) if(x != NULL){free(x);x = NULL;}

int *indexptr;
void*arrPropertyName;
void*arrIvarName;
void*arrCheckName;
void*arrNoCheckName;
void*checkView;

@implementation NSObject (YDHacking)
- (void)YDFunc(willDealloc){
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC) , dispatch_get_main_queue(), ^{
        [weakSelf YD_HaveLeak];
    });
}
- (long)YDFunc(getRetainCount){
    NSLog(@"self = %@",self);
    return CFGetRetainCount((__bridge void *)self);
}
-(void)YDFunc(logRetainCount){
    NSLog(@"%ld",[self YD_getRetainCount]);
}
-(void)YDFunc(HaveLeak){
    NSLog(@"内存泄漏%@",self);
    NSMutableSet *temp = [YDMemoryLeakManager YD_shared].ignores;
    NSString *strClass = NSStringFromClass([self class]);
    if ([temp containsObject:strClass]){
        return;
    }
    UIAlertController *altVC = [UIAlertController alertControllerWithTitle:@"内存泄漏" message:[NSString stringWithFormat:@"%@",self] preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self)weakSelf = self;
    [altVC addAction:[UIAlertAction actionWithTitle:@"检测" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf YD_CheckMemoryLeakProperty];
    }]];
    [altVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [altVC addAction:[UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (action.style == UIAlertActionStyleCancel){
            [[YDMemoryLeakManager YD_shared].ignores addObject:NSStringFromClass([self class])];
        }
    }]];
    [[self YD_getCurrentVC] presentViewController:altVC animated:true completion:nil];
}



-(void)YDFunc(CheckMemoryLeakProperty){
    if(indexptr){
        *indexptr = 0;
    }
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    for (int i = 0; i< propertyCount;i++){
        objc_property_t property = propertyList[i];
        [propertyNames addObject:[NSString stringWithUTF8String:property_getName(property)]];
    }
    NSMutableSet *propertyNameSet = [NSMutableSet setWithArray:propertyNames];
    if (arrPropertyName != NULL){
        free(arrPropertyName);
        arrPropertyName = NULL;
    }
    YD_FreeArr(arrPropertyName);
    arrPropertyName = (__bridge_retained void*)propertyNames;
    
    unsigned int ivarCount = 0;
    Ivar* ivars = class_copyIvarList([self class], &ivarCount);
    NSMutableArray *ivarNames = [[NSMutableArray alloc] init];
    for (int i = 0; i< ivarCount;i++){
        Ivar ivar = ivars[i];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([[ivarName substringToIndex:1] isEqualToString:@"_"]){
            [ivarNames addObject:[ivarName substringFromIndex:1]];
        }else{
            [ivarNames addObject:ivarName];
        }
        NSLog(@"ivarType = %@ , ivarName = %@",ivarType,ivarName);
    }
    NSMutableSet *ivarNameSet = [NSMutableSet setWithArray:ivarNames];

    YD_FreeArr(arrIvarName);
    arrIvarName = (__bridge_retained void*)ivarNames;
    
    [ivarNameSet minusSet:propertyNameSet];
    
    YD_FreeArr(arrNoCheckName);
    arrNoCheckName = (__bridge_retained void*)[ivarNameSet allObjects];
    
    YD_FreeArr(arrCheckName);
    arrCheckName =(__bridge_retained void*)[[NSMutableArray alloc] init];
    
    if (propertyList && propertyCount>0){
        UILabel *label = [[self YD_getCheckView] viewWithTag:102];
        [label setHidden:true];
        [self YD_checkProerty];
        return;
    }else{
        UILabel *lab = [[self YD_getCheckView] viewWithTag:102];
        lab.textColor = [UIColor redColor];
        lab.text = [NSString stringWithFormat:@"将@objcMembers添加到swift类%@中",NSStringFromClass([self class])];
        [lab setHidden:false];
    }
    free(propertyList);
    propertyList = NULL;
    
//    unsigned int ivarCount = 0;
//    Ivar* ivars = class_copyIvarList([self class], &ivarCount);
//    if (ivars && ivarCount > 0){
//        free(ivars);
//        ivars = NULL;
//        [self YD_checkIvars];
//        return;
//    }
}


-(void)YDFunc(checkProerty){
    static int index = 0;
    indexptr = &index;
    __weak typeof(self)weakSelf = self;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    if (propertyList == NULL || index > propertyCount-1){
        index = 0;
        return;
    }
    UILabel *lab = [[self YD_getCheckView] viewWithTag:102];
    [lab setHidden:false];
    lab.textColor = [UIColor blackColor];
    
    objc_property_t property = propertyList[index++];
    const char* proType = property_getAttributes(property);
    const char* proName = property_getName(property);
    NSString *strType = [NSString stringWithUTF8String:proType];
    NSString *propertyName = [[NSString alloc] initWithUTF8String:proName];
    NSArray *arr = [strType componentsSeparatedByString:@","];

    NSLog(@"type = %@, name = %@",strType,propertyName);
    
    NSMutableArray *checkArr = (__bridge NSMutableArray*)arrCheckName;
    [checkArr addObject:propertyName];
    UITableView *tableView = [[self YD_getCheckView] viewWithTag:101];
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:checkArr.count - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    
    if (![[strType substringToIndex:2] isEqualToString:@"T@"]){//不是对象类型
        lab.text = [NSString stringWithFormat:@"%@ 不是对象类型 跳过",propertyName];
        [self YD_after:^{
            [weakSelf YD_checkProerty];
        }];
        return;
    }
    
    BOOL isReadOnly = false;
    for(int i = 0;i<arr.count;i++){
        if ([arr[i] isEqualToString:@"R"]){
            isReadOnly = true;
        }
    }
    if (isReadOnly){//只读类型
        lab.text = [NSString stringWithFormat:@"%@ 是只读类型 跳过",propertyName];
        [self YD_after:^{
            [weakSelf YD_checkProerty];
        }];
        return;
    }
    
    id obj = [self valueForKey:propertyName];
    if ([obj isKindOfClass:[UIView class]]){
        [(UIView*)obj removeFromSuperview];
    }else if ([obj isKindOfClass:[NSTimer class]]){
        [(NSTimer*)obj invalidate];
    }
    lab.text = [NSString stringWithFormat:@"check property = %@",propertyName];
    [self setValue:nil forKey:propertyName];
    
    [self YD_after:^{
        if (weakSelf == nil){
            lab.text = [NSString stringWithFormat:@"leak property = %@",propertyName];
            lab.textColor = [UIColor redColor];
            [lab setHidden:false];
        }else{
            [weakSelf YD_checkProerty];
        }
    }];
}

-(void)YDFunc(after):(void(^)(void))block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.5), dispatch_get_main_queue(), ^{
        block();
    });
}


-(void)YDFunc(checkIvars){
    static int index = 0;
    indexptr = &index;
    __weak typeof(self)weakSelf = self;
    unsigned int ivarCount = 0;
    Ivar *ivarList = class_copyIvarList([self class], &ivarCount);
    if (ivarList == NULL || index > ivarCount-1){
        index = 0;
        return;
    }
    UILabel *lab = [[self YD_getCheckView] viewWithTag:102];
    Ivar ivar = ivarList[index++];
    const char* ivarType = ivar_getTypeEncoding(ivar);
    const char* ivarName = ivar_getName(ivar);
    long ivarOffset = ivar_getOffset(ivar);
//    id ivarObj = object_getIvar(self, ivar); //对于常量会崩溃
    printf("type = %s name = %s offset = %ld \n",ivarType,ivarName,ivarOffset);
//    id ivarObj = my_object_getIvar(self,ivar);
    id ivarObj = [self valueForKey:[NSString stringWithUTF8String:ivarName]];
    if (ivarObj == nil){
        lab.text = [NSString stringWithFormat:@"%@ 不支持kvc",[NSString stringWithUTF8String:ivarName]];
    }else{
        [self setValue:nil forKey:[NSString stringWithUTF8String:ivarName]];
    }
    
    NSLog(@"ivarObj = %@",ivarObj);
    NSString *ivarNameStr = [NSString stringWithUTF8String:ivarName];
    lab.text = [NSString stringWithFormat:@"check ivar = %@",ivarNameStr];
    lab.textColor = [UIColor blackColor];
    [lab setHidden:false];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1), dispatch_get_main_queue(), ^{
        if (weakSelf == nil){
            lab.text = [NSString stringWithFormat:@"leak ivar = %@",ivarNameStr];
            lab.textColor = [UIColor redColor];
        }else{
            [weakSelf YD_checkIvars];
        }
    });
}

id my_object_getIvar(id obj,Ivar ivar){
    void *obj_ptr = (__bridge void*)obj;
    long ivarOffset = ivar_getOffset(ivar);
    void **ivarObj = obj_ptr + ivarOffset;

    char *jChar = (char*)ivarObj;
    bool isChar = true;
    for (int i = 0; i < strlen(jChar); i++) {
        if (!isascii(jChar[i])) {
            isChar = false;
            break;
        }
    }
    if (isChar && strlen(jChar) != 0) {
        return nil;
    }else{
        id objTemp = (__bridge id)*ivarObj;
        return objTemp;
    }
}

-(UIViewController *)YDFunc(getCurrentVC){
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    loop:
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        rootVC = [(UITabBarController*)rootVC selectedViewController];
        goto loop;
    }else if ([rootVC isKindOfClass:[UINavigationController class]]){
        rootVC = [(UINavigationController*)rootVC visibleViewController];
        goto loop;
    }else if ([rootVC isKindOfClass:[UIViewController class]]){
        if (rootVC.presentedViewController) {
            rootVC = rootVC.presentedViewController;
            goto loop;
        }
    }
    return rootVC;
}

#pragma mark -checkview

-(UIView*)YDFunc(getCheckView){
    UIViewController *vc = [self YD_getCurrentVC];
    if (checkView != NULL){
        UIView *tempView = (__bridge UIView*)checkView;
        [vc.view addSubview:tempView];
        return tempView;
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize viewSize = CGSizeMake(screenSize.width, screenSize.height/3*2);
    
    UIView *view = [[UIView alloc] init];
    void(^viewConfig)(void)=^{
        view.tag = 10000;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        view.layer.shadowOffset = CGSizeZero;
        view.layer.shadowOpacity = 1;
        view.frame = CGRectMake(0, 0, viewSize.width,viewSize.height);
        view.center = vc.view.center;
        [vc.view addSubview:view];
    };
    viewConfig();
    
    UILabel *labTitle = [[UILabel alloc] init];
    void(^labTitleConfig)(void)=^{
        UILabel*lab = labTitle;
        lab.tag = 100;
        lab.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        lab.numberOfLines = 0;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"检测swift类 需要添加@objcMembers";
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor redColor];
        lab.frame = CGRectMake(0,0, viewSize.width, 40);
        [view addSubview:lab];
    };
    labTitleConfig();
    
    YDTableView *tableview = [[YDTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labTitle.frame), viewSize.width, viewSize.height - CGRectGetMaxY(labTitle.frame) - 100) style:UITableViewStyleGrouped];
    void(^tableViewConfig)(void)=^{
        YDTableView *tab = tableview;
        tab.tag = 101;
        tab.backgroundColor = [UIColor whiteColor];
        tab.delegate = (id<UITableViewDelegate>)tab;
        tab.dataSource = (id<UITableViewDataSource>)tab;
        [tab reloadData];
        [view addSubview:tab];
    };
    tableViewConfig();
    
    UILabel *labRemind = [[UILabel alloc] init];
    void(^labRemindConfig)(void)=^{
        UILabel *lab = labRemind;
        lab.tag = 102;
        lab.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        lab.numberOfLines = 0;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor blackColor];
        lab.frame = CGRectMake(0, CGRectGetMaxY(tableview.frame), viewSize.width, 40);
        [view addSubview:lab];
    };
    labRemindConfig();
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    void(^btnConfig)(void)=^{
        UIButton*btn = btnConfirm;
        void(^imp_removeSelf)(UIView*) = ^(UIView * temp){
            [temp.superview removeFromSuperview];
        };
        SEL sel_removeSelf = sel_registerName("removeSelf");
        class_addMethod([btn class], sel_removeSelf,imp_implementationWithBlock(imp_removeSelf), "v@:");
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0,viewSize.height - 40, viewSize.width, 30);
        [btn addTarget:btn action:sel_removeSelf forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    };
    btnConfig();
    
    checkView = (__bridge_retained void*)view;
    return view;
}

@end
