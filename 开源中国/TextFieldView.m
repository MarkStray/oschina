//
//  keyBoardView.m
//  开源中国
//
//  Created by qianfeng01 on 15/4/27.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "TextFieldView.h"

@implementation TextFieldView
// 键盘的位置
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self initTextField];
    }
    return self;
}
// 保存block
- (void)setBlocks:(TextFieldBlock)blocks{
    if (_blocks != blocks) {
        _blocks = [blocks copy];
    }
}
- (TextFieldBlock)blocks{
    return _blocks;
}
- (void)initTextField{
    kDebugPrint();
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 5, kScreenSize.width-80, 36)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"说点什么";
    self.textField.keyboardType = UIKeyboardTypeDefault;
    self.textField.returnKeyType = UIReturnKeySend;
    [self addSubview:self.textField];
    
    self.left = [UIButton buttonWithType:UIButtonTypeCustom];
    self.left.frame = CGRectMake(8, 14, 20, 20);
    [self.left setBackgroundImage:[UIImage imageNamed: @"toolbar-barSwitch"] forState:UIControlStateNormal];
    [self.left addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.left];
    
    self.left = [UIButton buttonWithType:UIButtonTypeCustom];
    self.left.frame = CGRectMake(kScreenSize.width-40, 14, 20, 20);
    [self.left setBackgroundImage:[UIImage imageNamed: @"toolbar-emoji"] forState:UIControlStateNormal];
    [self.left addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.left];
}
- (void)leftButtonClick:(UIButton *)btn{
    if (self.blocks) {
        self.blocks();
    }
}
- (void)rightButtonClick:(UIButton *)btn{
    
}



@end





