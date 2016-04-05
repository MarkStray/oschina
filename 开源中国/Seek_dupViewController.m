//
//  SeekViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/11.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "Seek_dupViewController.h"
#import "QFRefreshView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "GDataXMLNode.h"
#import "LoginModel.h"
#define kTableViewCellId @"tableViewCellId"

#define kUrlStr @"http://www.oschina.net/action/api/find_user?name=%@&pageIndex=%ld&pageSize=20"

@interface Seek_dupViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UISearchBar *searchBar;

// 刷新相关属性
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadMore;

@end

@implementation Seek_dupViewController
/*
 <user>
    <name>上帝禁区</name>
    <uid>86984</uid>
    <portrait>http://static.oschina.net/uploads/user/43/86984_100.jpg?t=1378271359000</portrait>
    <gender>男</gender>
    <from>安徽 合肥</from>
 </user>
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找人";
    self.pageIndex = 0;
    self.dataSource = [NSMutableArray array];
    [self creatTableView];
    [self creatRefreshView];
    
    //NSString *url = @"http://www.oschina.net/action/api/find_user?name=%@&pageIndex=0&pageSize=20";
    //NSString *url1 = @"http://www.oschina.net/action/api/user_information?uid=2352281&hisuid=86984&pageIndex=0&pageSize=20";
    
    
}
- (void)creatTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"输入用户昵称";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellId];
    self.tableView.tableHeaderView = self.searchBar;
    [self.view addSubview:self.tableView];
}
#pragma mark - UISearchBarDelegate
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
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *urlStr = [NSString stringWithFormat:kUrlStr,self.searchBar.text,self.pageIndex];
    [self downloadDataWithUrl:urlStr];
}
#pragma mark - 下载数据
- (void)downloadDataWithUrl:(NSString *)url{
    kDebugPrint();
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.pageIndex == 0) {
                [self.dataSource removeAllObjects];
            }
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            NSArray *userArray = [doc nodesForXPath:@"//user" error:nil];
            for (GDataXMLElement *ele in userArray) {
                LoginModel *model = [[LoginModel alloc] init];
                [model setValuesForKeysWithDictionary:[ele subDictWithArray:@[@"name",@"uid",@"portrait",@"gender",@"from"]]];
                [self.dataSource addObject:model];
            }
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView reloadData];
        }
        [self endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing];
        NSLog(@" 搜索数据下载失败 __ error : %@",error);
    }];
}
#pragma mark - 加载 刷新
- (void)creatRefreshView{
    __weak typeof(self) weakSelf = self;
    [self.tableView setPullDownHandler:^(QFRefreshView *refreshView) {
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.pageIndex = 0;
        [weakSelf downloadDataWithUrl:[NSString stringWithFormat:kUrlStr,weakSelf.searchBar.text,weakSelf.pageIndex]];
    }];
    [self.tableView setPullUpHandler:^(QFRefreshView *refreshView) {
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.pageIndex += 1;
        [weakSelf downloadDataWithUrl:[NSString stringWithFormat:kUrlStr,weakSelf.searchBar.text,weakSelf.pageIndex]];
    }];
}

- (void)endRefreshing{
    self.isLoadMore = NO;
    self.isRefreshing = NO;
    [self.tableView stopFooterViewLoading];
    [self.tableView stopHeaderViewLoading];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellId];
    }
    
    LoginModel *model = self.dataSource[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed: @"portrait_loading"]];
    cell.textLabel.text = model.name;
    cell.textLabel.textColor = K_BLUE_COLOR;
    cell.detailTextLabel.text = model.from;
    return cell;
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
