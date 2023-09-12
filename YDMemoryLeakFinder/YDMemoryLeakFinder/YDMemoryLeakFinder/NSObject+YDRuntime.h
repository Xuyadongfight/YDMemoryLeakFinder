//
//  NSObject+YDRuntime.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/8/11.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct{
    char *name;
    char *types;
}YDMethodDes;

typedef struct{
    char *name;
    char *type;
    ptrdiff_t offset;
}YDIvar;

typedef struct{
    char *name;
    char *attributes;
}YDProperty;

typedef struct{
    char *name;
    void *implementation;
    char *typeEncoding;
    unsigned int numberOfArguments;
    YDMethodDes *methodDes;
    char *returnType;
    char * _Nonnull argumentTypes;
}YDMethod;



@interface NSObject (YDRuntime)
+(NSPointerArray*)YDIvars;
+(NSPointerArray*)YDProperties;
+(NSPointerArray*)YDMethods;

@end

NS_ASSUME_NONNULL_END
