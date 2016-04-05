//
//  NewsModel.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYObject.h"

@interface NewsModel : LYObject
// 所有 界面详情跳转 都用id  评论用 authorid
// <news>
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSString *url;

// 1/2/3  -->> news/blog/soft
kPropertyString(randomtype);
kPropertyString(image);
kPropertyString(detail);

// <newstype>
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *authoruid2;
@property (nonatomic, copy) NSString *eventurl;
// <blog>
@property (nonatomic, copy) NSString *authorname;
@property (nonatomic, copy) NSString *documentType;
@property (nonatomic, copy) NSString *authoruid;

//post
kPropertyString(portrait);
kPropertyString(event);
kPropertyString(favorite);
kPropertyString(viewCount);
kPropertyString(answerCount);




@end
