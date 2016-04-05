//
//  QAModel.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/9.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYObject.h"

@interface QAModel : LYObject
kPropertyString(id);
kPropertyString(portrait);
kPropertyString(author);
kPropertyString(authorid);
kPropertyString(title);
kPropertyString(body);
kPropertyString(answerCount);
kPropertyString(viewCount);
kPropertyString(pubDate);
kPropertyString(name);
kPropertyString(time);
/*
 <id>235306</id><portrait>http://static.oschina.net/uploads/user/7/14898_50.jpg?t=1370490062000</portrait><author>kevinG</author><authorid>14898</authorid><title>Git@OSC何时出个代码搜索的功能</title><body>Git@OSC 什么时候出个GITHUB一样的 代码搜索的功能呢？...</body><answerCount>1</answerCount><viewCount>23</viewCount><pubDate>2015-05-08 17:03:45</pubDate><answer><name>Zoker</name><time>2015-05-08 17:14:00</time></answer>
 */
@end
