//
//  NewsDetailViewController.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsModel.h"
@interface NewsDetailViewController : BaseViewController

@property (nonatomic) NewsModel *model;

@property (nonatomic,assign) NSInteger tableViewTag;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;


@end
