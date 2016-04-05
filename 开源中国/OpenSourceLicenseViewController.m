//
//  OpenSourceLicenseViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/13.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "OpenSourceLicenseViewController.h"

@interface OpenSourceLicenseViewController ()

@end

@implementation OpenSourceLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"开源组件";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatOSLicenseComponent];
}
- (void)creatOSLicenseComponent{
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, 80)];
    label1.text = @"开源中国iphone客户端使用的开源组件";
    label1.font = [UIFont boldSystemFontOfSize:30];
    label1.numberOfLines = 0;
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 135, kScreenSize.width, 200)];
    label2.text = @"开源中国iphone客户端在开发过程中使用了下列第三方类库,组件,感谢开源社区的贡献:\nAFNetworking\nGDataXMLNode\nJVFloatingDrawer\nSDWebImage\nQFRefreshView\nFMDatabase\nReachability";
    label2.font = [UIFont systemFontOfSize:17];
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
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
