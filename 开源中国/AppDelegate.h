//
//  AppDelegate.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTabBarViewController.h"
#import "LeftViewController.h"

#import "JVFloatingDrawerSpringAnimator.h"
#import "JVFloatingDrawerViewController.h"

// 全局变量 标记是否登录
BOOL isLogin;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, copy) NSString *myAuthorId;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;

@property (nonatomic, strong) MyTabBarViewController *centerViewController;
@property (nonatomic, strong) LeftViewController *leftViewController;

+ (AppDelegate *)globalDelegate;

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated;

@end

