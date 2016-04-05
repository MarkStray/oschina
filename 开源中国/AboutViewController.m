//
//  AboutViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/13.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "AboutViewController.h"
#import "OpenSourceLicenseViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"关于";
}
- (IBAction)osLicenseClick:(UIButton *)sender {
    OpenSourceLicenseViewController *os = [[OpenSourceLicenseViewController alloc] init];
    [self.navigationController pushViewController:os animated:YES];
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
