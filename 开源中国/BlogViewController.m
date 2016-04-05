//
//  BlogViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BlogViewController.h"
#import "NewsDetailViewController.h"
#import "QFRefreshView.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "AppDelegate.h"
#define kBlogTableViewCellId @"NewsCell"

#define kPersonalBlogUrl @"http://www.oschina.net/action/api/userblog_list?authoruid=%@&pageIndex=%ld&uid=%@"

@interface BlogViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadMore;

@property (nonatomic, strong) NSString *blogUrl;


@end

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = self.title;

    self.pageIndex = 0;// 初始化给个值
    
    [self downloadDataWithUrl:kPersonalBlogUrl pageIndex:self.pageIndex];
    
    [self creatTableView];
    [self creatRefreshView];
}
#pragma mark - UITableView
- (void)creatTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    
    [self.tableView registerNib:[UINib nibWithNibName:kBlogTableViewCellId bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kBlogTableViewCellId];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
   
}


#pragma mark - 加载 刷新
- (void)creatRefreshView{
    __weak typeof(self) weakSelf = self;
    // 该方法在调用的时候  会在对应的 tableView 上 加载对应的刷新视图
    [self.tableView setPullDownHandler:^(QFRefreshView *refreshView) {
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.pageIndex = 0;
        
        [weakSelf downloadDataWithUrl:kPersonalBlogUrl pageIndex:weakSelf.pageIndex];
    }];
    [self.tableView setPullUpHandler:^(QFRefreshView *refreshView) {
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.pageIndex += 1;
        [weakSelf downloadDataWithUrl:kPersonalBlogUrl pageIndex:weakSelf.pageIndex];
    }];
}
- (void)endRefreshing{
    self.isLoadMore = NO;
    self.isRefreshing = NO;
    [self.tableView stopFooterViewLoading];
    [self.tableView stopHeaderViewLoading];
}

// www.oschina.net/action/api/userblog_list?authoruid=139664&pageIndex=0&uid=2352281
#pragma mark - downloadData
- (void)downloadDataWithUrl:(NSString *)urlStr pageIndex:(NSInteger)pageIndex{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (self.title == nil) {
        self.blogUrl = [NSString stringWithFormat:kPersonalBlogUrl,self.authoruid,pageIndex,[AppDelegate globalDelegate].myAuthorId];
    }else{
        self.blogUrl = [NSString stringWithFormat:kPersonalBlogUrl,[AppDelegate globalDelegate].myAuthorId,pageIndex,[AppDelegate globalDelegate].myAuthorId];
    }
    [manager GET:self.blogUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (pageIndex == 0) {
                [self.dataSource removeAllObjects];
            }
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            NSArray *arr = [doc nodesForXPath:@"//blog" error:nil];
           
            for (GDataXMLElement *element in arr) {
                NewsModel *model = [[NewsModel alloc] init];
                NSDictionary *dict = [element subDictWithArray:@[@"id",@"title",@"commentCount",@"authoruid",@"pubDate",@"url",@"authorname",@"documentType"]];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataSource addObject:model];
            }
            // 刷新数据
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView reloadData];
        }
        [self endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"load news error : %@",error);
        [self endRefreshing];
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlogTableViewCellId forIndexPath:indexPath];
    NewsModel *model = self.dataSource[indexPath.row];
   
    [cell showDataWithModel:model category:@"blog"];
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    NewsModel *model = self.dataSource[indexPath.row];
    newsDetail.model = model;
    newsDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsDetail animated:YES];
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
