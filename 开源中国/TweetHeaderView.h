//
//  TweetHeaderView.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/16.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"
@interface TweetHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@property (weak, nonatomic) IBOutlet UILabel *postLikeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalCMTLabel;

@property (weak, nonatomic) IBOutlet UIButton *icLikeButton;

- (void)updateUIWithModel:(TweetModel *)model complete:(void (^) (void))completeBC;
@property (nonatomic, copy) void (^completeBlocks) (void);

- (IBAction)icLikeBtnClick:(UIButton *)sender;

- (IBAction)portraitButtonClick:(UIButton *)sender;

@end
