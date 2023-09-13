//
//  NSObject+YDHacking.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#if DEBUG

#import "NSObject+YDHacking.h"
#import <UIKit/UIKit.h>
#import "YDMemoryLeakManager.h"
#import <objc/runtime.h>
#import "YDTableView.h"
#import "NSObject+YDRuntime.h"

#define YD_FreeArr(x) if(x != NULL){free(x);x = NULL;}



UIView*checkView;
NSMutableArray *propertys;

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
        [weakSelf YD_CheckMemoryLeak];
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

-(void)YDFunc(CheckMemoryLeak){
    NSPointerArray *ivars = [[self class] YDIvars];
    NSPointerArray *pros = [[self class] YDProperties];
    NSPointerArray *methods = [[self class] YDMethods];
    
    NSMutableArray *ivarDics = [[NSMutableArray alloc] init];
    for(int i = 0;i < ivars.count;i++){
        NSString *name = [NSString stringWithUTF8String:((YDIvar*)[ivars pointerAtIndex:i])->name];
        NSString *type = [NSString stringWithUTF8String:((YDIvar*)[ivars pointerAtIndex:i])->type];
        [ivarDics addObject:@{@"name":name,@"type":type}];
    }
    
    NSMutableArray *proDics = [[NSMutableArray alloc] init];
    for(int i = 0;i < pros.count;i++){
        NSString *name = [NSString stringWithUTF8String:((YDProperty*)[pros pointerAtIndex:i])->name];
        NSString *type = [NSString stringWithUTF8String:((YDProperty*)[pros pointerAtIndex:i])->attributes];
        [proDics addObject:@{@"name":name,@"type":type}];
    }
    
    NSMutableArray *methodDics = [[NSMutableArray alloc] init];
    for(int i = 0;i < methods.count;i++){
        NSString *name = [NSString stringWithUTF8String:((YDMethod*)[methods pointerAtIndex:i])->name];
        NSString *type = [NSString stringWithUTF8String:((YDMethod*)[methods pointerAtIndex:i])->typeEncoding];
        [methodDics addObject:@{@"name":name,@"type":type}];
    }
    
    NSMutableArray*proAllNames = [[NSMutableArray alloc] init];//所有属性
    NSMutableArray*proRefNames = [[NSMutableArray alloc] init];//所有对象类型属性
    NSMutableArray*proNoRefNames = [[NSMutableArray alloc] init];//所有非对象类型属性
    
    for (int i = 0;i<proDics.count;i++){
        NSDictionary *proDic = proDics[i];
        NSString *proName = proDic[@"name"];
        NSString *proType = proDic[@"type"];
        [proAllNames addObject:proName];
        //筛选出对象属性
        if ([self isClassProperty:proType]){
            [proRefNames addObject:proName];
        }else{
            [proNoRefNames addObject:proName];
        }
    }
    
    NSMutableArray *ivarAllNames = [[NSMutableArray alloc] init];//所有成员变量
    NSMutableArray *ivarRefNames = [[NSMutableArray alloc] init];//对象类型成员变量
    NSMutableArray *ivarNoRefNames = [[NSMutableArray alloc] init];//非对象类型或未知类型成员变量
    
    for (int i = 0;i<ivarDics.count;i++){
        NSDictionary *ivarDic = ivarDics[i];
        NSString *ivarName = ivarDic[@"name"];
        NSString *ivarType = ivarDic[@"type"];
        [ivarAllNames addObject:ivarName];
        //筛选出对象成员变量
        if ([self isClassIvar:ivarType]){
            [ivarRefNames addObject:ivarName];
        }else{
            [ivarNoRefNames addObject:ivarName];
        }
    }
    
    NSMutableArray *methodSets = [[NSMutableArray alloc] init];//所有set方法
    for (int i = 0; i< methodDics.count;i++){
        NSDictionary *methodDic = methodDics[i];
        NSString *methodName = methodDic[@"name"];
        if ([self isSetMethod:methodName]){
            [methodSets addObject:methodName];
        }
    }
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (int i = 0; i < proAllNames.count;i++){
        YDTableViewCellModel *model = [[YDTableViewCellModel alloc] init];
        model.name = proAllNames[i];
        model.status = unChecked;
        [models addObject:model];
    }
    
    propertys = models;
    [self YD_getCheckView];
    
    UITableView* tab = [checkView viewWithTag:101];
    [tab reloadData];
    
    void*ptrSelf = (__bridge void*)self;
    CFIndex preRefCount = CFGetRetainCount(ptrSelf);
    CFRetain(ptrSelf);
    CFIndex afterRefCount = CFGetRetainCount(ptrSelf);
    
    if(preRefCount < afterRefCount){//可以检测
        [self checkProperty:models refPropertyNames:proRefNames setMethods:methodSets index:0];
    }else{
        UIAlertController *altVC = [UIAlertController alertControllerWithTitle:@"检测失败" message:@"无法转为Core Foundation对象" preferredStyle:UIAlertControllerStyleAlert];
        [altVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [[self YD_getCurrentVC] presentViewController:altVC animated:true completion:nil];
        CFRelease(ptrSelf);
        ptrSelf = NULL;
    }

}

-(void)checkProperty:(NSArray*)models refPropertyNames:(NSArray*)refNames setMethods:(NSArray*)setMethods index:(int)index{
    void*ptrSelf = (__bridge void*)self;
    
    UITableView* tab = [checkView viewWithTag:101];
    [tab reloadData];
    if (index >= models.count) {
        CFRelease(ptrSelf);
        return;
    }
    
    YDTableViewCellModel* model = models[index];
    __weak typeof(self)weakSelf = self;
    if ([refNames containsObject:model.name]) {//是对象类型
        NSString *setMethodName = [NSString stringWithFormat:@"set%@%@:",[model.name substringToIndex:1].uppercaseString,[model.name substringFromIndex:1]];
        if ([setMethods containsObject:setMethodName]) {//有set方法
            __weak id property = [self valueForKey:model.name];
            

            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                CFIndex countPre = CFGetRetainCount(ptrSelf);
                if ([property isKindOfClass:[NSTimer class]]) {//对定时器做特殊处理
                    [(NSTimer*)property invalidate];
                }
                if ([property isKindOfClass:[CADisplayLink class]]) {
                    [(CADisplayLink*)property invalidate];//对CADisplayLink做特殊处理
                }
                [weakSelf setValue:nil forKey:model.name];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    CFIndex countAfter = CFGetRetainCount(ptrSelf);
                    NSLog(@"name = %@ pre = %ld after = %ld",model.name,countPre,countAfter);
                    if (countPre == countAfter) {
                        model.status = checkedOk;
                    }else{
                        model.status = checkError;
                    }
                    [weakSelf checkProperty:models refPropertyNames:refNames setMethods:setMethods index:index + 1];
                });
            });
        }else{
            model.status = checkedOk; //没有set方法认为是不能强引用的
            [weakSelf checkProperty:models refPropertyNames:refNames setMethods:setMethods index:index + 1];
        }
    }else{
        model.status = checkedOk;//非对象类型属性 认为是不能强引用的
        [weakSelf checkProperty:models refPropertyNames:refNames setMethods:setMethods index:index + 1];
    }
    
}



