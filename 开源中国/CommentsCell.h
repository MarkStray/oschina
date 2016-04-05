//
//  CommentsCell.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"
#import "ReferView.h"

typedef void (^iconButtonBlock) (void);
@interface CommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@property (weak, nonatomic) IBOutlet UILabel *authoeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;

@property (nonatomic, copy) iconButtonBlock blocks;

- (IBAction)iconBtnClick:(UIButton *)sender;

// 存放全部 引用评论
@property (nonatomic) NSArray *refersArray;

- (void)showDateWithModel:(CommentsModel *) model block:(iconButtonBlock)blocks;

@end
