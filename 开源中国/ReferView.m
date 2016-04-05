//
//  ReferView.m
//  开源中国
//
//  Created by qianfeng01 on 15/4/30.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "ReferView.h"
#import "LZXHelper.h"
@implementation ReferView
- (void)awakeFromNib {
    kDebugPrint();
}
#if 0
- (void)showDataWithModel:(RefersModel *)model{
    
    self.referTitleLabel.text = model.refertitle;
    CGRect frame = self.referbodyLabel.frame;
    frame.size.height = [LZXHelper textHeightFromTextString:model.referbody width:kScreenSize.width-20 fontSize:12];
    self.referbodyLabel.frame = frame;
    self.referbodyLabel.text = model.referbody;
}
#else
- (void)showDataWithModel:(RefersModel *)model initWidth:(NSInteger)width height:(NSInteger)height{
    CGRect titleFrame = self.referTitleLabel.frame;
    titleFrame.origin.y = height;
    self.referTitleLabel.frame = titleFrame;
    self.referTitleLabel.text = model.refertitle;
    CGRect bodyFrame = self.referbodyLabel.frame;
    bodyFrame.origin.y = height + 21;
    bodyFrame.size.height = [LZXHelper textHeightFromTextString:model.referbody width:width fontSize:12];
    self.referbodyLabel.frame = bodyFrame;
    self.referbodyLabel.text = model.referbody;
}
#endif
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
