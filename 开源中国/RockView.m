//
//  RockView.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/17.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "RockView.h"
#import "UIImageView+WebCache.h"
@implementation RockView

- (void)awakeFromNib{
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5;
}

- (void)updateUIWithModel:(NewsModel *)model{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.detail;
    self.authorLabel.text = [NSString stringWithFormat:@"作者: %@",model.author];
    self.commentCountLabel.text = [NSString stringWithFormat:@"评论: %@",model.commentCount];
    NSString *time = [[model.pubDate componentsSeparatedByString:@" "] firstObject];
    self.pubDateLabel.text = [NSString stringWithFormat:@"时间: %@",time];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
