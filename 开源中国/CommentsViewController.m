//
//  CommentsViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "CommentsViewController.h"
#import "AppDelegate.h"
#import "LYHelper.h"
#import "LoginViewController.h"
extern BOOL isLogin;

@interface CommentsViewController () <UITextFieldDelegate>
@end

@implementation CommentsViewController

- (void)dealloc
{
    kDebugPrint();kDebugSeparator();
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    
    self.pageIndex = 0;
    // catalog 1/2/3/4    新闻/问题/动态/博客
    /*
     news http://www.oschina.net/action/api/comment_list?catalog=1&id=62390&pageIndex=0&pageSize=20
     blog http://www.oschina.net/action/api/blogcomment_list?id=416041&pageIndex=0&pageSize=20
     soft http://www.oschina.net/action/api/software_tweet_list?project=26797&pageIndex=0&pageSize=20
     post http://www.oschina.net/action/api/comment_list?catalog=2&id=236359&pageIndex=0&pageSize=20
     */
    switch (self.flag) {
        case 1: //news
            [self downloadDataWithUrl:kNewsCommentUrl pageIndex:self.pageIndex];
            break;
        case 2: //blog
            [self downloadDataWithUrl:kBlogCommentUrl pageIndex:self.pageIndex];
            break;
        case 3: //soft  传递 给下个 类
            //[self downloadDataWithUrl:kSoftCommentUrl pageIndex:self.pageIndex];
            break;
        case 4: //post
            [self downloadDataWithUrl:kPostCommentUrl pageIndex:self.pageIndex];
            break;
        default:
            break;
    }
    [self creatTableView];
    
    // 键盘相关操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)creatTableView{
    kDebugPrint();
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentsCell"];
    [self.view addSubview:self.tableView];
}

- (void)downloadDataWithUrl:(NSString *)urlStr pageIndex:(NSInteger)pageIndex{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:urlStr,self.model.id,pageIndex];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            // 清空数据
            [self.dataSource removeAllObjects];
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
            NSArray *array = [doc nodesForXPath:@"//comment" error:nil];
            for (DDXMLElement *element in array) {
                CommentsModel *model = [[CommentsModel alloc] init];
                NSDictionary *dict = [element subDictWithArray:@[@"id",@"portrait",@"author",@"authorid",@"content",@"pubDate"]];
                [model setValuesForKeysWithDictionary:dict];
                NSArray *array = [element elementsForName:@"refers"];
                DDXMLElement *ele = [array lastObject];
                NSArray *arr = [ele elementsForName:@"refer"];
                kDebugSeparator();
                NSLog(@"arr__count:%ld",arr.count);
                kDebugSeparator();
                for (DDXMLElement *ele in arr) {
                    
                    RefersModel *refModel = [[RefersModel alloc] init];
#if 1
                    NSDictionary *dict = [ele subDictWithArray:@[@"refertitle",@"referbody"]];
                    [refModel setValuesForKeysWithDictionary:dict];
#else
                    refModel.refertitle = [[[ele elementsForName:@"refertitle"] lastObject] stringValue];
                    refModel.referbody = [ele stringValueByName:@"referbody"];
#endif
                    NSLog(@"refModel.refertitle: %@",refModel.refertitle);
                    NSLog(@"refModel.referbody : %@",refModel.referbody);
                    [model.refersArray addObject:refModel];
                }
                [self.dataSource addObject:model];
            }
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"load comments error : %@",error);
    }];
}
#pragma mark - UITabelView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CommentsCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[ReferView class]]) {
            [view removeFromSuperview];
        }
    }
    CommentsModel *model = self.dataSource[indexPath.row];
    [cell showDateWithModel:model block:^{
        UserInforViewController *user = [[UserInforViewController alloc] init];
        user.authorid = model.authorid;
        [self.navigationController pushViewController:user animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsModel *model = self.dataSource[indexPath.row];
    NSInteger height = 27;
    if (model.content) {
        height += [LZXHelper textHeightFromTextString:model.content width:kScreenSize.width-30 fontSize:12];
    }
    if (model.refersArray.count) {
        for (NSInteger i=0; i<model.refersArray.count; i++) {
            RefersModel *refModel = model.refersArray[i];
            // 计算 view 的高度
            NSString *referStr = [refModel.refertitle stringByAppendingString:refModel.referbody];
            CGFloat h = [LZXHelper textHeightFromTextString:referStr width:kScreenSize.width-50 fontSize:14];
            // 给定一个 最小值
            CGFloat hh = MAX(50, h);
            NSLog(@"hh : %f",hh);
            height += hh;
        }
    }
    return height+20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     CommentsModel *model = self.dataSource[indexPath.row];
    self.textFieldView.textField.placeholder = [NSString stringWithFormat:@"回复%@: ",model.author];
    [self.textFieldView.textField becomeFirstResponder];
}


//http://www.oschina.net/action/api/comment_pub
//kCommentPubUrl @"http://www.oschina.net/action/api/comment_pub"
//authorid=0&catalog=1&content=%20666&id=62470&isPostToMyZone=0&replyid=0&uid=2352281
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (isLogin) {
        if (self.textFieldView.textField.text) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:kCommentPubUrl parameters:@{@"authorid":self.model.authorid,@"catalog":@"1",@"content":self.textFieldView.textField.text,@"id":self.model.id,@"isPostToMyZone":@"0",@"uid":[AppDelegate globalDelegate].myAuthorId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject) {
                    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
                    NSLog(@"doc_____doc____%@",doc);
                    DDXMLElement *ele = [[doc nodesForXPath:@"//result" error:nil] lastObject];
                    NSInteger flag = [[[[ele elementsForName:@"errorCode"] lastObject] stringValue] integerValue];
                    if (flag == 1) {
                        [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"评论发表成功"];
                        // 刷新评论
                        switch (self.flag) {
                            case 1: //news
                                [self downloadDataWithUrl:kNewsCommentUrl pageIndex:self.pageIndex];
                                break;
                            case 2: //blog
                                [self downloadDataWithUrl:kBlogCommentUrl pageIndex:self.pageIndex];
                                break;
                            case 3: //soft
                                [self downloadDataWithUrl:kSoftCommentUrl pageIndex:self.pageIndex];
                                break;
                            case 4: //post
                                [self downloadDataWithUrl:kPostCommentUrl pageIndex:self.pageIndex];
                                break;
                            default:
                                break;
                        }

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
