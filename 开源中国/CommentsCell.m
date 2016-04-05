//
//  CommentsCell.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "CommentsCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "LYHelper.h"
#import "LZXHelper.h"
@implementation CommentsCell

- (void)awakeFromNib {
    self.iconButton.layer.masksToBounds = YES;
    self.iconButton.layer.cornerRadius = 5;
}
- (IBAction)iconBtnClick:(UIButton *)sender {
    if (self.blocks) {
        self.blocks();
    }
}

#if 0    // 排列效果

- (void)showDateWithModel:(CommentsModel *) model block:(iconButtonBlock)blocks{
    // 保存 block
    
    self.blocks = blocks;
    [self.iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.portrait] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed: @"portrait_loading"]];
    self.authoeLabel.text = model.author;
    // 下面需要动态计算行高 1.referLabel
    
    //CGFloat height = 27;
    NSInteger count = model.refersArray.count;
    
    if (count != 0) {
        for (NSInteger i=0; i<count; i++) {
            RefersModel *referModel = model.refersArray[i];
            // 加载 xib 文件
            ReferView *referView = [[[NSBundle mainBundle] loadNibNamed:@"ReferView" owner:self options:nil] lastObject];
            // 计算 view 的高度
            NSString *referStr = [referModel.refertitle stringByAppendingString:referModel.referbody];
            CGFloat h = [LZXHelper textHeightFromTextString:referStr width:kScreenSize.width-50 fontSize:12];
            // 给定一个 最小值
            CGFloat height = MAX(45, h);
            referView.frame = CGRectMake(45, 18+((height+5)*i), kScreenSize.width-50, height);
            referView.layer.borderWidth = 1;// 边框
            
            [referView showDataWithModel:referModel];
            [self.contentView addSubview:referView];
            if (i == count-1) {
                // 2.contentLabel
                CGRect contentFrame = self.contentLabel.frame;
                contentFrame.origin.y = referView.frame.origin.y+referView.frame.size.height;
                contentFrame.size.height = [LZXHelper textHeightFromTextString:model.content width:kScreenSize.width-40 fontSize:12];
                self.contentLabel.frame = contentFrame;
                self.contentLabel.text = model.content;
                kDebugSeparator();
            }
        }
        
    }else{
        // 2.contentLabel
        CGRect contentFrame = self.contentLabel.frame;
        contentFrame.origin.y = self.authoeLabel.frame.origin.y+self.authoeLabel.frame.size.height;
        contentFrame.size.height = [LZXHelper textHeightFromTextString:model.content width:kScreenSize.width-40 fontSize:12];
        self.contentLabel.frame = contentFrame;
        self.contentLabel.text = model.content;
    }
    // 3.pubDateLabel
    CGRect pubDateLabelFrame = self.pubDateLabel.frame;
    pubDateLabelFrame.origin.y = self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height;
    self.pubDateLabel.frame = pubDateLabelFrame;
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
#else  
// 金字塔效果  1.先创建上层,放入数组 2.先创建下层预留高度

- (void)showDateWithModel:(CommentsModel *) model block:(iconButtonBlock)blocks{
    // 保存 block
    
    self.blocks = blocks;
    [self.iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.portrait] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed: @"portrait_loading"]];
    self.authoeLabel.text = model.author;
    // 下面需要动态计算行高 1.referLabel
    
    // 每个 referView  间距 5
    NSInteger count = model.refersArray.count;
    
    NSMutableArray *referViewArray = [NSMutableArray array];
    CGFloat height = 0;
    for (NSInteger i=0; i<count; i++) {
        RefersModel *referModel = model.refersArray[i];
        // 加载 xib 文件
        ReferView *referView = [[[NSBundle mainBundle] loadNibNamed:@"ReferView" owner:nil options:nil] lastObject];
        CGFloat h = (count-i-1)*5;
        CGFloat width = kScreenSize.width-60-h*2;
        [referView showDataWithModel:referModel initWidth:width height:height];
        height += 21+[LZXHelper textHeightFromTextString:referModel.referbody width:kScreenSize.width-60-h*2-10 fontSize:12]+7;
        referView.frame = CGRectMake(50+h, 27+h, width, height);
         referView.layer.borderWidth = 1;// 边框
        [referViewArray addObject:referView];
    }
    for (NSInteger i=referViewArray.count-1; i>=0; i--) {
        UIView *view = referViewArray[i];
        [self.contentView addSubview:view];
    }
    // 2.contentLabel
    CGRect contentFrame = self.contentLabel.frame;
    contentFrame.origin.y = 30+height;
    contentFrame.size.height = [LZXHelper textHeightFromTextString:model.content width:kScreenSize.width-40 fontSize:12];
    self.contentLabel.frame = contentFrame;
    self.contentLabel.text = model.content;
    
    // 3.pubDateLabel
    CGRect pubDateLabelFrame = self.pubDateLabel.frame;
    pubDateLabelFrame.origin.y = self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height;
    self.pubDateLabel.frame = pubDateLabelFrame;
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
#endif
// cell 在被 选中/点击 的时候 默认会把 cell 的contentView 上面的所有的 子视图的背景颜色 设置为 clearColor
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    kDebugPrint();
    [super setSelected:selected animated:animated];
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[ReferView class]]) {
            view.backgroundColor = K_ORANGE_COLOR;
        }
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    kDebugPrint();
    [super setHighlighted:highlighted animated:animated];
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[ReferView class]]) {
            view.backgroundColor = K_ORANGE_COLOR;
        }
    }
}

@end
