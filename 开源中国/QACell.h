//
//  QACell.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/9.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAModel.h"
@interface QACell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerAndViewLabel;

- (void)updateUIUsingModel:(QAModel *)model complete:(void(^)(void))completeCB;
@property (nonatomic, copy) void (^completeBlocks)(void);

- (IBAction)portraitBtnCliK:(UIButton *)sender;

@end
