//
//  FriendsCircleViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/11.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "FriendsCircleViewController.h"
#import "AppDelegate.h"
@interface FriendsCircleViewController ()

@end

@implementation FriendsCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"朋友圈";
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *url = [NSString stringWithFormat:@"http://www.oschina.net/action/api/active_list?catalog=1&pageIndex=0&pageSize=20&uid=%@",[AppDelegate globalDelegate]];
    NSLog(@"FriendsList__url:%@",url);
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
