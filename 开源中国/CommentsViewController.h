//
//  CommentsViewController.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInforViewController.h"
#import "DDXML.h"
#import "AFNetworking.h"
#import "CommentsCell.h"
#import "CommentsModel.h"
#import "TextFieldView.h"
#import "LZXHelper.h"
#import "NewsModel.h"
// 该类 作为所有评论页面的父类
@interface CommentsViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;
// 界面  传值
@property (nonatomic, strong) NewsModel *model;

@property (nonatomic, assign) NSInteger flag;

// 键盘封装类
@property (nonatomic) TextFieldView *textFieldView;
// 下载管理类
- (void)downloadDataWithUrl:(NSString *)urlStr pageIndex:(NSInteger)pageIndex;
- (void)creatTableView;



@end
