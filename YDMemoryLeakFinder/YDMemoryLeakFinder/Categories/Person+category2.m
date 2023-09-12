//
//  Person+category2.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/1/17.
//

#import "Person+category2.h"

@implementation Person (category2)
+ (void)load{
    printf("%s\n",__func__);
}
//+ (void)initialize{
//    printf("%s\n",__func__);
//}
@end
