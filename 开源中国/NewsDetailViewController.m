//
//  NewsDetailViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "CommentsViewController.h"
#import "LoginViewController.h"
#import "GDataXMLNode.h"
#import "DDXML.h"
#import "AFNetworking.h"
#import "LYHelper.h"
#import "TextFieldView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#import <MessageUI/MessageUI.h>

#import "UMSocial.h"

@interface NewsDetailViewController () <UITextFieldDelegate,UIActionSheetDelegate,UMSocialUIDelegate>
@property (nonatomic) TextFieldView *textFieldView;

@property (nonatomic, assign) BOOL isFavorite;
@end

@implementation NewsDetailViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[NewsModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    [self creatToolBar];
    [self showData];
    self.isFavorite = NO;
    // 键盘相关操作
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)showData{
    self.titleLabel.text = self.model.title;
    NSInteger second = [LYHelper getSecondNowToDate:self.model.pubDate formater:@"yyyy-MM-dd HH-mm-ss"];
    if (second >= 24*60*60) {
        self.pubDateLabel.text = [NSString stringWithFormat:@" 发布于 %ld天前",second/24/60/60];
    }else if (second >= 60*60){
        self.pubDateLabel.text = [NSString stringWithFormat:@" 发布于 %ld小时前",second/60/60];
    }else if (second >= 60){
        self.pubDateLabel.text = [NSString stringWithFormat:@" 发布于 %ld分钟前",second/60];
    }else{
        self.pubDateLabel.text = [NSString stringWithFormat:@" 发布于 1分钟前"];
    }
    if (self.tableViewTag == 1001 || self.tableViewTag == 1002) {
        self.navigationItem.title = @"咨询详情";
        self.authorLabel.text = self.model.author;
        
        [self downloadDataWithUrl:[NSString stringWithFormat:kInfoDetailUrl,self.model.id]];
    }else if (self.tableViewTag == 1003 || self.tableViewTag == 1004){
        self.authorLabel.text = self.model.authorname;
        self.navigationItem.title = @"博客详情";
        [self downloadDataWithUrl:[NSString stringWithFormat:kBolgDetailUrl,self.model.id]];
    }else if (self.tableViewTag == 999){
        self.navigationItem.title = @"软件详情";
        self.authorLabel.text = self.model.author;
        NSString *ident = [[self.model.url componentsSeparatedByString:@"/"]lastObject];
        [self downloadDataWithUrl:[[NSString stringWithFormat:@"http://www.oschina.net/action/api/software_detail?ident=%@",ident] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else if (self.tableViewTag == 997){
        self.navigationItem.title = @"帖子详情";
         self.authorLabel.text = self.model.author;
        [self downloadDataWithUrl:[[NSString stringWithFormat:@"http://www.oschina.net/action/api/post_detail?id=%@",self.model.id] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
}
- (void)downloadDataWithUrl:(NSString *)url{
    // 加载 webView
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            NSArray *body = [doc nodesForXPath:@"//body" error:nil];
            NSString *bodyStr = [[body lastObject] stringValue];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 116, kScreenSize.width,self.view.bounds.size.height-116-49)];
            [webView loadHTMLString:bodyStr baseURL:nil];
            [self.view addSubview:webView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"load newsDetail error : %@",error);
    }];
}
- (void)creatToolBar{
    
    NSArray *images = @[@"keyboardUp",@"separatorline",@"comments",@"editingComment",@"star",@"share",@"report"];
    NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(itemClick:)];
    spaceItem.width = (kScreenSize.width-7*44)/8;
    for (NSInteger i=0; i<images.count; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"toolbar-%@",images[i]]] style:UIBarButtonItemStylePlain target:self action:@selector(itemClick:)];
        if (i == 1) {
            item.enabled = NO;
        }
        item.tag = 1001+i;
        [items addObject:item];
        [items addObject:spaceItem];
    }
    self.toolbarItems = items;
    
    // 粘贴脚标 在 第三个item 的上面
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(44*3-14, 8, 14, 14)];
//    label.layer.masksToBounds = YES;
//    label.layer.cornerRadius = 2;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = self.model.commentCount;
//    label.font = [UIFont systemFontOfSize:12];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = K_BLUE_COLOR;
    // 评论数 不为0  粘贴上
