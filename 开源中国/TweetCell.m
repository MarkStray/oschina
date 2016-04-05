//
//  TweetCell.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "TweetCell.h"
#import "LZXHelper.h"
#import "LYHelper.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@implementation TweetCell
- (void)awakeFromNib {
    self.portraitButton.layer.masksToBounds = YES;
    self.portraitButton.layer.cornerRadius = 5;
}
- (IBAction)portraitButtonClick:(UIButton *)sender {
    if (self.completeBlocks) {
        self.completeBlocks();
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    sender.enabled = NO;
    [sender setBackgroundImage:[UIImage imageNamed: @"ic_liked"] forState:UIControlStateDisabled];
}
- (void)showDataWithModel:(TweetModel *)model complete:(void (^) (void))completeCB{
    self.completeBlocks = completeCB;
    
    [self.portraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.portrait] forState:UIControlStateNormal];
    // 动态计算行高 一
    CGRect authorFrame = self.authorLabel.frame;
    authorFrame.size.width = kScreenSize.width-60;
    self.authorLabel.frame = authorFrame;
    self.authorLabel.text = model.author;
    // 动态计算行高 二
    CGRect bodyFrame = self.bodyLabel.frame;
    bodyFrame.size.height = [LZXHelper textHeightFromTextString:model.body width:kScreenSize.width-60 fontSize:12];
    self.bodyLabel.frame = bodyFrame;
    self.bodyLabel.text = model.body;
    // 动态计算行高 三
    if (model.imgSmall.length) {
        self.pictureImageView.hidden = NO;
        CGRect imageFrame = self.pictureImageView.frame;
        imageFrame.origin.y = bodyFrame.origin.y+bodyFrame.size.height;
        imageFrame.origin.x = 45;
        self.pictureImageView.frame = imageFrame;
        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:model.imgSmall] placeholderImage:[UIImage imageNamed: @"picture_s"]];
        // 动态计算行高 四
        CGRect likeListFrame = self.likeListLabel.frame;
        likeListFrame.origin.y = imageFrame.origin.y + imageFrame.size.height;
        self.likeListLabel.frame = likeListFrame;
        self.likeListLabel.text = [NSString stringWithFormat:@"%@ 人觉得很赞!",model.likeCount];
    }else{
        self.pictureImageView.hidden = YES;
        CGRect likeListFrame = self.likeListLabel.frame;
        likeListFrame.origin.y = bodyFrame.origin.y + bodyFrame.size.height;
        self.likeListLabel.frame = likeListFrame;
        self.likeListLabel.text = [NSString stringWithFormat:@"%@ 人觉得很赞!",model.likeCount];
    }
    // 动态计算行高 五 下面通用这个
    
    CGFloat height = self.likeListLabel.frame.origin.y + self.likeListLabel.frame.size.height;
    [self setBottomFrameWith:height];
    // 计算 发布时间
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
    // 区分设备型号
    if ([model.appclient isEqualToString:@"4"]) {
        self.deviceLabel.text = @"iphone";
    }else if ([model.appclient isEqualToString:@"3"]){
        self.deviceLabel.text = @"android";
    }else{
        self.deviceLabel.text = nil;
    }
    // 评论
    self.commentCountLabel.text = model.commentCount;
}
- (void)setBottomFrameWith:(CGFloat) height{
    NSArray *views = @[self.pubDateLabel,self.pubDateImageView,self.deviceLabel,self.deviceImageView,self.favoriteImageView,self.commentCountLabel,self.commentImageView];
    for (NSInteger i=0; i<views.count; i++) {
        CGRect frame = [views[i] frame];
        frame.origin.y = height;
        ((UIView *)views[i]).frame = frame;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
