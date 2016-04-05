//
//  keyBoardView.h
//  开源中国
//
//  Created by qianfeng01 on 15/4/27.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TextFieldBlock) (void);
//  要封装  为 第三方  可以把代理  设置为 调用的界面
@interface TextFieldView : UIView
{
    TextFieldBlock _blocks;
}
@property (nonatomic) UITextField *textField;
@property (nonatomic) UIButton *left;
@property (nonatomic) UIButton *right;
- (void)setBlocks:(TextFieldBlock)blocks;
- (TextFieldBlock)blocks;
@end
