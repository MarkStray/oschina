//
//  TweetDetailViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/4/28.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UserInforViewController.h"
#import "QFRefreshView.h"
#import "GDataXMLNode.h"
#import "AFNetworking.h"
#import "DDXML.h"
#import "LoginViewController.h"
#import "TweetDetailModel.h"
#import "TweetDetailCell.h"
#import "AppDelegate.h"
#import "LYHelper.h"
#import "TextFieldView.h"
#import "TweetHeaderView.h"
#import "LZXHelper.h"

#define kTweetDetailCellId @"TweetDetailCell"

extern BOOL isLogin;

@interface TweetDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadMore;

@property (nonatomic, strong) TextFieldView *textFieldView;
@property (nonatomic, strong) TweetHeaderView *headerView;

@end

@implementation TweetDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[TweetModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kDismissNavigationItem;
    self.navigationItem.title = self.title;
    
    self.pageIndex = 0;// 初始化给个值
    
    [self downloadDataWithUrl:kTweetCommentUrl pageIndex:self.pageIndex];
    
    [self creatTableView];
    [self creatRefreshView];
    
    // 键盘相关操作
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark - UITableView
- (void)creatTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    
    [self.tableView registerNib:[UINib nibWithNibName:kTweetDetailCellId bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTweetDetailCellId];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 头视图 的 高度
    NSInteger height = [LZXHelper textHeightFromTextString:self.model.body width:kScreenSize.width-70 fontSize:14];
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"TweetHeaderView" owner:nil options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 0, kScreenSize.width, height+95);
    __weak typeof(self) weakSelf = self;
    [self.headerView updateUIWithModel:self.model complete:^{
        UserInforViewController *user = [[UserInforViewController alloc] init];
        user.authorid = weakSelf.model.authorid;
        [weakSelf.navigationController pushViewController:user animated:YES];
    }];
    self.tableView.tableHeaderView = self.headerView;
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
        
        [weakSelf downloadDataWithUrl:kTweetCommentUrl pageIndex:weakSelf.pageIndex];
    }];
    [self.tableView setPullUpHandler:^(QFRefreshView *refreshView) {
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.pageIndex += 1;
        [weakSelf downloadDataWithUrl:kTweetCommentUrl pageIndex:weakSelf.pageIndex];
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
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [[NSString stringWithFormat:urlStr,self.tweetId,pageIndex] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (pageIndex == 0) {
                [self.dataSource removeAllObjects];
            }
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            TweetDetailModel *model = [[TweetDetailModel alloc] init];
            model.allCount = [[[[doc rootElement] children] objectAtIndex:0] stringValue];
            model.pagesize = [[[[doc rootElement] children] objectAtIndex:1] stringValue];
            NSLog(@"model___pagesize:%@",model.pagesize);
            NSArray *comments = [doc nodesForXPath:@"//comment" error:nil];
            NSLog(@"doc:%@",doc);
            for (GDataXMLElement *element in comments) {
                TweetCommentModel *mdl = [[TweetCommentModel alloc] init];
                NSDictionary *dict = [element subDictWithArray:@[@"id",@"portrait",@"author",@"authorid",@"pubDate",@"content",@"appclient"]];
                [mdl setValuesForKeysWithDictionary:dict];
                [model.commentArray addObject:mdl];
                [self.dataSource addObject:mdl];
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
    TweetDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetDetailCellId forIndexPath:indexPath];
    TweetCommentModel *model = self.dataSource[indexPath.row];
    
    [cell updateUIWithModel:model complete:^{
        UserInforViewController *user = [[UserInforViewController alloc] init];
        user.authorid = model.authorid;
        
        [self.navigationController pushViewController:user animated:YES];
    }];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     TweetCommentModel *model = self.dataSource[indexPath.row];
    self.textFieldView.textField.text = [NSString stringWithFormat:@"@%@  ",model.author];
    // 弹键盘
    [self.textFieldView.textField becomeFirstResponder];
}



// 选中 评论 后 回复 post
// http://www.oschina.net/action/api/comment_pub
// catalog=3&content=%E6%88%91%E5%8F%AB%E7%90%86%E6%9F%A5%E5%BE%B7&id=5473862&isPostToMyZone=0&uid=2352281
/*  服务器  返回数据
 <?xml version="1.0" encoding="UTF-8"?>
 <oschina>
     <result><errorCode>1</errorCode><errorMessage><![CDATA[操作成功]]></errorMessage>
     </result>
     <comment><id>5501351</id><portrait>http://static.oschina.net/uploads/user/1176/2352281_50.jpg?t=1429547830000</portrait><author><![CDATA[JsonAndXml]]></author><authorid>2352281</authorid><content><![CDATA[%E6%88%91%E5%8F%AB%E7%90%86%E6%9F%A5%E5%BE%B7]]></content><pubDate>2015-05-15 11:11:54</pubDate>
     </comment>
     <notice><atmeCount>0</atmeCount><msgCount>0</msgCount><reviewCount>0</reviewCount><newFansCount>0</newFansCount><newLikeCount>0</newLikeCount>
     </notice>
 </oschina>
 */

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (isLogin) {
        if (self.textFieldView.textField.text) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:kCommentPubUrl parameters:@{@"catalog":@"3",@"content":self.textFieldView.textField.text,@"id":self.tweetId,@"isPostToMyZone":@"0",@"uid":[AppDelegate globalDelegate].myAuthorId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject) {
                    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
                    NSLog(@"doc_____doc____%@",doc);
                    DDXMLElement *ele = [[doc nodesForXPath:@"//result" error:nil] lastObject];
                    NSInteger flag = [[[[ele elementsForName:@"errorCode"] lastObject] stringValue] integerValue];
                    if (flag == 1) {
                        [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"评论发表成功"];
                        [self downloadDataWithUrl:kTweetCommentUrl pageIndex:self.pageIndex];
                        // 取消键盘的第一响应
                        [self.textFieldView.textField resignFirstResponder];
                    }else{
                        [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"网络异常,评论失败"];
                    }
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"comment__pub__failed__%@",error);
            }];
        }else{
            [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"评论内容不能为空"];
        }
        
    }else{
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }

    return YES;
}
#pragma mark - 键盘相关操作

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    kDebugPrint();
    [self.textFieldView.textField resignFirstResponder];// 取消第一响应
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.textFieldView) {
        self.textFieldView = [[TextFieldView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-44, kScreenSize.width, 44)];
        self.textFieldView.textField.delegate = self;
        [self.view addSubview:self.textFieldView];
    }
}

// 接受 系统通知中心消息
- (void)keyBoardShow:(NSNotification *)notify{
    // 获取键盘高度
    NSDictionary *userInfo = notify.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *dValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyBoardRect = [aValue CGRectValue];
    NSTimeInterval timeInterval = [dValue doubleValue];
    NSLog(@"POP__timeInterval : %f",timeInterval);
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    NSLog(@"keyBoardHeight : %f",keyBoardHeight);
    
    [UIView animateWithDuration:timeInterval animations:^{
        self.textFieldView.frame = CGRectMake(0, kScreenSize.height-44-keyBoardHeight, kScreenSize.width, 44);
    } completion:nil];
    
}
- (void)keyboardHidden:(NSNotification *)notify{

    NSNumber *dValue = [notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[dValue doubleValue] animations:^{
        self.textFieldView.frame = CGRectMake(0, kScreenSize.height-44, kScreenSize.width, 44);
    } completion:^(BOOL finished) {
        self.textFieldView.textField.text = @"";
    }];
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
