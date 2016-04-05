//
//  AppDelegate.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "GDataXMLNode.h"
// pod 导入第三方库 不提示解决方法
// #import "AFNetworking.h"
// 工程 target --> build setting  --> search path  --> user header search path 双击 输入$(PODS_ROOT) 选择 recursive  意思时递归搜索Pods 文件夹

@interface AppDelegate ()

@end

@implementation AppDelegate

/* 此工程 编译环境为 ARC */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    isLogin = NO;// 初始化未登录
    [UMSocialData setAppKey:@"5555dea8e0f55a718f000e2b"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[application setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //application.statusBarStyle = UIStatusBarStyleLightContent;
    // 手机摇动
    application.applicationSupportsShakeToEdit = YES;
    // 配置 跟视图控制器 及动画视图
    self.window.rootViewController = self.drawerViewController;
    [self configDrawerViewController];
    
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"menu-background(375x667)"]];
    [self.window makeKeyAndVisible];
    return YES;
}
// 第三方 视图 动画
- (JVFloatingDrawerViewController *)drawerViewController{
    if (!_drawerViewController) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
    }
    return _drawerViewController;
}
// 可以配置自己需要的动画
- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    
    return _drawerAnimator;
}
// tabbar tableView
- (LeftViewController *)leftViewController{
    if (!_leftViewController) {
        _leftViewController = [[LeftViewController alloc] init];
    }
    return _leftViewController;
}
- (MyTabBarViewController *)centerViewController{
    if (!_centerViewController) {
        _centerViewController = [[MyTabBarViewController alloc] init];
    }
    return _centerViewController;
}
- (void)configDrawerViewController{
    self.drawerViewController.leftViewController = self.leftViewController;
    self.drawerViewController.centerViewController = self.centerViewController;
    self.drawerViewController.animator = self.drawerAnimator;
    self.drawerViewController.backgroundImage = [UIImage imageNamed: @"menu-background(375x667)"];
}

#pragma mark - Global Access Helper

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}

- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideRight animated:animated completion:nil];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
