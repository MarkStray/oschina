//
//  PopInfoView.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/14.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "PopInfoView.h"

@implementation PopInfoView
- (void)awakeFromNib{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
}

- (void)updateUIWithModel:(UserInfoModel *)model{
    self.jointimeLabel.text = model.jointime;
    self.fromLabel.text = model.from;
    self.devplatformLabel.text = model.devplatform;
    self.expertiseLabel.text = model.expertise;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
