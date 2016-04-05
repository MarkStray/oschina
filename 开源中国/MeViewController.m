//
//  MeViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "MeViewController.h"
#import "LoginViewController.h"
#import "LoginDetailViewController.h"
#import "FavoriteListViewController.h"
#import "FrientListViewController.h"

#import "LYHelper.h"
#import "PersonalCenterViewController.h"
#import "BlogViewController.h"// 即将推出团队功能，敬请期待

#import "UIButton+WebCache.h"
#import "QRCodeGenerator.h"
#import "AppDelegate.h"

#import "AppDelegate.h"

extern BOOL isLogin;

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
// 二维码视图
@property (nonatomic, strong) UIView *QRView;
@property (nonatomic, assign) BOOL isHidden;
@end

@implementation MeViewController

/*
    //我们 采用的xib 先把 视图粘贴上
    viewController 的xib 文件会在alloc init 的自动调用- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
    刚开始是没有数据的 下载完成之后粘贴
 */
- (void)viewDidLoad {
    kDebugPrint();
    kDebugSeparator();
    [super viewDidLoad];
    self.isHidden = NO;
    self.iconbutton.layer.masksToBounds = YES;
    self.iconbutton.layer.cornerRadius = 25;
    self.dataSource = @[@"消息",@"博客",@"团队",@"me-message",@"me-blog",@"me-team"];
    [self showDownloadData];
    [self creatTableView];
    // 注册一个 观察者
    NSLog(@"ME_BOOL_ISLOGIN : %d",isLogin);
    // 登录成功  这里 的通知 接收不到来自左边 的 登录 成功 通知  因此 要在本地本地读写
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginValidateSuccess object:nil];// 这里 的 通知 接受不到 来自 左边视图 的 通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kLoginValidateSuccess object:nil];
    // 登录失败
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kLogout object:nil];
}

/*
 <oschina>
  <result><errorCode>1</errorCode><errorMessage><![CDATA[登录成功]]></errorMessage>
  </result>
 <user><uid>2352281</uid><location><![CDATA[上海 浦东]]></location><name><![CDATA[JsonAndXml]]></name><followers>2</followers><fans>2</fans><score>0</score><portrait>http://static.oschina.net/uploads/user/1176/2352281_100.jpg?t=1429547830000</portrait><favoritecount>6</favoritecount><gender>0</gender>
 </user>
 <notice><atmeCount>0</atmeCount><msgCount>0</msgCount><reviewCount>0</reviewCount><newFansCount>0</newFansCount><newLikeCount>0</newLikeCount>
 </notice>
 </oschina>
 */

// 登录成功 回调 显示 用户信息 block 同样可以实现
/*- (void)loginSuccess:(NSNotification *)notify{
    kDebugPrint();
    self.model = notify.object;
    [self.iconbutton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.portrait] forState:UIControlStateNormal];
    self.scoreLabel.text = self.model.score;
    self.collectionLabel.text = self.model.favoritecount;
    self.attentionLabel.text = self.model.followers;
    self.fansLabel.text = self.model.fans;
    // NSLog(@"self.model :: %@ ,%@",self.model.name,self.model.location);
    // JsonAndXml ,上海 浦东
    self.authorLabel.text = self.model.name;
}*/
- (void)loginSuccess{
    NSDictionary *userDict = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/user.plist"]];
    NSLog(@"userDict:%@",userDict);
    [self.iconbutton sd_setBackgroundImageWithURL:[NSURL URLWithString:userDict[@"portrait"]] forState:UIControlStateNormal];
    self.scoreLabel.text = userDict[@"score"];
    self.collectionLabel.text = userDict[@"favoritecount"];
    self.attentionLabel.text = userDict[@"followers"];
    self.fansLabel.text = userDict[@"fans"];
    // NSLog(@"self.model :: %@ ,%@",self.model.name,self.model.location);
    // JsonAndXml ,上海 浦东
    self.authorLabel.text = userDict[@"name"];
}
// 注销
- (void)logout{
    kDebugPrint();
    [self.iconbutton setBackgroundImage:[UIImage imageNamed: @"portrait_loading"] forState:UIControlStateNormal];
    self.authorLabel.text = @"点击头像登录";
}
- (void)showDownloadData{
    
}
- (void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 204, kScreenSize.width, kScreenSize.height-204) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"menu-background(320x480)"]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (IBAction)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1000:// 登录
        {
            [self pushToLoginView];
        }
            break;
        case 1001://不处理
            break;
        case 1002:
        {
            //FavoriteListViewController *favorite = [[FavoriteListViewController alloc] init];
            //favorite.hidesBottomBarWhenPushed = YES;
            //[self.navigationController pushViewController:favorite animated:YES];
        }
            break;
        case 1003:
        case 1004:{
            FrientListViewController *frient = [[FrientListViewController alloc] init];
            frient.uid = [AppDelegate globalDelegate].myAuthorId;
            frient.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:frient animated:YES];
        }
            break;
        case 1009:// 生成二维码
        {
            if (self.QRView) {
                self.QRView.hidden = self.isHidden;
            }else{
                self.QRView = [[UIView alloc] initWithFrame:CGRectMake((kScreenSize.width-250)/2, (kScreenSize.height-250)/2, 250, 250)];
                self.QRView.hidden = self.isHidden;
                self.QRView.layer.cornerRadius = 8;
                self.QRView.backgroundColor = [UIColor whiteColor];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, 200, 200)];
                imageView.image = [QRCodeGenerator qrImageForString:[AppDelegate globalDelegate].myAuthorId imageSize:200];
                [self.QRView addSubview:imageView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, 250, 25)];
                label.text = @"扫一扫上面的二维码,加我为好友";
                label.font = [UIFont systemFontOfSize:14];
                label.textAlignment = NSTextAlignmentCenter;
                [self.QRView addSubview:label];
                [self.view addSubview:self.QRView];
                
                
            }
            self.isHidden = !self.isHidden;
        }
            break;
        default:
            break;
    }
}
- (void)pushToLoginView{
    if (isLogin) {
        LoginDetailViewController *logDetail = [[LoginDetailViewController alloc] init];
        logDetail.model = self.model;
        logDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:logDetail animated:YES];
    }else{
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isLogin) {
        [self loginSuccess];
        for (NSInteger i=1001; i<=1010; i++) {
            UIView *view = [self.view viewWithTag:i];
            view.hidden = NO;
        }
    }else{
        for (NSInteger i=1001; i<=1010; i++) {
            UIView *view = [self.view viewWithTag:i];
            view.hidden = YES;
        }
    }
}



#pragma mark - UITalbeViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count-3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.row+3]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            if (isLogin) {
                PersonalCenterViewController *person = [[PersonalCenterViewController alloc] init];
                person.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:person animated:YES];
            }else{
                LoginViewController *login = [[LoginViewController alloc] init];
                login.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:login animated:YES];
            }
        }
            break;
        case 1:
        {
            if (isLogin) {
                BlogViewController *blog = [[BlogViewController alloc] init];
                blog.title = @"我的博客";
                blog.hidesBottomBarWhenPushed = YES;
                blog.authoruid = self.model.uid;
                [self.navigationController pushViewController:blog animated:YES];
            }else{
                LoginViewController *login = [[LoginViewController alloc] init];
                login.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:login animated:YES];
            }
        }
            break;
        case 2:
        {
            if (isLogin) {
                [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"即将推出团队功能，敬请期待..."];
            }else{
                LoginViewController *login = [[LoginViewController alloc] init];
                login.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:login animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
// 二维码相关 跳转操作

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.QRView.hidden = self.isHidden;
    self.isHidden = !self.isHidden;
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
