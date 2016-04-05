//
//  TweetDetailCell.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/14.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "TweetDetailCell.h"
#import "UIButton+WebCache.h"
#import "LYHelper.h"
@implementation TweetDetailCell

- (void)awakeFromNib {
    self.portraitButton.layer.masksToBounds = YES;
    self.portraitButton.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateUIWithModel:(TweetCommentModel *)model complete:(void(^)(void))completeCB{
    self.completeBlocks = completeCB;
    [self.portraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.portrait] forState:UIControlStateNormal];
    self.authorLabel.text = model.author;
    self.contentLabel.text = model.content;
    NSInteger second = [LYHelper getSecondNowToDate:model.pubDate formater:@"yyyy-MM-dd HH-mm-ss"];
    if (second >= 24*60*60) {
        self.pubDateLabel.text = [NSString stringWithFormat:@"%ld天前",second/24/60/60];
    }else if (second >= 60*60){
        self.pubDateLabel.text = [NSString stringWithFormat:@"%ld小时前",second/60/60];
    }else if (second >= 60){
        self.pubDateLabel.text = [NSString stringWithFormat:@"%ld分钟前",second/60];
    }else{
        self.pubDateLabel.text = [NSString stringWithFormat:@"1分钟前"];
    }
    

}
- (IBAction)portraitButtonClick:(UIButton *)sender {
    if (self.completeBlocks) {
        self.completeBlocks();
    }
}
@end
