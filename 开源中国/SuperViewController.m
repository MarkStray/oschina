//
//  SuperViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = K_BG_WHITE_COLOR;
    [self creatNavigationBar];
    [self clickLeftNavigationBarButtom];
}
- (void)clickLeftNavigationBarButtom{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancleClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)creatNavigationBar{
    // 改变状态栏的颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = K_BLUE_COLOR;// 背景1
    // 导航条 背景
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 导航条 标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)CancleClick{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"模态跳转返回");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
