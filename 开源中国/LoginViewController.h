//
//  LoginViewController.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/5.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BaseViewController.h"

#import "LoginModel.h"

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) LoginModel *model;

- (IBAction)loginButtonClick:(id)sender;

- (IBAction)linkButtonClick:(id)sender;



@end
