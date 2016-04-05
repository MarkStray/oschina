//
//  LoginViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/5.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "DDXML.h"
#import "LYHelper.h"
#import "AppDelegate.h"

extern BOOL isLogin;
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"登录";
    self.loginButton.backgroundColor = K_BLUE_COLOR;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 15;
    
}

- (IBAction)loginButtonClick:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // <keep_login=1&pwd=aaA578257097&username=18317893893%40163.com>
    NSDictionary *dict = @{@"keep_login":@"1",@"pwd":self.passwordTextField.text,@"username":self.emailTextField.text};
    
    //NSString *url = @"http://www.oschina.net/action/api/login_validate?keep_login=1&pwd=jy1440025065&username=1970446167@qq.com";
    [manager POST:kLoginValidateUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
            NSLog(@"doc:%@",doc);
            NSArray *result = [doc nodesForXPath:@"//result" error:nil];
            DDXMLElement *element = [result lastObject];
            NSString *errorCode = [element stringValueByName:@"errorCode"];
            NSString *errorMessage = [element stringValueByName:@"errorMessage"];
            NSLog(@"\"errorCode\" = \"%@\" , \"errorMessage\" = \"%@\"",errorCode,errorMessage);
            if ([errorCode isEqualToString:@"0"]) {
                [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"错误:用户名或口令错"];
            }else if ([errorCode isEqualToString:@"1"]){
                NSArray *users = [doc nodesForXPath:@"//user" error:nil];
                DDXMLElement *user = [users lastObject];
                NSDictionary *dict = [user subDictWithArray:@[@"uid",@"location",@"name",@"followers",@"fans",@"score",@"portrait",@"favoritecount",@"gender"]];
                self.model = [[LoginModel alloc] init];
                // 把 用户 登录 信息 保存  到本地@1
                NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/user.plist"];
                NSLog(@"filePath:%@",filePath);
                NSLog(@"nsbundle mainbundle : %@",NSHomeDirectory());
                [dict writeToFile:filePath atomically:YES];
                
                [self.model setValuesForKeysWithDictionary:dict];
                
                //  把登录用户 的 id 放在
                [AppDelegate globalDelegate].myAuthorId = self.model.uid;
                NSLog(@"登录的账户ID___[AppDelegate globalDelegate].myAuthorId:%@",[AppDelegate globalDelegate].myAuthorId);
                
                // 发送一个登录成功的通知@2 通知 页面修该数据
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginValidateSuccess object:self.model];
                // 自动跳转到登录界面
                [self.navigationController popViewControllerAnimated:YES];
                // 标记 登录成功
                 isLogin = YES;
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"login_Validate_error:%@",error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或口令错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
}

- (IBAction)linkButtonClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.oschina.net"]];
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
