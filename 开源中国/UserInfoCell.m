//
//  UserInfoCell.m
//  开源中国
//
//  Created by qianfeng01 on 15/4/30.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "UserInfoCell.h"
#import "UIButton+WebCache.h"
#import "LYHelper.h"
@implementation UserInfoCell

- (void)awakeFromNib {
    self.portraitButton.layer.masksToBounds = YES;
    self.portraitButton.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)portraitClick:(UIButton *)sender {
    kDebugPrint();
    if (self.completeBlocks) {
        self.completeBlocks();
    }
}
// catalog 1/2/3/4    新闻/问题/动态/博客
- (void)updateUIWithModel:(ActiveModel *)model complete:(void (^) (void))completeBC{
    self.completeBlocks = completeBC;// 保存 block
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
    NSLog(@"model_catelog_integerValue:%ld",model.catalog.integerValue);
    switch (model.catalog.integerValue) {
        case 1:
            self.objectTitleLabel.text = [NSString stringWithFormat:@"在新闻 \"%@\" 发表评论",model.objecttitle];
            break;
        case 2:
            self.objectTitleLabel.text = [NSString stringWithFormat:@"回答了问题 \"%@\" ",model.objecttitle];
            break;
        case 3:
            self.objectTitleLabel.text = @"更新了动态";
            break;
        case 4:
            self.objectTitleLabel.text = [NSString stringWithFormat:@"在博客 \"%@\" 发表评论",model.objecttitle];
            break;
        default:
            break;
    }
    self.messageLabel.text = model.message;
    self.cmtCountLabel.text = model.commentCount;
    
}



@end
