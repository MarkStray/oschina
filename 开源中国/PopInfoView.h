//
//  PopInfoView.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/14.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@interface PopInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *jointimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *devplatformLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertiseLabel;

- (void)updateUIWithModel:(UserInfoModel *)model;


@end
