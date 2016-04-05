//
//  CustomImageView.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/17.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(frame.size.width-14/2, -14/2, 14, 14);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 7;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTintColor:[UIColor whiteColor]];
        [button setTitle:@"X" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        self.userInteractionEnabled = YES;
        [self addSubview:button];
    }
    return self;
}
- (void)btnClick{
    if (self.deleteBlocks) {
        self.deleteBlocks();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
