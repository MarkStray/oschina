//
//  LoginDetailViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LoginDetailViewController.h"
#import "UIButton+WebCache.h"
@interface LoginDetailViewController ()

@end

@implementation LoginDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.iconButton.layer.masksToBounds = YES;
    self.iconButton.layer.cornerRadius = 25;
    self.navigationItem.title = @"我的资料";
    [self.iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.portrait] forState:UIControlStateNormal];
    self.iconNameLabel.text = self.model.name;
    self.locationLabel.text = self.model.location;
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

- (IBAction)iconButtonClick:(id)sender {
}
@end
