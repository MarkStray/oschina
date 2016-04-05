//
//  FrientListViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "FrientListViewController.h"
#import "UserInforViewController.h"
#import "LoginModel.h"// 数据模型可以使用 登录model
#import "FriendListCell.h"

#import "SegmentEngine.h"
#import "GDataXMLNode.h"

#define kCellId @"FriendListCell"

@interface FrientListViewController ()

@end

@implementation FrientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"关注/粉丝";
    [self initPageWithArrays];
}

- (void)initPageWithArrays{
    NSArray *titles = @[@"关注",@"粉丝"];
    NSString *favoriteUrl = [NSString stringWithFormat:kFriendsListFollowersUrl,self.uid];
    NSString *fansUrl = [NSString stringWithFormat:kFriendsListFansUrl,self.uid];
    NSArray *urls = @[favoriteUrl,fansUrl];
    SegmentEngine *engine = [[SegmentEngine alloc] initWithItems:titles];
    [engine firstDownloadWithUrlArray:urls complete:^(id responseData, NSMutableArray *dataArray) {
        [self parseDataWith:responseData array:dataArray];
    }];
    [engine creatTableViewWithController:self];
    // 处理 tableView 代理方法
    [engine setCellForRowCB:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath WithArray:dataArray];
    }];
    [engine setHeightForRowCB:^CGFloat(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        return 60;
    }];
    [engine setDidSelectRowCB:^(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        [self tableView:tableView didSelectRowAtIndexPath:indexPath WithArray:dataArray];
    }];
    [self.view addSubview:engine];
}
// 这里的方法自己调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kCellId owner:self options:nil] lastObject];
    }
#if 0
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FriendListCell class]) bundle:nil] forCellReuseIdentifier:cellId];
        nibsRegistered = YES;
        
    }
#endif
    LoginModel *model = dataArray[indexPath.row];
    NSLog(@"model:%@_%@_%@",model.name,model.portrait,model.expertise);
    [cell updateUIWithModel:model complete:^{
        UserInforViewController *user = [[UserInforViewController alloc] init];
        user.authorid = model.userid;
        [self.navigationController pushViewController:user animated:YES];
    }];
    return cell;
}



- (void)parseDataWith:(id)responseData array:(NSMutableArray *)dataArray{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"SegmentEngine_doc : %@",doc);
    NSArray *friends = [doc nodesForXPath:@"//friend" error:nil];
    for (GDataXMLElement *ele in friends) {
        LoginModel *model = [[LoginModel alloc] init];
        [model setValuesForKeysWithDictionary:[ele subDictWithArray:@[@"userid",@"name",@"portrait",@"expertise"]]];
        [dataArray addObject:model];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
    LoginModel *model = dataArray[indexPath.row];
    UserInforViewController *user = [[UserInforViewController alloc] init];
    user.authorid = model.userid;
    [self.navigationController pushViewController:user animated:YES];
    
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
