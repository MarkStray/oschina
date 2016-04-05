//
//  MeViewController.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginModel.h"
@interface MeViewController : BaseViewController

@property (nonatomic, strong) LoginModel *model;


@property (weak, nonatomic) IBOutlet UIImageView *userBackgroundImageView;
// icon button
@property (weak, nonatomic) IBOutlet UIButton *iconbutton;

// 二维码
@property (weak, nonatomic) IBOutlet UIButton *QRButton;

// title button  用 tag 值来控制是否隐藏  可以不用连线 直接用tag 控制

// title label
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

// 这里的 buttonClick 关联5个button 区分 tag
- (IBAction)buttonClick:(UIButton *)sender;



@end
