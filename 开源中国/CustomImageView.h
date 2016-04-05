//
//  CustomImageView.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/17.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageView : UIImageView

@property (nonatomic, copy) void (^deleteBlocks) (void);

@end
