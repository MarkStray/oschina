//
//  BaseViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchResultViewController.h"
#import "SettingViewController.h"
#import "BlogAreaViewController.h"
#import "OpenSoftwareViewController.h"
#import "QATechnologyViewController.h"
#import "LoginViewController.h"
#import "LeftViewController.h"
#import "AppDelegate.h"

extern BOOL isLogin;

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(5, 5)],UITextAttributeTextShadowColor:[UIColor grayColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNavigationBar];
    [self handleNotificationEvent];
}
- (void)handleNotificationEvent{
    // 将要进行登录 退出登录 界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShouldLoginMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLoginView:) name:kShouldLoginMessage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLeftViewLetNavigationPushControllers object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationEvent:) name:kLeftViewLetNavigationPushControllers object:nil];
}
- (void)pushLoginView:(NSNotification *)notify{
    NSLog(@"BASE_BOOL_ISLOGIN : %d",isLogin);
    if (!isLogin) {
        kDebugSeparator();
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)handleNotificationEvent:(NSNotification *)notify{
    NSInteger tag = [notify.userInfo[@"IndexPathRow"] integerValue];
    switch (tag) {
        case 0:
        {
            QATechnologyViewController *qa = [[QATechnologyViewController alloc] init];
            [self.navigationController pushViewController:qa animated:YES];
        }
            break;
        case 1:
        {
            OpenSoftwareViewController *openS = [[OpenSoftwareViewController alloc] init];
            [self.navigationController pushViewController:openS animated:YES];
        }
            break;
        case 2:
        {
            BlogAreaViewController *blogArea = [[BlogAreaViewController alloc] init];
            [self.navigationController pushViewController:blogArea animated:YES];
        }
            break;
        case 3:
        {
            SettingViewController *setting = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:setting animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 自定义导航栏   // 背景1
- (void)creatNavigationBar{
    // 改变状态栏的颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = K_BLUE_COLOR;// 背景1
    // 导航条 背景
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 导航条 标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 状态栏
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];// 前景
    //[self.navigationController.navigationBar setBackgroundImage: nil forBarMetrics:UIBarMetricsDefaultPrompt];
    

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"menu-nav"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    leftItem.tag = 101;
    rightItem.tag = 102;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 自定义导航栏  // 背景2
- (void)setStatusBar{
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, kScreenSize.width, 20)];
    
    //将它的颜色设置成你所需要的，这里我选择了黑色，表示我很沉稳
    
    statusBarView.backgroundColor=[UIColor blackColor];
    
    //这里我的思路是：之前不理想的状态是状态栏颜色也变成了导航栏的颜色，但根据这种情况，反而帮助我判断出此时的状态栏也是导航栏的一部分，而状态栏文字浮于上方，因此理论上直接在导航栏上添加一个subview就是他们中间的那一层了。
    
    //推得这样的代码：
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //修改导航栏文字颜色，这里我选择白色，表示我很纯洁
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置导航栏的背景图片
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg.jpg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)leftItemClick{
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
- (void)rightItemClick{
#if 0
    // 添加一个专场动画  e
    CATransition *animation = [CATransition animation];
    animation.type = @"rippleEffect";// 动画类型 kCATransitionFade
    animation.subtype = kCAGravityCenter;// kCATransitionFromLeft
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];// 加物理特效
    animation.duration = 1;
    [self.navigationController.view.layer addAnimation:animation forKey:@"key"];
#endif
    SearchResultViewController *search = [[SearchResultViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation---
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
