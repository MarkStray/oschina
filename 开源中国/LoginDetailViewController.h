//
//  LoginDetailViewController.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginModel.h"
@interface LoginDetailViewController : BaseViewController

@property (nonatomic, strong) LoginModel *model;

@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *iconNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *developPlatformLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialAreaLabel;




- (IBAction)iconButtonClick:(id)sender;

@end
