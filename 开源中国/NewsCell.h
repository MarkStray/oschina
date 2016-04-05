//
//  NewsCell.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *doctypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

- (void)showDataWithModel:(NewsModel *)model category:(NSString *)category;

@end
