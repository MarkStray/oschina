//
//  SearchResultViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/2.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "SearchResultViewController.h"
#import "QFRefreshView.h"
#import "LZXHelper.h"
#import "SearchModel.h"
#import "SearchCell.h"
#import "AFNetworking.h"
#import "DDXML.h"
#import "NewsModel.h"
#import "NewsDetailViewController.h"

#define kSearchCellId @"SearchCell"
#define kTableViewCellId @"TableViewCell"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UISegmentedControl *segment;
//使用searchController添加搜索，ios8支持
@property (nonatomic, strong)UISearchController *searchContoller;
@property (nonatomic, strong) UISearchBar *searchBar;

// 刷新相关属性
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadMore;

//刷新界面 子类不适合 那么需要重写
- (void)creatRefreshView;
//停止刷新
- (void)endRefreshing;

@end

@implementation SearchResultViewController

- (void)creatNavigationBar{
    // 去掉 navigationBar
    kDismissNavigationItem;
#if 0 // 自定义
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入搜索关键字";
    self.navigationItem.titleView = self.searchBar;
#else
    // 添加搜索条 searchBar
    self.searchContoller = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchContoller.searchResultsUpdater = self;// 设置searchContoller代理
    self.searchContoller.dimsBackgroundDuringPresentation = NO;// 默认是YES 搜索结果不能选中
    self.searchContoller.hidesNavigationBarDuringPresentation = NO;//导航不隐藏
    self.searchContoller.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchContoller.searchBar;
    // 设置 searchBar 属性
    self.searchContoller.searchBar.placeholder = @"请输入搜索关键字";
    // 调用sizeToFit 调整尺寸
    [self.searchContoller.searchBar sizeToFit];// 导航不用
#endif
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavigationBar];
    [self creatSegmentItem];
    self.pageIndex = 0;
    [self creatTableView];
    // [self creatRefreshView]; 这里只能创建一个刷新视图
}

#pragma mark - UISegmentedControl
- (void)creatSegmentItem{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"软件",@"问答",@"博客",@"新闻"]];
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
    [self creatRefreshView];// 创建对应的（4）刷新视图
    //[self.dataSource removeAllObjects];// 这里没有必要加
    [self.scrollView setContentOffset:CGPointMake(kScreenSize.width*self.segment.selectedSegmentIndex, 0) animated:YES];
    [self downloadDataWithUrl:kSearchListUrl pageIndex:0];// 第一次切换页面的时候 总是加载第一页数据
}
#pragma mark - UITableView
- (void)creatTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [NSMutableArray array];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+30, kScreenSize.width, kScreenSize.height-64-30)];
    // 添加 tableView
    for (NSInteger i=0; i<4; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenSize.width*i, 0, kScreenSize.width, self.scrollView.bounds.size.height) style:UITableViewStylePlain];
        if (i != 0) {
            [tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSearchCellId];
        }
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = 1001+i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:tableView];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width*4, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.tag = 555;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

#pragma mark - downloadData
- (void)downloadDataWithUrl:(NSString *)urlStr pageIndex:(NSInteger)pageIndex{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 拼接 URL
    NSArray *catalogs = @[@"software",@"post",@"blog",@"news"];
    NSString *url = [NSString stringWithFormat:urlStr,catalogs[self.segment.selectedSegmentIndex],self.searchContoller.searchBar.text,pageIndex];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (pageIndex == 0) {
                [self.dataSource removeAllObjects];
            }
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
            NSArray *arr = [doc nodesForXPath:@"//result" error:nil];
            
            for (DDXMLElement *element in arr) {
                SearchModel *model = [[SearchModel alloc] init];
                NSDictionary *dict = [element subDictWithArray:@[@"objid",@"title",@"type",@"description",@"author",@"pubDate",@"url"]];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataSource addObject:model];
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
#pragma mark - 加载 刷新
- (void)creatRefreshView{
    // 刷新的时候直接调用下载方法 来下载
    UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:1001+self.segment.selectedSegmentIndex];
    __block SearchResultViewController *mySelf = self;
    // 该方法在调用的时候  会在对应的 tableView 上 加载对应的刷新视图
    [tableView setPullDownHandler:^(QFRefreshView *refreshView) {
        if (mySelf.isRefreshing) {
            return ;
        }
        mySelf.isRefreshing = YES;
        mySelf.pageIndex = 0;
        [self downloadDataWithUrl:kSearchListUrl pageIndex:mySelf.pageIndex];
    }];
    [tableView setPullUpHandler:^(QFRefreshView *refreshView) {
        if (mySelf.isLoadMore) {
            return ;
        }
        mySelf.isLoadMore = YES;
        mySelf.pageIndex += 1;
        [self downloadDataWithUrl:kSearchListUrl pageIndex:mySelf.pageIndex];
    }];
}

