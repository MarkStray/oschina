//
//  FriendListCell.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/7.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "FriendListCell.h"
#import "UIButton+WebCache.h"
@implementation FriendListCell

- (void)awakeFromNib {
    self.authorButton.layer.masksToBounds = YES;
    self.authorButton.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)authorBtnClick:(id)sender {
    if (self.completeBlocks) {
        self.completeBlocks();
    }
}

- (void)updateUIWithModel:(LoginModel *)model complete:(void (^)(void))completeCB{
    self.completeBlocks = completeCB;
    [self.authorButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.portrait] forState:UIControlStateNormal];
    self.nameLabel.text = model.name;
    self.platformLabel.text = model.expertise;
    kDebugPrint();
}





@end
