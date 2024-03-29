//
//  UIViewController+YDCommon.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YDCommon)
-(void)addBtn:(NSString *)title frame:(CGRect)frame action:(void(^)(UIButton*))action;
@end

NS_ASSUME_NONNULL_END
