//
//  SegmentEngine.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "SegmentEngine.h"

@interface SegmentEngine()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSMutableArray *_dataSource;
    
    // 内部保存传进来的数组 个数
    NSInteger _arrayCount;
    
    NSArray *_urlArray;
    
    NSInteger _pageIndex;
    BOOL _isRefreshing;
    BOOL _isLoadMore;
}

@end

@implementation SegmentEngine

- (instancetype)initWithItems:(NSArray *)items{
    if (self = [super initWithItems:items]) {
        _dataSource = [NSMutableArray array];
        _pageIndex = 0;
        _arrayCount = items.count;
        // 配置 segment
        self.tintColor = K_TABBAR_COLOR;
        self.frame = CGRectMake(0, 64, kScreenSize.width, 30);
        self.selectedSegmentIndex = 0;
        
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:K_GRAY_COLOR};
        [self setTitleTextAttributes:dict forState:UIControlStateNormal];
        NSDictionary *dict2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:K_BLUE_COLOR};
        [self setTitleTextAttributes:dict2 forState:UIControlStateSelected];
        
        [self addTarget:self action:@selector(clickSegment) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}
- (void)clickSegment{
    NSInteger i = self.selectedSegmentIndex;
    [_scrollView setContentOffset:CGPointMake(kScreenSize.width*i, 0) animated:YES];
    [self creatRefreshViewWithUrlArray:_urlArray];// 加载刷新视图
    // 滑动 或点击 始终加载第一页数据
    [self downloadDataWithUrl:_urlArray[i] pageIndex:0];
}
- (void)creatTableViewWithController:(UIViewController *)vc{
    vc.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+30, kScreenSize.width, kScreenSize.height-64-30)];
    for (NSInteger i=0; i<_arrayCount; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenSize.width*i, 0, kScreenSize.width, _scrollView.bounds.size.height) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = 1001+i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:tableView];
    }
    _scrollView.contentSize = CGSizeMake(kScreenSize.width*_arrayCount, _scrollView.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.tag = 555;
    _scrollView.delegate = self;
    [vc.view addSubview:_scrollView];
}
// 解析数据的 block
- (void)firstDownloadWithUrlArray:(NSArray *)urlArray complete:(void (^) (id responseData, NSMutableArray *dataArray))successCB{
    _urlArray = urlArray;
    self.successCB = successCB;
    [self downloadDataWithUrl:urlArray[0] pageIndex:0];
}
- (void)downloadDataWithUrl:(NSString *)urlStr pageIndex:(NSInteger)pageIndex {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:urlStr,pageIndex];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    kDebugSeparator();
    NSLog(@"manager_url : %@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            if (pageIndex == 0) {
                [_dataSource removeAllObjects];
            }
            // 传入代码块 让对应的页面来处理 block 回调
            if (self.successCB) {
                self.successCB(responseObject,_dataSource);
            }
            NSLog(@"引擎数据源_dataSource:%@",_dataSource);
            kDebugSeparator();
            // 刷新数据
            UITableView *tableView = (UITableView *)[_scrollView viewWithTag:1001+self.selectedSegmentIndex];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [tableView reloadData];
        }
        [self endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"download data error : %@",error);
        [self endRefreshing];
    }];
}

#pragma mark - 加载 刷新
- (void)creatRefreshViewWithUrlArray:(NSArray *)urlArray{
    
    UITableView *tableView = (UITableView *)[_scrollView viewWithTag:1001+self.selectedSegmentIndex];
    // 该方法在调用的时候  会在对应的 tableView 上 加载对应的刷新视图
    [tableView setPullDownHandler:^(QFRefreshView *refreshView) {
        if (_isRefreshing) {
            return ;
        }
        _isRefreshing = YES;
        _pageIndex = 0;
        [self downloadDataWithUrl:urlArray[self.selectedSegmentIndex] pageIndex:_pageIndex];
    }];
    [tableView setPullUpHandler:^(QFRefreshView *refreshView) {
        if (_isLoadMore) {
            return ;
        }
        _isLoadMore = YES;
        _pageIndex += 1;
        [self downloadDataWithUrl:urlArray[self.selectedSegmentIndex] pageIndex:_pageIndex];
    }];
}

- (void)endRefreshing{
    _isLoadMore = NO;
    _isRefreshing = NO;
    UITableView *tableView = (UITableView *)[_scrollView viewWithTag:1001+self.selectedSegmentIndex];
    [tableView stopFooterViewLoading];
    [tableView stopHeaderViewLoading];
}
#pragma mark - UIScrollViewDelegate
// 减速停止的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 555) {
        CGPoint curPoint = scrollView.contentOffset;
        self.selectedSegmentIndex = curPoint.x/kScreenSize.width;
        [self clickSegment];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellForRowCB(tableView,indexPath,[_dataSource copy]);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.didSelectRowCB(tableView,indexPath,[_dataSource copy]);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.heightForRowCB(tableView,indexPath,[_dataSource copy]);
}

@end
