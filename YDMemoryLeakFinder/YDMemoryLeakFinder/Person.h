//
//  Person.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/1/17.
//

#import <Foundation/Foundation.h>



@interface Person : NSObject
@property(nonatomic,strong)NSString *strStrong;
@property(nonatomic,copy)NSString *strCopy;
@property(nonatomic,strong)NSMutableString *strMutStrong;
@property(nonatomic,copy)NSMutableString *strMutCopy;

- (void)sayHello:(NSString *)person comment:(NSString *)comment;

@end