-(BOOL)isClassProperty:(NSString*)propertyType{
    BOOL isClassProperty = false;
    if (propertyType.length >= 2){
        if ([[propertyType substringToIndex:2] isEqualToString:@"T@"]){
            isClassProperty = true;
        }
    }
    return isClassProperty;
}
-(BOOL)isClassIvar:(NSString*)ivarType{
    BOOL isClassIvar = false;
    if (ivarType.length >= 1){
        if ([[ivarType substringToIndex:1] isEqualToString:@"@"]){
            isClassIvar = true;
        }
    }
    return isClassIvar;
}

-(BOOL)isSetMethod:(NSString *)methodName{
    BOOL isSetMethod = false;
    if (methodName.length >= 3) {
        if ([[methodName substringToIndex:3] isEqualToString:@"set"]){
            isSetMethod = true;
        }
    }
    return isSetMethod;
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

//MARK: -checkview

-(UIView*)YDFunc(getCheckView){
    UIViewController *vc = [self YD_getCurrentVC];
    
    if (checkView != NULL){
        UIView *tempView = checkView;
        [vc.view addSubview:tempView];
        return tempView;
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat gapH = 20;
    CGSize viewSize = CGSizeMake(screenSize.width - 2 * gapH, screenSize.height/3*2);
    
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
        lab.text = @"检测swift类 需要添加@objcMembers,并且属性的访问控制范围不能是private或者fileprivate，否则访问不到对应的属性";
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor redColor];
        lab.frame = CGRectMake(0,0, viewSize.width, 60);
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
        lab.text = @"remind";
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
    
    checkView = view;
    return view;
}

@end

#endif
