//
//  TweetDetailCell.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/14.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetDetailModel.h"
@interface TweetDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;



- (IBAction)portraitButtonClick:(UIButton *)sender;

- (void)updateUIWithModel:(TweetCommentModel *)model complete:(void(^)(void))completeCB;
@property (nonatomic, copy) void (^completeBlocks) (void);

@end
