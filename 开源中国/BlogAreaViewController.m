//
//  BlogAreaViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/9.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BlogAreaViewController.h"
#import "NewsDetailViewController.h"
#import "SegmentEngine.h"
#import "NewsCell.h"
#import "NewsModel.h"
#import "GDataXMLNode.h"
@interface BlogAreaViewController ()

@end

@implementation BlogAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"博客区";
    [self initPageWithArrays];
}
- (void)initPageWithArrays{
    NSArray *titles = @[@"最新博客",@"推荐阅读"];
    NSString *url1 = @"http://www.oschina.net/action/api/blog_list?type=latest&pageIndex=%ld&pageSize=20";
    NSString *url2 = @"http://www.oschina.net/action/api/blog_list?type=recommend&pageIndex=%ld&pageSize=20";
    NSArray *urls = @[url1,url2];
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
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [doc nodesForXPath:@"//blog" error:nil];
    for (GDataXMLElement *element in arr) {
        NewsModel *model = [[NewsModel alloc] init];
        NSDictionary *dict = [element subDictWithArray:@[@"id",@"title",@"body",@"commentCount",@"authoruid",@"pubDate",@"url",@"authorname",@"documentType"]];
        [model setValuesForKeysWithDictionary:dict];
        [dataArray addObject:model];
    }
}
// 这里的方法自己调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil]lastObject];
    }
    NewsModel *model = dataArray[indexPath.row];
    [cell showDataWithModel:model category:@"blog"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    NewsModel *model = dataArray[indexPath.row];
    NewsDetailViewController *news = [[NewsDetailViewController alloc] init];
    news.model = model;
    news.tableViewTag = 1003;
    news.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:news animated:YES];
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
