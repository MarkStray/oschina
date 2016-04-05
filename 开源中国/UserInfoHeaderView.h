//
//  UserInfoHeaderView.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/14.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
#import "FrientListViewController.h"
#import "LeaveMsgViewController.h"
#import "PopInfoView.h"
@interface UserInfoHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestonlineLabel;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;


- (IBAction)segmentClick:(UISegmentedControl *)sender;


- (IBAction)btnClick:(UIButton *)sender;

- (void)UpDateHeaderViewWithModel:(UserInfoModel *)model complete:( void (^) (BaseViewController *baseVC) )completeCB;
@property (nonatomic, copy)  void (^completeBlocks) (BaseViewController *baseVC);
// 关注后刷新 整个视图
@property (nonatomic, copy) void (^flowerBlock) (void);

@property (nonatomic, strong) PopInfoView *popView;
@property (nonatomic, strong) UserInfoModel *model;


@end
