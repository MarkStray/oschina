//
//  BubbleCell.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/18.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetDetailModel.h"
@interface BubbleCell : UITableViewCell

@property (nonatomic, strong) UILabel *bubbleLabel;
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UIImageView *portraitImageView;

- (void)setFrame:(CGRect)frame isMine:(BOOL)isMine withModel:(TweetCommentModel *)model;

@end
