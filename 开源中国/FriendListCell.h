//
//  FriendListCell.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/7.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
@interface FriendListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *authorButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *platformLabel;

- (IBAction)authorBtnClick:(id)sender;

- (void)updateUIWithModel:(LoginModel *)model complete:(void(^)(void))completeCB;
@property (nonatomic, copy) void(^completeBlocks)(void);

@end
