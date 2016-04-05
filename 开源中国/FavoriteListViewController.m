//
//  FavoriteListViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "FavoriteListViewController.h"
#import "SegmentEngine.h"
#import "GDataXMLNode.h"

#import "AppDelegate.h"

#define kCellId @"CellId"

@interface FavoriteListViewController ()

@end

@implementation FavoriteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"收藏";
    [self initPageWithArrays];
}
//#define kFavoriteListUrl @"http://www.oschina.net/action/api/favorite_list?uid=%ld&type=1&pageIndex=0&pageSize=20"
- (void)initPageWithArrays{
    NSArray *titles = @[@"软件",@"话题",@"代码",@"博客",@"资讯"];
    NSMutableArray *urls = [NSMutableArray array];
    for (NSInteger i=0; i<5; i++) {
        NSString *url = [NSString stringWithFormat:@"http://www.oschina.net/action/api/favorite_list?uid=%@&type=%ld&pageIndex=0&pageSize=20",[AppDelegate globalDelegate].myAuthorId,i];
        [urls addObject:url];
    }
    SegmentEngine *engine = [[SegmentEngine alloc] initWithItems:titles];
    [engine firstDownloadWithUrlArray:[urls copy] complete:^(id responseData, NSMutableArray *dataArray) {
        [self parseDataWith:responseData array:dataArray];
    }];
    [engine creatTableViewWithController:self];
    // 处理 tableView 代理方法
    [engine setCellForRowCB:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath WithArray:dataArray];
    }];
//    [engine setHeightForRowCB:^CGFloat(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
//        
//    }];
    [engine setDidSelectRowCB:^(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        
    }];
    [self.view addSubview:engine];
}
// 这里的方法自己调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    cell.textLabel.text = @"abc";
    return cell;
}



- (void)parseDataWith:(id)responseData array:(NSMutableArray *)dataArray{
//    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData encoding:NSUTF8StringEncoding error:nil];
//    NSArray *friends = [doc nodesForXPath:@"//friend" error:nil];
//    for (GDataXMLElement *ele in friends) {
//        
//    }
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
