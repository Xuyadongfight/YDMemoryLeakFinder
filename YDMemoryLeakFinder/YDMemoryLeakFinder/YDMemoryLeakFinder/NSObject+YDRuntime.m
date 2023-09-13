//
//  NSObject+YDRuntime.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/8/11.
//

#if DEBUG

#import "NSObject+YDRuntime.h"


@implementation NSObject (YDRuntime)

+ (NSPointerArray*)YDIvars{
    unsigned int count = 0;
    NSPointerArray *arr = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory];
    
    Ivar* ivars = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        YDIvar *ptrIvar = malloc(sizeof(YDIvar));
        ptrIvar->name = strdup(ivar_getName(ivar));
        ptrIvar->type = strdup(ivar_getTypeEncoding(ivar));
        ptrIvar->offset = ivar_getOffset(ivar);
        [arr addPointer:ptrIvar];
    }
    free(ivars);
    return arr;
}
+ (NSPointerArray *)YDProperties{
    unsigned int count = 0;
    NSPointerArray *arr = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory];
    
    objc_property_t *properties = class_copyPropertyList(self, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        YDProperty *ptrProperty = malloc(sizeof(YDProperty));
        ptrProperty->name = strdup(property_getName(property));
        ptrProperty->attributes = strdup(property_getAttributes(property));
        [arr addPointer:ptrProperty];
    }
    free(properties);
    return arr;
}

+ (NSPointerArray *)YDMethods{
    unsigned int count = 0;
    NSPointerArray *arr = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory];
    
    Method *methods = class_copyMethodList(self, &count);
    for (int i = 0; i < count; i++) {
        int size = sizeof(char*);
        
        Method method = methods[i];
        YDMethod *ptrMethod = malloc(sizeof(YDMethod));
        ptrMethod->name = strdup(sel_getName(method_getName(method)));
        ptrMethod->implementation = method_getImplementation(method);
        ptrMethod->typeEncoding = strdup(method_getTypeEncoding(method));
        ptrMethod->numberOfArguments = method_getNumberOfArguments(method);
        
        char*ret= malloc(size);
        method_getReturnType(method, ret, size);
        ptrMethod->returnType = ret;
        
        int num = ptrMethod->numberOfArguments;

        char *arguments = malloc(num*size);
        for (int j = 0; j < num; j++) {
//            char *tmpArg = malloc(size);
            method_getArgumentType(method, j,arguments + j*size, size);
//            strcpy(arguments + j*size, tmpArg);
//            free(tmpArg);
        }
        ptrMethod->argumentTypes = arguments;
        
        
        YDMethodDes *des = malloc(sizeof(YDMethodDes));
        struct objc_method_description* desM = method_getDescription(method);
        des->name = strdup(sel_getName(desM->name));
        des->types = desM->types;
        ptrMethod->methodDes = des;
        [arr addPointer:ptrMethod];
    }
    free(methods);
    return arr;
}

@end

#endif
