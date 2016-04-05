//
//  NewsCell.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "LYHelper.h"
#import "AFNetworking.h"
@implementation NewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)showDataWithModel:(NewsModel *)model category:(NSString *)category{
    // 今/原/转  author/authorname
    if ([category isEqualToString:@"news"]) {
        if ([LYHelper getSecondNowToDate:model.pubDate formater:@"yyyy-MM-dd HH-mm-ss"] < 24*60*60 ) {
            self.doctypeImageView.image = [UIImage imageNamed: @"widget_taday"];
        }else{
            self.doctypeImageView.image = nil;
        }
        self.authorLabel.text = model.author;
    }else if ([category isEqualToString:@"blog"]){
        if ([model.documentType isEqualToString:@"0"]) {
            self.doctypeImageView.image = [UIImage imageNamed: @"widget-original"];
        }else{
            self.doctypeImageView.image = [UIImage imageNamed: @"widget_repost"];
        }
        self.authorLabel.text = model.authorname;
    }
    
    self.titleLabel.text = model.title;
    self.bodyLabel.text = model.body;
    
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
    
    self.commentCountLabel.text = model.commentCount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
