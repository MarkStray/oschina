//
//  CommentsModel.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "NewsModel.h"

@interface CommentsModel : NewsModel

@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *appclient;
// refer
@property (nonatomic, strong) NSMutableArray *refersArray;

@end
// refer类
@interface RefersModel : LYObject

@property (nonatomic, copy) NSString *refertitle;
@property (nonatomic, copy) NSString *referbody;

@end