//    if (self.model.commentCount.integerValue != 0) {
//        [self.navigationController.toolbar addSubview:label];
//    }
    self.navigationController.toolbar.tintColor = K_BLACK_COLOR;
}
- (void)itemClick:(UIBarButtonItem *)item {
    switch (item.tag) {
        case 1001:// 弹键盘
        case 1004:// 编辑评论
        {
            [self.navigationController setToolbarHidden:YES];
            [self.view bringSubviewToFront:self.textFieldView];
        }
            break;
        case 1002:// 分割线
            break;
        case 1003:// 评论列表
        {
            CommentsViewController *comments = [[CommentsViewController alloc] init];
            if (self.tableViewTag == 997) {
                comments.model = self.model;
                comments.flag = 4;
            }else if (self.tableViewTag == 999){
                comments.model = self.model;
                NSLog(@"-------3-------self.model.id--------------- %@",self.model.id);
                comments.flag = 3;
            }else if (self.tableViewTag == 1003 || self.tableViewTag == 1004){
                comments.model = self.model;
                comments.flag = 2;
            }else if (self.tableViewTag == 1001 || self.tableViewTag == 1002){
                comments.model = self.model;
                comments.flag = 1;
            }
            [self.navigationController pushViewController:comments animated:YES];
        }
            break;
        case 1005:// 收藏
        {
            /*
             <?xml version="1.0" encoding="UTF-8"?><oschina><result><errorCode>0</errorCode><errorMessage>用户未登录</errorMessage></result></oschina>
             用户未登陆  收藏添加失败 添加收藏成功
             */
            // 收藏过 发送 删除 请求 未收藏 发送 收藏请求
            if (!self.isFavorite) {
                [self postFavoriteWithUrl:kFavoriteAddUrl complete:item];
            }else{
                [self postFavoriteWithUrl:kFavoriteDeleteUrl complete:item];
            }
        }
            break;
        case 1006:// 分享
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"短信",@"邮件",@"新浪微博",@"人人", nil];
            [actionSheet showInView:self.view];
        }
            break;
        case 1007:// 举报
        {
            [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"该功能正在紧急修复中"];
        }
            break;
        default:
            break;
    }
}

// 举报
- (void)report{
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //第三方的 友盟 / share sdk
    
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    //上面 这样应用 需要 再设置些 内容
    
    //比如 微信 需要  设置 appID 新的微信 需要另外导入四个库(libz.dylib  libc++.dylib systemConfiguration.framework,sqlite3.dylib)
    NSArray *shareArray = @[UMShareToSms,UMShareToEmail,UMShareToSina,UMShareToRenren];
    
    //1.设置分享内容和回调对象
    [[UMSocialControllerService defaultControllerService] setShareText:@"https://www.oschina.net" shareImage:[UIImage imageNamed: @"bg00-1080x1920"] socialUIDelegate:self];
    /*
     typedef void (^UMSocialSnsPlatformClickHandler)(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController);
     */
    //2.设置分享平台
    [UMSocialSnsPlatformManager getSocialPlatformWithName:shareArray[buttonIndex]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}
#pragma mark - UM协议
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
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
// 收藏
- (void)postFavoriteWithUrl:(NSString *)url complete:(UIBarButtonItem *)item{
    if (isLogin) {
        if (self.model.id) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // 返回 text/html 要加
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:url parameters:@{@"objid":self.model.id,@"type":@"4",@"uid":[AppDelegate globalDelegate].myAuthorId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject) {
                    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
                    NSArray *result = [doc nodesForXPath:@"//result" error:nil];
                    DDXMLElement *element = [result lastObject];
                    NSString *errorCode = [element stringValueByName:@"errorCode"];
                    NSString *errorMessage = [element stringValueByName:@"errorMessage"];
                    NSLog(@"\"errorCode\" = \"%@\" , \"errorMessage\" = \"%@\"",errorCode,errorMessage);
                    NSInteger flag = [[[[element elementsForName:@"errorCode"] lastObject] stringValue] integerValue];
                    if (flag == 1) {
                        [item setImage:[[UIImage imageNamed:@"toolbar-starred"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                        self.isFavorite = YES;
                    }else{
                        [item setImage:[[UIImage imageNamed:@"toolbar-star"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                        self.isFavorite = NO;
                    }
                    [LYHelper alphaFadeAnimationOnView:self.view WithTitle:errorMessage];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"favoriteError : %@",error);
            }];

        }
    }else{
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}


// 点击 send  发送 评论
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    // 界面 第一次  出现 就创建 键盘
    if (!self.textFieldView) {
        self.textFieldView = [[TextFieldView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-44, kScreenSize.width, 44)];
        self.textFieldView.textField.delegate = self;
        // 点击按钮 执行 弹出 Toolbar
        __weak typeof(self) weakSelf = self;
        self.textFieldView.blocks = ^(void){
            [weakSelf.navigationController setToolbarHidden:NO];
        };
        [self.view addSubview:self.textFieldView];
    }
    [self.view sendSubviewToBack:self.textFieldView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
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
