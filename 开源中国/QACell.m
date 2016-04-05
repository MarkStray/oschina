//
//  QACell.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/9.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "QACell.h"
#import "UIButton+WebCache.h"
#import "LZXHelper.h"
#import "LYHelper.h"
@implementation QACell

- (void)awakeFromNib {
    self.portraitButton.layer.masksToBounds = YES;
    self.portraitButton.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateUIUsingModel:(QAModel *)model complete:(void(^)(void))completeCB{
    
    self.completeBlocks = completeCB;
    
    [self.portraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.portrait] forState:UIControlStateNormal];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.height = [LZXHelper textHeightFromTextString:model.title width:kScreenSize.width-60 fontSize:14];
    self.titleLabel.frame = titleFrame;
    self.titleLabel.text = model.title;
    
    CGRect bodyFrame = self.bodyLabel.frame;
    bodyFrame.origin.y = titleFrame.origin.y + titleFrame.size.height + 5;
    bodyFrame.size.height = [LZXHelper textHeightFromTextString:model.body width:kScreenSize.width-60 fontSize:12];
    self.bodyLabel.frame = bodyFrame;
    self.bodyLabel.text = model.body;
    
    CGRect authorFrame = self.authorLabel.frame;
    authorFrame.origin.y = bodyFrame.origin.y + bodyFrame.size.height;
    self.authorLabel.frame = authorFrame;
    self.authorLabel.text = model.author;
    
    CGRect PubDateFrame = self.pubDateLabel.frame;
    PubDateFrame.origin.y = authorFrame.origin.y;
    self.pubDateLabel.frame = PubDateFrame;
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
    
    CGRect viewFrame = self.answerAndViewLabel.frame;
    viewFrame.origin.y = authorFrame.origin.y;
    self.answerAndViewLabel.frame = viewFrame;
    self.answerAndViewLabel.text = [NSString stringWithFormat:@"%@回/%@阅",model.answerCount,model.viewCount];
    
}
- (IBAction)portraitBtnCliK:(UIButton *)sender {
    if (self.completeBlocks) {
        self.completeBlocks();
    }
}
@end
