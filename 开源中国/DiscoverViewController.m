//
//  DiscoverViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "DiscoverViewController.h"
#import "FriendsCircleViewController.h"
#import "SeekViewController.h"
#import "ActivityViewController.h"
#import "ScanViewController.h"
#import "ShakeViewController.h"

#define kCellId @"CellId"
@interface DiscoverViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataSource1;
@property (nonatomic) NSArray *dataSource2;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource1 = @[@[@"好友圈"],@[@"找人",@"活动"],@[@"扫一扫",@"摇一摇"]];
    self.dataSource2 = @[@[@"discover-events"],@[@"discover-search",@"discover-activities"],@[@"discover-scan",@"discover-shake"]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-49) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource1.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource1[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.dataSource2[indexPath.section][indexPath.row]];
    cell.textLabel.text = self.dataSource1[indexPath.section][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *vc = @[@[@"FriendsCircleViewController"],@[@"SeekViewController",@"ActivityViewController"],@[@"ScanViewController",@"ShakeViewController"]];
    Class class = NSClassFromString(vc[indexPath.section][indexPath.row]);
    BaseViewController *anyVC = [[class alloc] init];
    anyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:anyVC animated:YES];
    
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
