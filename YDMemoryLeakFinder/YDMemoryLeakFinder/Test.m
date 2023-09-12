//
//  Test.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/7/21.
//

#import "Test.h"

typedef struct{
    char i;
    int j;
    char k;
}structA;

typedef struct{
    int a;
    double b;
}structB;

typedef struct{
    int a;
}structGeneral;







#define Bits struct{ \
    uintptr_t bit_0 : 1; \
    uintptr_t bit_1 : 1; \
    uintptr_t bit_2 : 1; \
    uintptr_t bit_3 : 1; \
    uintptr_t bit_4 : 1; \
    uintptr_t bit_5 : 1; \
    uintptr_t bit_6 : 1; \
    uintptr_t bit_7 : 1; \
}

typedef union{
    char ptr;
    Bits;
}CharUnion;

@implementation Test

-(NSArray*)func1:(int [])arg1{
    return nil;
}

+ (void)start{
    structA *p = 0;
    int temp = &(p->k);
    
}
@end
