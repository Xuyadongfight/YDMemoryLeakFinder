//
//  ViewController.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (copy,nonatomic)void(^callBack)(void);

@end

