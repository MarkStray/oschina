//
//  TweetHeaderView.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/16.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "TweetHeaderView.h"
#import "UIButton+WebCache.h"
#import "LYHelper.h"
#import "LZXHelper.h"
@implementation TweetHeaderView

- (void)awakeFromNib{
    kDebugPrint();
    self.portraitButton.layer.masksToBounds = YES;
    self.portraitButton.layer.cornerRadius = 5;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)updateUIWithModel:(TweetModel *)model complete:(void (^) (void))completeBC{
    self.completeBlocks = completeBC;
    [self.portraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.portrait] forState:UIControlStateNormal];
    self.authorLabel.text = model.author;
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
    CGRect bodyFrame = self.bodyLabel.frame;
    bodyFrame.size.height = [LZXHelper textHeightFromTextString:model.body width:kScreenSize.width-70 fontSize:14];
    self.bodyLabel.frame = bodyFrame;
    NSLog(@"bodyFrame---------%@",NSStringFromCGRect(bodyFrame));
    self.bodyLabel.text = model.body;
    NSLog(@"self.bodyLabel.text-->%@",self.bodyLabel.text);
    
    CGRect likeListFrame = self.postLikeLabel.frame;
    likeListFrame.origin.y = bodyFrame.origin.y + bodyFrame.size.height;
    self.postLikeLabel.frame = likeListFrame;
    self.postLikeLabel.text = [NSString stringWithFormat:@"%@ 人觉得很赞！",model.likeCount];
    NSLog(@"self.postLikeLabel.text-->%@",self.postLikeLabel.text);
    
    CGRect totalFrame = self.totalCMTLabel.frame;
    totalFrame.origin.y = likeListFrame.origin.y + likeListFrame.size.height;
    self.totalCMTLabel.frame = totalFrame;
    self.totalCMTLabel.text = [NSString stringWithFormat:@"    %@ 条评论",model.commentCount];
    NSLog(@"self.totalCMTLabel.text-->%@",self.totalCMTLabel.text);
}
- (IBAction)icLikeBtnClick:(UIButton *)sender {
    [self.icLikeButton setBackgroundImage:[UIImage imageNamed: @"ic_liked"] forState:UIControlStateNormal];
    [LYHelper alphaFadeAnimationOnView:self WithTitle:@"点赞成功"];
}

- (IBAction)portraitButtonClick:(UIButton *)sender {
    if (self.completeBlocks) {
        self.completeBlocks();
    }
}
@end
