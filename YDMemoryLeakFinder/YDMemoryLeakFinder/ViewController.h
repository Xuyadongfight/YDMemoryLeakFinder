//
//  ViewController.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "ZFWeakProxy.h"
#import <Foundation/Foundation.h>
#import "Person.h"

@interface ViewController : UIViewController
@property (class)void(^callBack)(void);
@property (getter = myFirstname,setter = myFirstName:)NSString * const firstName;
@property (copy)NSString *myCopyName;
@property NSMutableString *myMCopyName;
@property (strong,nonatomic)NSArray*arrName;

@property(nonatomic,copy)NSString *name;
@property(atomic,strong)Person *person;
@end


