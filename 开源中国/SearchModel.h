//
//  SearchModel.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/2.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYObject.h"

@interface SearchModel : LYObject
@property (nonatomic, copy) NSString *objid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSString *author;
@end
