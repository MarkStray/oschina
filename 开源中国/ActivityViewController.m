//
//  ActivityViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/11.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "ActivityViewController.h"
#import "SegmentEngine.h"
#import "AppDelegate.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"活动";
    [self initPageWithArrays];
}
- (void)initPageWithArrays{
    NSArray *titles = @[@"近期活动",@"我的活动"];
    NSString *url = [NSString stringWithFormat:@"http://www.oschina.net/action/api/event_list?uid=%@&pageIndex=0&pageSize=20",[AppDelegate globalDelegate].myAuthorId];
    NSArray *urls = @[url];
    SegmentEngine *engine = [[SegmentEngine alloc] initWithItems:titles];
    [engine firstDownloadWithUrlArray:urls complete:^(id responseData, NSMutableArray *dataArray) {
        [self parseDataWith:responseData array:dataArray];
    }];
    [engine creatTableViewWithController:self];
    // 处理 tableView 代理方法
    [engine setCellForRowCB:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath WithArray:dataArray];
    }];
    [engine setHeightForRowCB:^CGFloat(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        return [self tableView:tableView heightForRowAtIndexPath:indexPath WithArray:dataArray];
    }];
    [engine setDidSelectRowCB:^(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        [self tableView:tableView didSelectRowAtIndexPath:indexPath WithArray:dataArray];
    }];
    [self.view addSubview:engine];
}
- (void)parseDataWith:(id)responseData array:(NSMutableArray *)dataArray{
}
// 这里的方法自己调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    
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
