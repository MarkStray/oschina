//
//  UserInforViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/4/30.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "UserInforViewController.h"
#import "TweetDetailViewController.h"
#import "BlogViewController.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "UserInfoCell.h"
#import "UserInfoModel.h"
#import "UserInfoHeaderView.h"
#import "AppDelegate.h"


#define kUserInfoCellId @"UserInfoCell"

@interface UserInforViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UserInfoHeaderView *userHeaderView;
@end

@implementation UserInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"用户中心";
    // http://www.oschina.net/action/api/user_information?uid=2352281&hisuid=726879&pageIndex=0&pageSize=20
    
    [self downloadDataWithUrl:kUserInformationUrl pageIndex:0];
    [self creatTableView];
    [self addTapGesture];
}
- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [self.view addGestureRecognizer:tap];
}
- (void)tapGestureClick{
    kDebugPrint();
    self.userHeaderView.popView.hidden = YES;
}
- (void)creatTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:kUserInfoCellId bundle:nil] forCellReuseIdentifier:kUserInfoCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    // tableView 头视图]
    UINib *nib = [UINib nibWithNibName:@"UserInfoHeaderView" bundle:nil];
    self.userHeaderView = [[nib instantiateWithOwner:nil options:nil] lastObject];
    //UserInfoHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoHeaderView" owner:nil options:nil] lastObject];
    __weak typeof(self) weakSelf = self;
    self.userHeaderView.flowerBlock = ^{
        [weakSelf downloadDataWithUrl:kUserInformationUrl pageIndex:0];
    };
    self.tableView.tableHeaderView = self.userHeaderView;
    UILabel *footView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
    footView.text = @"全部加载完毕";
    footView.textAlignment = NSTextAlignmentCenter;
    footView.font = [UIFont boldSystemFontOfSize:17];
    self.tableView.tableFooterView = footView;
    [self.view addSubview: self.tableView];
}
- (void)downloadDataWithUrl:(NSString *)urlStr pageIndex:(NSInteger)pageIndex {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:kUserInformationUrl,[AppDelegate globalDelegate].myAuthorId,self.authorid];
    NSLog(@"user__info__url:%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            GDataXMLElement *element = [[doc nodesForXPath:@"//user" error:nil] lastObject];
            UserInfoModel *model = [[UserInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:[element subDictWithArray:@[@"name",@"uid",@"portrait",@"score",@"fans",@"followers",@"jointime",@"gender",@"from",@"devplatform",@"expertise",@"relation",@"latestonline"]]];
            // 加载 头视图
            [self.userHeaderView UpDateHeaderViewWithModel:model complete:^(BaseViewController *baseVC) {
                [self.navigationController pushViewController:baseVC animated:YES];
            }];
            NSArray *activeArray = [doc nodesForXPath:@"//active" error:nil];
            for (GDataXMLElement *ele in activeArray) {
                ActiveModel *mdl = [[ActiveModel alloc] init];
                [mdl setValuesForKeysWithDictionary:[ele subDictWithArray:@[@"id",@"portrait",@"author",@"authorid",@"catalog",@"objecttype",@"objectcatalog",@"objecttitle",@"appclient",@"url",@"objectID",@"message",@"commentCount",@"pubDate",@"tweetimage",@"tweetattach"]]];
                [model.activiesArray addObject:mdl];
                [self.dataSource addObject:mdl];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"UserInfo Data Load Failed : %@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId forIndexPath:indexPath];
    ActiveModel *model = self.dataSource[indexPath.row];
    [cell updateUIWithModel:model complete:^{
        kDebugPrint();
        UserInforViewController *u = [[UserInforViewController alloc] init];
        u.authorid = model.authorid;
        [self.navigationController pushViewController:u animated:YES];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActiveModel *model = self.dataSource[indexPath.row];
    switch (model.catalog.integerValue) {
        case 1:
        case 4:{// 博客
            BlogViewController *blog = [[BlogViewController alloc] init];
            blog.authoruid = model.authorid;
            [self.navigationController pushViewController:blog animated:YES];
        }
            break;
        case 2:
        case 3:{
            TweetDetailViewController *cmt = [[TweetDetailViewController alloc] init];
            cmt.tweetId = model.authorid;
            [self.navigationController pushViewController:cmt animated:YES];
        }
            break;
        default:
            break;
    }
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
