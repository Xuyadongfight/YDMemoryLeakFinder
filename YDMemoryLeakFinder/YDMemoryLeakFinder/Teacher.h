//
//  Teacher.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/1/17.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Teacher : Person
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)int age;
@end

NS_ASSUME_NONNULL_END
