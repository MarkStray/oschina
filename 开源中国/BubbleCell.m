//
//  BubbleCell.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/18.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BubbleCell.h"
#import "UIImageView+WebCache.h"
#import "LZXHelper.h"
@implementation BubbleCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setFrame:(CGRect)frame isMine:(BOOL)isMine withModel:(TweetCommentModel *)model{
    [super frame];
    self.bubbleLabel = [[UILabel alloc] init];
    self.bubbleImageView = [[UIImageView alloc] init];
    self.portraitImageView = [[UIImageView alloc] init];
    // 动态计算 宽高
    CGFloat h = [LZXHelper textHeightFromTextString:model.content width:220 fontSize:[UIFont systemFontSize]];// 给定一个 基础高度值 16.7
    NSLog(@"bubble__height__hhhhhhhhhhhh:%f",h);
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if (h < 17) { // 如果高度小于 17  高度固定 计算宽度
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]};
        height = 16.7;
        width = [model.content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin   attributes:dict context:nil].size.width;
        
    }else{ // 宽度固定 计算高度
        
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]};
        width = 220;
        height = [model.content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin   attributes:dict context:nil].size.height;
    }
    kDebugSeparator();
    NSLog(@"bubble__width:%f",width);
    NSLog(@"bubble__height:%f",height);
    CGFloat x = isMine ? kScreenSize.width-width-70:70;
    CGFloat y = 5;
    self.bubbleLabel.frame = CGRectMake(x, y, width, height);
    self.bubbleLabel.text = model.content;
    self.bubbleLabel.numberOfLines = 0;
    self.bubbleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    if (isMine) {
        // 气泡
        self.bubbleImageView.image = [[UIImage imageNamed: @"bubbleMine"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        self.bubbleImageView.frame = CGRectMake(x-10, y-5, width+30, height+20);
        // 头像
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed: @"portrait_loading"]];
        self.portraitImageView.frame = CGRectMake(kScreenSize.width-45, y-5, 40, 40);
    }else{
        
        self.bubbleImageView.image = [[UIImage imageNamed: @"bubbleSomeone"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        self.bubbleImageView.frame = CGRectMake(x-15, y-5, width+30, height+20);
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed: @"portrait_loading"]];
        self.portraitImageView.frame = CGRectMake(5, y-5, 40, 40);
    }
    self.portraitImageView.layer.masksToBounds = YES;
    self.portraitImageView.layer.cornerRadius = 20;
    [self.contentView addSubview:self.portraitImageView];// 半径 20
    [self.contentView addSubview:self.bubbleImageView];
    [self.contentView addSubview:self.bubbleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
