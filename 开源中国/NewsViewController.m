//
//  TotalViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "QFRefreshView.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "DDXML.h"

#define kNewsCellId @"NewsCell"

@interface NewsViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) UISegmentedControl *segment;


// 刷新相关属性 /*刷新有疑问参考 SearchResultViewController的刷新*/
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadMore;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSegmentItem];
    self.pageIndex = 0;// 初始化给个值
    [self downloadDataWithUrl:kInfoUrl pageIndex:self.pageIndex];
    [self creatTableView];
    [self creatRefreshView];
}
- (void)creatSegmentItem{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"资讯",@"热点",@"博客",@"推荐"]];
    self.segment.tintColor = K_TABBAR_COLOR;
    self.segment.frame = CGRectMake(0, 64, kScreenSize.width, 30);
    self.segment.selectedSegmentIndex = 0;
    self.segment.tag = 999;
    
     NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:K_GRAY_COLOR};
    [self.segment setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    NSDictionary *dict2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:K_BLUE_COLOR};
    [self.segment setTitleTextAttributes:dict2 forState:UIControlStateSelected];
    
    [self.segment addTarget:self action:@selector(segmentClick) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
}


- (void)segmentClick{
    [self creatRefreshView];
    NSInteger i = self.segment.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(kScreenSize.width*i, 0) animated:YES];
    NSArray *urls = @[kInfoUrl,kHotUrl,kBolgUrl,kRecommendUrl];
    [self downloadDataWithUrl:urls[i] pageIndex:0];
}
#pragma mark - 加载 刷新
- (void)creatRefreshView{
    
    UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:1001+self.segment.selectedSegmentIndex];
    NSArray *urls = @[kInfoUrl,kHotUrl,kBolgUrl,kRecommendUrl];
    __block NewsViewController *mySelf = self;
    // 该方法在调用的时候  会在对应的 tableView 上 加载对应的刷新视图
    [tableView setPullDownHandler:^(QFRefreshView *refreshView) {
        if (mySelf.isRefreshing) {
            return ;
        }
        mySelf.isRefreshing = YES;
        mySelf.pageIndex = 0;
        [self downloadDataWithUrl:urls[self.segment.selectedSegmentIndex] pageIndex:mySelf.pageIndex];
    }];
    [tableView setPullUpHandler:^(QFRefreshView *refreshView) {
        if (mySelf.isLoadMore) {
            return ;
        }
        mySelf.isLoadMore = YES;
        mySelf.pageIndex += 1;
        [self downloadDataWithUrl:urls[self.segment.selectedSegmentIndex] pageIndex:mySelf.pageIndex];
    }];
}

- (void)endRefreshing{
    self.isLoadMore = NO;
    self.isRefreshing = NO;
    UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:1001+self.segment.selectedSegmentIndex];
    [tableView stopFooterViewLoading];
    [tableView stopHeaderViewLoading];
}


#pragma mark - downloadData
- (void)downloadDataWithUrl:(NSString *)urlStr pageIndex:(NSInteger)pageIndex{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:urlStr,pageIndex];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (pageIndex == 0) {
                [self.dataSource removeAllObjects];
            }
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
            NSArray *arr = nil;
            if (self.segment.selectedSegmentIndex < 2) {
                arr = [doc nodesForXPath:@"//news" error:nil];
            }else{
                arr = [doc nodesForXPath:@"//blog" error:nil];
            }
            for (DDXMLElement *element in arr) {
                NewsModel *model = [[NewsModel alloc] init];
                NSDictionary *dict = [element subDictWithArray:@[@"id",@"title",@"body",@"commentCount",@"author",@"authorid",@"authoruid",@"authoruid2",@"pubDate",@"url",@"type",@"eventurl",@"authorname",@"documentType"]];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataSource addObject:model];
            }
            // 刷新数据
            UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:1001+self.segment.selectedSegmentIndex];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [tableView reloadData];
        }
        [self endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"load news error : %@",error);
        [self endRefreshing];
    }];

}

#pragma mark - UITableView
- (void)creatTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [NSMutableArray array];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+30, kScreenSize.width, kScreenSize.height-64-30)];
    // 添加 tableView
    for (NSInteger i=0; i<4; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenSize.width*i, 0, kScreenSize.width, self.scrollView.bounds.size.height) style:UITableViewStylePlain];
        [tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kNewsCellId];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = 1001+i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 100;
        [self.scrollView addSubview:tableView];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width*4, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.tag = 555;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}
#pragma mark - UIScrollViewDelegate
// 减速停止的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 555) {
        CGPoint curPoint = scrollView.contentOffset;
        self.segment.selectedSegmentIndex = curPoint.x/kScreenSize.width;
        [self segmentClick];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellId forIndexPath:indexPath];
    NewsModel *model = self.dataSource[indexPath.row];
    if (tableView.tag == 1001 || tableView.tag == 1002) {
         [cell showDataWithModel:model category:@"news"];
    }else{
         [cell showDataWithModel:model category:@"blog"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
     NewsModel *model = self.dataSource[indexPath.row];
    newsDetail.model = model;
    newsDetail.tableViewTag = tableView.tag;
    newsDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsDetail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
