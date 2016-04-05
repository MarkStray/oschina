//
//  LeaveMsgViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/14.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LeaveMsgViewController.h"
#import "AFNetworking.h"
#import "DDXML.h"
#import "TweetDetailModel.h"
#import "BubbleCell.h"
#import "AppDelegate.h"
#import "LZXHelper.h"
#import "TextFieldView.h"
#import "LYHelper.h"
#define kBubbleCell @"bubbleCell"

// http://www.oschina.net/action/api/message_pub
// content=%E4%BD%A0%E7%8C%9C&receiver=1261086&uid=2352281
// 全部 留言
// http://www.oschina.net/action/api/comment_list?catalog=4&id=2352789&pageIndex=0&pageSize=20

#define kRecvMsgUrl @"http://www.oschina.net/action/api/comment_list?catalog=4&id=%@&pageIndex=0&pageSize=20"

@interface LeaveMsgViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) TextFieldView *textFieldView;

@end

@implementation LeaveMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = self.model.name;
    
    [self creatTableView];
    [self downLoadDataSource];
    
    // 键盘相关操作
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.textFieldView) {
        self.textFieldView = [[TextFieldView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-44, kScreenSize.width, 44)];
        self.textFieldView.textField.delegate = self;
        [self.view addSubview:self.textFieldView];
    }
}
- (void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[BubbleCell class] forCellReuseIdentifier:kBubbleCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (void)downLoadDataSource{
    self.dataSource = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:kRecvMsgUrl,self.model.uid];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
            NSArray *commentsArray = [doc nodesForXPath:@"//comment" error:nil];
            for (DDXMLElement *element in commentsArray) {
                 TweetCommentModel *model = [[TweetCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:[element subDictWithArray:@[@"id",@"portrait",@"author",@"authorid",@"pubDate",@"content",@"appclient"]]];
                [self.dataSource addObject:model];
            }
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"pop data load failed : %@",error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:kBubbleCell forIndexPath:indexPath];
    TweetCommentModel *model = self.dataSource[indexPath.row];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell setFrame:CGRectZero isMine:[[AppDelegate globalDelegate].myAuthorId isEqualToString:model.authorid] withModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     TweetCommentModel *model = self.dataSource[indexPath.row];
    CGFloat height = [LZXHelper textHeightFromTextString:model.content width:220 fontSize:[UIFont systemFontSize]];
    
    return 30+height;
}



#pragma mark - UITextFieldDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    kDebugPrint();
    [self.textFieldView.textField resignFirstResponder];// 取消第一响应
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
        self.textFieldView.textField.text = nil;
    }];
}

#pragma mark - UITextFieldDelegate
// http://www.oschina.net/action/api/message_pub
// content=%E4%BD%A0%E7%8C%9C&receiver=1261086&uid=2352281
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.textFieldView.textField.text) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:@"http://www.oschina.net/action/api/message_pub" parameters:@{@"content":self.textFieldView.textField.text,@"receiver":self.model.uid,@"uid":[AppDelegate globalDelegate].myAuthorId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
                NSLog(@"doc_____doc____%@",doc);
                DDXMLElement *ele = [[doc nodesForXPath:@"//result" error:nil] lastObject];
                NSInteger flag = [[[[ele elementsForName:@"errorCode"] lastObject] stringValue] integerValue];
                if (flag == 1) {
                    [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"留言发表成功"];
                    [self downLoadDataSource];
                    [self.tableView reloadData];
                    // 取消键盘的第一响应
                    [self.textFieldView.textField resignFirstResponder];
                }else{
                    [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"网络异常,失败"];
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"comment__pub__failed__%@",error);
        }];
    }else{
        [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"留言内容不能为空"];
    }
    return YES;
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
