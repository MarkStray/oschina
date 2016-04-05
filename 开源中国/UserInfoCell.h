//
//  UserInfoCell.h
//  开源中国
//
//  Created by qianfeng01 on 15/4/30.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface UserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *objectTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *cmtCountLabel;

- (IBAction)portraitClick:(UIButton *)sender;

- (void)updateUIWithModel:(ActiveModel *)model complete:(void (^) (void))completeBC;
@property (nonatomic, copy) void (^completeBlocks) (void);

@end
