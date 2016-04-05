//
//  SettingViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/1.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "OpenSourceLicenseViewController.h"

#import "SDImageCache.h"

extern BOOL isLogin;

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"设置";
    self.dataSource = @[@[@"清除缓存"],@[@"意见反馈",@"给应用评分",@"关于",@"开源许可"],@[@"注销登录"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    
    return cell;
}
// SDWebImage下载图片是异步的 下载完成之后 会自动放在沙盒 中的Library/Cache/com.hackemist.SDWebImageCache.default 目录下作为缓存，下次再加载同一个 如果缓存有那么就直接从缓存获取，如果没有再异步下载

//异步下载图片 第二个参数就是一个预加载图片 加载完成之后会替换掉真正的图片

/*
 下面的方法 可以 清除SDImage在沙盒中的缓存  缓存单位 b
 SDImageCache * cache = [SDImageCache sharedImageCache];
 // 1.内存
 [cache clearMemory];
 // 1.磁盘
 [cache clearDisk];
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *flag = @[@[@1],@[@2,@3,@4,@5],@[@6]];
    NSNumber *num = flag[indexPath.section][indexPath.row];
    switch (num.integerValue) {
        case 1:
        {
            [self isClearCache];
        }
            break;
        case 2:
        {
            FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedback animated:YES];
        }
            break;
        case 3:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/kai-yuan-zhong-%20guo/id524298520?mt=8"]];
        }
            break;
        case 4:
        {
            AboutViewController *about = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        case 5:
        {
            OpenSourceLicenseViewController *open = [[OpenSourceLicenseViewController alloc] init];
            [self.navigationController pushViewController:open animated:YES];
        }
            break;
        case 6:
        {
            [self logOut];
        }
            break;
        default:
            break;
    }
    
}
// 缓存清理
- (void)isClearCache{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定清除缓存的图片和文件?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }else if (buttonIndex == alertView.cancelButtonIndex+1){
        SDImageCache *cache = [SDImageCache sharedImageCache];
        NSUInteger size = [cache getSize];
        NSUInteger diskCount = [cache getDiskCount];
        [cache clearMemory],[cache clearDisk];
        NSString *msg = [NSString stringWithFormat:@"本次清理了%lu 张图片,共%lu kb",diskCount,size*1024];
        UIAlertView *aView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [aView show];
    }
}
// 注销登录 没有接口
- (void)logOut{
    if (isLogin) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"注销成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        isLogin = NO;// 设置全局变量
        [[NSNotificationCenter defaultCenter] postNotificationName: kLogout object:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"用户未登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
