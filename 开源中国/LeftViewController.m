//
//  LeftViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/1.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LeftViewController.h"
#import "SettingViewController.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"

#import "LoginModel.h"

extern BOOL isLogin;

@interface LeftViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 这边 要用 通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginValidateSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeaderImageView:) name:kLoginValidateSuccess object:nil];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kLogout object:nil];
    
    
    self.dataSource = @[@"技术问答",@"开源软件",@"博客区",@"设置",@"sidemenu-QA",@"sidemenu-software",@"sidemenu-blog",@"sidemenu-settings"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0.0, 0.0, 0.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(headView.center.x-35, 0, 70, 70);
    [self.button setBackgroundImage:[UIImage imageNamed: @"portrait_loading"] forState:UIControlStateNormal];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 35;
    [self.button addTarget:self action:@selector(headerViewClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.button];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 260, 30)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"点击头像登录";
    [headView addSubview:self.label];
    self.tableView.tableHeaderView = headView;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
}
- (void)updateHeaderImageView:(NSNotification *)notify{
 LoginModel *model = notify.object;
 [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.portrait] forState:UIControlStateNormal];
 self.label.text = model.name;
 }

- (void)updateHeaderImageView{
    // 从本地 获取数据
    NSDictionary *userDict = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/user.plist"]];
    
    [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:userDict[@"portrait"]] forState:UIControlStateNormal];
    self.label.text = userDict[@"name"];
}

- (void)logout{
    [self.button setBackgroundImage:[UIImage imageNamed: @"portrait_loading"] forState:UIControlStateNormal];
    self.label.text = @"点击头像登录";
}
- (void)headerViewClick{
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldLoginMessage object:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.row+4]];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 通知中心 传值
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeftViewLetNavigationPushControllers object:self userInfo:@{@"IndexPathRow":@(indexPath.row)}];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
