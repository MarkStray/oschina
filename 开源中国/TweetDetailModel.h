//
//  TweetDetailModel.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/14.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYObject.h"

@interface TweetDetailModel : LYObject
kPropertyString(allCount);
kPropertyString(pagesize);
@property (nonatomic, strong) NSMutableArray *commentArray;
@end

@interface TweetCommentModel : LYObject

kPropertyString(id);
kPropertyString(author);
kPropertyString(portrait);
kPropertyString(authorid);
kPropertyString(content);
kPropertyString(pubDate);
kPropertyString(appclient);

@end
/*
<allCount>67</allCount><pagesize>20</pagesize><comments><comment><id>5497271</id><portrait>http://static.oschina.net/uploads/user/96/192864_50.jpg?t=1374221687000</portrait><author>FooTearth</author><authorid>192864</authorid><content>osc现在连仙人跳都有了。。</content><pubDate>2015-05-14 19:09:52</pubDate><appclient>3</appclient></comment>
*/
