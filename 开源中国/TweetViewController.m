//
//  TweetViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "TweetViewController.h"
#import "TweetDetailViewController.h"
#import "UserInforViewController.h"
#import "QFRefreshView.h"
#import "AFNetworking.h"
#import "TweetCell.h"
#import "TweetModel.h"
#import "DDXML.h"
#import "LZXHelper.h"
#import "AppDelegate.h"
#define kTweetCellId @"TweetCell"


@interface TweetViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

// 刷新相关属性 /*刷新有疑问参考 SearchResultViewController的刷新*/
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadMore;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *uid;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSegmentItem];
    self.pageIndex = 0;
    self.uid = @"0";
    [self downloadDataWithUrl:kTweetUrl pageIndex:self.pageIndex];
    [self creatTableView];
    [self creatRefreshView];
}
- (void)creatSegmentItem{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"最新动弹",@"热门动弹",@"我的动弹"]];
    self.segment.tintColor = K_TABBAR_COLOR;
    self.segment.frame = CGRectMake(0, 64, kScreenSize.width, 30);
    self.segment.selectedSegmentIndex = 0;
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:K_GRAY_COLOR};
    [self.segment setTitleTextAttributes:dict forState:UIControlStateNormal];
    NSDictionary *dict2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:K_BLUE_COLOR};
    [self.segment setTitleTextAttributes:dict2 forState:UIControlStateSelected];
    
    [self.segment addTarget:self action:@selector(segmentClick) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
}
- (void)segmentClick{
    [self creatRefreshView];
    NSInteger i= self.segment.selectedSegmentIndex;
    if (i == 0) {
        self.uid = @"0";
    }else if (i == 1){
        self.uid = @"-1";
    }else if (i == 2){
        self.uid = [AppDelegate globalDelegate].myAuthorId;
    }
    
    NSArray *urls = @[kTweetUrl,kHotTweetUrl,kMyTweetUrl];
    [self.scrollView setContentOffset:CGPointMake(kScreenSize.width*i, 0) animated:YES];
    [self downloadDataWithUrl:urls[i] pageIndex:0];
}
#pragma mark - 加载 刷新
- (void)creatRefreshView{
    
    UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:1001+self.segment.selectedSegmentIndex];
    NSArray *urls = @[kTweetUrl,kHotTweetUrl,kMyTweetUrl];
    __block TweetViewController *mySelf = self;
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
    NSString *url = [NSString stringWithFormat:urlStr,self.uid,pageIndex];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (pageIndex == 0) {
                [self.dataArray removeAllObjects];
            }
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
            NSArray *arr = [doc nodesForXPath:@"//tweet" error:nil];
            for (DDXMLElement *ele in arr) {
                TweetModel *model = [[TweetModel alloc] init];
                NSDictionary *dict = [ele subDictWithArray:@[@"id",@"portrait",@"author",@"authorid",@"body",@"attach",@"appclient",@"commentCount",@"imgBig",@"imgSmall",@"pubDate",@"isLike",@"likeCount"]];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
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
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 555) {
        CGPoint curPoint = scrollView.contentOffset;
        self.segment.selectedSegmentIndex = curPoint.x/kScreenSize.width;
        [self segmentClick];
    }
}

#pragma mark - UITableViewDelegate
- (void)creatTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArray = [NSMutableArray array];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+30, kScreenSize.width, kScreenSize.height-64-30)];
    // 添加 tableView
    for (NSInteger i=0; i<3; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenSize.width*i, 0, kScreenSize.width, self.scrollView.bounds.size.height) style:UITableViewStylePlain];
        [tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:kTweetCellId];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = 1001+i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:tableView];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width*3, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.tag = 555;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellId forIndexPath:indexPath];
    TweetModel *model = self.dataArray[indexPath.row];
    [cell showDataWithModel:model complete:^{
        UserInforViewController *user = [[UserInforViewController alloc] init];
        user.authorid = model.authorid;
        user.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:user animated:YES];
    }];
    return cell;
}
// 动态计算行高 必须要实现的方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetModel *model = self.dataArray[indexPath.row];
    CGFloat height = 27;
    if (model.body) {
        height += [LZXHelper textHeightFromTextString:model.body width:kScreenSize.width-60 fontSize:12] + 5;
    }
    if (model.imgSmall.length) {
        height += 60;
    }
    height += 5;
    if (model.likeList) {
        height += [LZXHelper textHeightFromTextString:model.likeList width:100 fontSize:10] + 5;
    }
    return height+25;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetDetailViewController *tweetDetail = [[TweetDetailViewController alloc] init];
    TweetModel *model = self.dataArray[indexPath.row];
    tweetDetail.tweetId = model.id;
    tweetDetail.model = model;
    tweetDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tweetDetail animated:YES];
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
