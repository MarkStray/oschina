//
//  OpenSoftwareViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/9.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "OpenSoftwareViewController.h"
#import "SegmentEngine.h"
#import "OpenSoftwareModel.h"
#import "GDataXMLNode.h"
#import "NewsDetailViewController.h"
@interface OpenSoftwareViewController ()

@end

@implementation OpenSoftwareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"开源软件";
    [self initPageWithArrays];
}
- (void)initPageWithArrays{
    NSArray *titles = @[@"推荐",@"最新",@"热门",@"国产"];
    NSString *url2 = @"http://www.oschina.net/action/api/software_list?searchTag=recommend&pageIndex=%ld&pageSize=20";
    NSString *url3 = @"http://www.oschina.net/action/api/software_list?searchTag=time&pageIndex=%ld&pageSize=20";
    NSString *url4 = @"http://www.oschina.net/action/api/software_list?searchTag=view&pageIndex=%ld&pageSize=20";
    NSString *url5 = @"http://www.oschina.net/action/api/software_list?searchTag=list_cn&pageIndex=%ld&pageSize=20";
    NSArray *urls = @[url2,url3,url4,url5];
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
    NSArray *array = [doc nodesForXPath:@"//software" error:nil];
    for (GDataXMLElement *ele in array) {
        OpenSoftwareModel *model = [[OpenSoftwareModel alloc] init];
        [model setValuesForKeysWithDictionary:[ele subDictWithArray:@[@"name",@"description",@"url"]]];
        [dataArray addObject:model];
    }
}
// 这里的方法自己调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableViewCell"];
    }
    OpenSoftwareModel *model = dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.description;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
     OpenSoftwareModel *model = dataArray[indexPath.row];
    NewsDetailViewController *news = [[NewsDetailViewController alloc] init];
    news.tableViewTag = 999;
    news.model.author = model.name;
    news.model.title = model.description;
    news.model.url = model.url;
    news.model.id = model.id;
    NSLog(@"-------1-------self.model.id--------------- %@",news.model.id);
    NSLog(@"-------2-------self.model.id--------------- %@",model.id);
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
