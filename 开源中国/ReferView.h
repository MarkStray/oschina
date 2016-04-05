//
//  ReferView.h
//  开源中国
//
//  Created by qianfeng01 on 15/4/30.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"
@interface ReferView : UIView
@property (strong, nonatomic) IBOutlet UILabel *referTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *referbodyLabel;
- (void)showDataWithModel:(RefersModel *)model;
- (void)showDataWithModel:(RefersModel *)model initWidth:(NSInteger)width height:(NSInteger)height;
@end
