//
//  TweetDetailViewController.h
//  开源中国
//
//  Created by qianfeng01 on 15/4/28.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BaseViewController.h"
#import "TweetModel.h"

@interface TweetDetailViewController : BaseViewController

@property (nonatomic, strong) TweetModel *model;
@property (nonatomic, copy) NSString *tweetId;

@end
