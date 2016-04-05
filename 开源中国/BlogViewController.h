//
//  BlogViewController.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "BaseViewController.h"

@interface BlogViewController : BaseViewController

@property (nonatomic, copy) NSString *title;
// www.oschina.net/action/api/userblog_list?authoruid=139664&pageIndex=0
// uid  通知 单例 获取
@property (nonatomic, copy) NSString *authoruid;

@end
