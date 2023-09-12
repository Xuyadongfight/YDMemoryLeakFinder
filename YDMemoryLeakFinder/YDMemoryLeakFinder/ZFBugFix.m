//
//  ZFBugFix.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/8/15.
//

#import "ZFBugFix.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark -----ZFBugFixModel-----

@interface ZFBugFixItemModel : NSObject
@property(strong,nonatomic)NSString *nameclass;
@property(strong,nonatomic)NSString *namesel;

@end

@implementation ZFBugFixItemModel

+(instancetype)decode:(NSDictionary*)dic{
    unsigned int count = 0;
    ZFBugFixItemModel *model = [[ZFBugFixItemModel alloc] init];
    objc_property_t *properties = class_copyPropertyList(self, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t item = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(item)];
        [model setValue:dic[propertyName] forKey:propertyName];
    }
    free(properties);
    return model;
}
@end




@interface ZFBugFixModel : NSObject
@property(strong,nonatomic)NSString *version;
@property(strong,nonatomic)NSArray<ZFBugFixItemModel*>*replaces;
@end

@implementation ZFBugFixModel

+(instancetype)decode:(NSDictionary*)dic{
    unsigned int count = 0;
    ZFBugFixModel *model = [[ZFBugFixModel alloc] init];
    objc_property_t *properties = class_copyPropertyList(self, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t item = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(item)];
        NSString *propertyAttri = [NSString stringWithUTF8String:property_getAttributes(item)];
        if (!dic[propertyName]) {
            continue;
        }
        
        if ([propertyAttri containsString:@"NSArray"] && [dic[propertyName] isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            [dic[propertyName] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZFBugFixItemModel *itemModel = [ZFBugFixItemModel decode:obj];
                [tempArr addObject:itemModel];
            }];
            [model setValue:tempArr forKey:propertyName];
        }else{
            [model setValue:dic[propertyName] forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

@end






#pragma mark -----ZFBugFixItem-----

@interface ZFBugFixItem : NSObject

@property(strong,nonatomic)NSString *nameNeedFixClass;
@property(strong,nonatomic)NSString *nameNeedFixSelInstance;


@property(strong,nonatomic)NSString *nameFixClass;
@property(strong,nonatomic)NSString *nameFixSelInstance;

@end

@implementation ZFBugFixItem

-(void)fix{
    [self isFixed:true];
}

-(BOOL)isFixed:(BOOL)ifNotFixed{
    Method *methods = [self getMethods];
    if (!methods) {
        return false;
    }
    Method methodNeedFix = methods[0];
    Method methodFix = methods[1];
    free(methods);
    IMP impNeedFix = method_getImplementation(methodNeedFix);
    IMP impFix = method_getImplementation(methodFix);
    BOOL isFixed = (impNeedFix == impFix);
    if (!isFixed && ifNotFixed) {
        method_setImplementation(methodNeedFix, impFix);
        return true;
    }
    return isFixed;
}

-(NSArray*)getClasses{
    Class classNeedFix = NSClassFromString(self.nameNeedFixClass);
    Class classFix = NSClassFromString(self.nameFixClass);
    if (!classNeedFix || !classFix) {
        NSLog(@"fix_error:类名错误");
        return nil;
    }
    return @[classNeedFix,classFix];
}

-(Method *)getMethods{
    NSArray *classes = [self getClasses];
    if (!classes) {
        return nil;
    }
    Method methodNeedFix = class_getInstanceMethod(classes[0], sel_registerName(self.nameNeedFixSelInstance.UTF8String));
    Method methodFix = class_getInstanceMethod(classes[1], sel_registerName(self.nameFixSelInstance.UTF8String));
    if (!methodNeedFix || !methodFix) {
        NSLog(@"fix_error:方法名错误");
        return nil;
    }
    Method *res = calloc(2, sizeof(Method));
    res[0] = methodNeedFix;
    res[1] = methodFix;
    return res;
}

@end





#pragma mark -----ZFBugFix-----

@implementation ZFBugFix

+ (void)fix{
    NSDictionary *dicInfo = [NSBundle mainBundle].infoDictionary;
    NSString *versionLocal = [dicInfo valueForKey:@"CFBundleShortVersionString"];
    
    [self request:@"http://localhost:8080/resources/replace.txt" finish:^(NSDictionary *res) {
        if (res) {
            ZFBugFixModel *model = [ZFBugFixModel decode:res];
            if ([model.version isEqualToString:versionLocal]) {
                [model.replaces enumerateObjectsUsingBlock:^(ZFBugFixItemModel * _Nonnull itemModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZFBugFixItem *fixItem = [[ZFBugFixItem alloc] init];
                    fixItem.nameNeedFixClass = itemModel.nameclass;
                    fixItem.nameNeedFixSelInstance = itemModel.namesel;
                    
                    fixItem.nameFixClass = @"ZFBugFix";
                    fixItem.nameFixSelInstance = @"fixFuncCommonly";
                    [fixItem fix];
                }];
            }
        }
    }];
    
}

+(void)request:(NSString *)strUrl finish:(void(^)(NSDictionary*))finished{
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession* session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            finished(jsonObj);
        }else{
            NSLog(@"response = %@ error = %@",response,error);
            finished(nil);
        }
    }];
    [task resume];
}

-(id)fixFuncCommonly{
    NSLog(@"%@ 修复后",self);
    return self;
}

@end
