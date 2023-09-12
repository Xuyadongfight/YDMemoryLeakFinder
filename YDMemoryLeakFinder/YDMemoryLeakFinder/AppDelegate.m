//
//  AppDelegate.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2021/6/8.
//

#import "AppDelegate.h"
#import "ZFBugFix.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ZFBugFix fix];
    return YES;
}


@end