- (void)endRefreshing{
    self.isLoadMore = NO;
    self.isRefreshing = NO;
    UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:1001+self.segment.selectedSegmentIndex];
    [tableView stopFooterViewLoading];
    [tableView stopHeaderViewLoading];
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
#if 0
#pragma mark - UISearchBarDelegate
// 使用 UISearchController 此方法会 自动实现
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}
#endif
// 子类需要重写  否则 造成 循环 引用
// 此方法 用来 点击搜索按钮 检索信息
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    kDebugPrint();
    [self segmentClick];
}

#pragma mark - UISearchResultUpdating
// 此方法 用来 实时检索 信息
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    kDebugPrint();
    //[self segmentClick];
}
#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController{}
- (void)didPresentSearchController:(UISearchController *)searchController{}
- (void)willDismissSearchController:(UISearchController *)searchController{}
- (void)didDismissSearchController:(UISearchController *)searchController{}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchModel *model = self.dataSource[indexPath.row];
    if (tableView.tag == 1001) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellId];
        }
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = model.description;
        return cell;
    }else{
         SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCellId forIndexPath:indexPath];
        [cell showDataWithModel:model];
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag != 1001) {
        SearchModel *model = self.dataSource[indexPath.row];
        CGFloat height = 10;
        if (model.title) {
            height += [LZXHelper textHeightFromTextString:model.title width:kScreenSize.width-20 fontSize:14]+10;
        }
        if (model.description) {
            height += [LZXHelper textHeightFromTextString:model.description width:kScreenSize.height-20 fontSize:12];
        }
        return height+25;
    }
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchModel *model = self.dataSource[indexPath.row];
    NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
    switch (self.segment.selectedSegmentIndex) {
        case 0://soft
        {
            detail.tableViewTag = 999;
            detail.model.url = model.url;
            detail.model.id = model.objid;
            detail.model.authorid = model.objid;
        }
            break;
        case 1://post
        {
            detail.tableViewTag = 997;
            detail.model.url = model.url;
            detail.model.id = model.objid;
            detail.model.authorid = model.objid;
            detail.model.title = model.title;
            detail.model.pubDate = model.pubDate;
            detail.model.author = model.author;
        }
            break;
        case 2://blog
        {
            detail.tableViewTag = 1003;
            detail.model.id = [[model.url componentsSeparatedByString:@"/"] lastObject];;
            detail.model.title = model.title;
            detail.model.pubDate = model.pubDate;
            detail.model.author = model.author;
            detail.model.authorid = [[model.url componentsSeparatedByString:@"/"] lastObject];
            NSLog(@"-=-=-=-=-=-=-= lastObject] : %@",detail.model.authorid);
        }
            break;
        case 3://news
        {
            detail.tableViewTag = 1003;
            detail.model.id = [[model.url componentsSeparatedByString:@"/"] lastObject];
            detail.model.title = model.title;
            detail.model.pubDate = model.pubDate;
            detail.model.author = model.author;
            detail.model.authorid = [[model.url componentsSeparatedByString:@"/"] lastObject];
            NSLog(@"-=-=-=-=-=-=-= lastObject] : %@",detail.model.authorid);
        }
            break;
        default:
            break;
    }
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
