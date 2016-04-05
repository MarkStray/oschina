//
//  PersonalCenterViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "GDataXMLNode.h"
#import "SegmentEngine.h"
#import "AppDelegate.h"


@interface PersonalCenterViewController ()
@end
@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"消息中心";
    [self initPageWithArrays];
}
- (void)initPageWithArrays{
    NSArray *titles = @[@"@我",@"评论",@"留言",@"粉丝",@"动弹"];
    NSString *url1 = [NSString stringWithFormat:@"http://www.oschina.net/action/api/active_list?catalog=2&pageIndex=0&pageSize=20&uid=%@",[AppDelegate globalDelegate].myAuthorId];
    NSString *url2 = [NSString stringWithFormat:@"http://www.oschina.net/action/api/active_list?catalog=3&pageIndex=0&pageSize=20&uid=%@",[AppDelegate globalDelegate].myAuthorId];
    NSString *url3 = [NSString stringWithFormat:@"http://www.oschina.net/action/api/message_list?uid=%@&pageIndex=0&pageSize=20",[AppDelegate globalDelegate].myAuthorId];
    NSString *url4 = [NSString stringWithFormat:@"http://www.oschina.net/action/api/friends_list?uid=%@&relation=0&pageIndex=0&pageSize=20",[AppDelegate globalDelegate].myAuthorId];
    NSString *url5 = @"http://www.oschina.net/action/api/my_tweet_like_list";
    NSArray *urls = @[url1,url2,url3,url4,url5];
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
