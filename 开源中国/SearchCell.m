//
//  SearchCell.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/2.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "SearchCell.h"
#import "LZXHelper.h"
@implementation SearchCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)showDataWithModel:(SearchModel *)model{
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.height = [LZXHelper textHeightFromTextString:model.title width:kScreenSize.width-20 fontSize:14];
    self.titleLabel.frame = titleFrame;
    self.titleLabel.text = model.title;
    CGRect descFrame = self.descLabel.frame;
    descFrame.origin.y = titleFrame.origin.y+titleFrame.size.height+2;
    descFrame.size.height = [LZXHelper textHeightFromTextString:model.description width:kScreenSize.width-20 fontSize:12];
    self.descLabel.frame = descFrame;
    self.descLabel.text = model.description;
    CGRect authorFrame = self.authorLabel.frame;
    authorFrame.origin.y = descFrame.origin.y+descFrame.size.height+2;
    self.authorLabel.frame = authorFrame;
    self.authorLabel.text = model.author;
    CGRect pubDateFrame = self.pubDateLabel.frame;
    pubDateFrame.origin.y = authorFrame.origin.y;
    self.pubDateLabel.frame = pubDateFrame;
    self.pubDateLabel.text = model.pubDate;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
