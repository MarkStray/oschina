//
//  QATechnologyViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/9.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "QATechnologyViewController.h"
#import "UserInforViewController.h"
#import "SegmentEngine.h"
#import "GDataXMLNode.h"
#import "LZXHelper.h"
#import "QAModel.h"
#import "QACell.h"
#import "NewsModel.h"
#import "NewsDetailViewController.h"
@interface QATechnologyViewController ()

@end

@implementation QATechnologyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"技术问答";
    [self initPageWithArrays];
}
- (void)initPageWithArrays{
    NSArray *titles = @[@"提问",@"分享",@"综合",@"职业",@"站务"];
    NSString *url1 = @"http://www.oschina.net/action/api/post_list?catalog=1&pageIndex=%ld&pageSize=20";
    NSString *url2 = @"http://www.oschina.net/action/api/post_list?catalog=2&pageIndex=%ld&pageSize=20";
    NSString *url3 = @"http://www.oschina.net/action/api/post_list?catalog=3&pageIndex=%ld&pageSize=20";
    NSString *url4 = @"http://www.oschina.net/action/api/post_list?catalog=4&pageIndex=%ld&pageSize=20";
    NSString *url5 = @"http://www.oschina.net/action/api/post_list?catalog=5&pageIndex=%ld&pageSize=20";
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
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData encoding:NSUTF8StringEncoding error:nil];
    NSArray *postArray = [doc nodesForXPath:@"//post" error:nil];
    for (GDataXMLElement *ele in postArray) {
        QAModel *model = [[QAModel alloc] init];
        [model setValuesForKeysWithDictionary:[ele subDictWithArray:@[@"id",@"portrait",@"author",@"authorid",@"title",@"body",@"answerCount",@"viewCount",@"pubDate"]]];

        GDataXMLElement *element = [[ele elementsForName:@"answer"] lastObject];
        model.name = [element stringValueByName:@"name"];
        model.time = [element stringValueByName:@"time"];
        [dataArray addObject:model];
    }
}
// 这里的方法自己调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    QAModel *model = dataArray[indexPath.row];
    QACell *cell = [tableView dequeueReusableCellWithIdentifier:@"QACell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QACell" owner:self options:nil] lastObject];
    }
    [cell updateUIUsingModel:model complete:^{
        UserInforViewController *user = [[UserInforViewController alloc] init];
        user.authorid = model.authorid;
        user.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:user animated:YES];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    CGFloat height = 20;
    QAModel *model = dataArray[indexPath.row];
    if (model.title) {
        height += [LZXHelper textHeightFromTextString:model.title width:kScreenSize.width-60 fontSize:14] + 5;
    }
    if (model.body) {
        height += [LZXHelper textHeightFromTextString:model.body width:kScreenSize.width-60 fontSize:12];
    }
    return height + 15;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    QAModel *model = dataArray[indexPath.row];
    NSLog(@"QAModel__id:%@",model.id);
    NewsModel *newsModel = [[NewsModel alloc] init];
    NSDictionary *dict = @{@"id":model.id,@"portrait":model.portrait,@"author":model.author,@"authorid":model.authorid,@"title":model.title,@"body":model.body,@"answerCount":model.answerCount,@"viewCount":model.viewCount,@"pubDate":model.pubDate};
    [newsModel setValuesForKeysWithDictionary:dict];
    NewsDetailViewController *news = [[NewsDetailViewController alloc] init];
    news.tableViewTag = 997;
    news.model = newsModel;
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
