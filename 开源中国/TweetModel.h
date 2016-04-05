//
//  TweetModel.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYObject.h"

@interface TweetModel : LYObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *attach;
// appclient 4 --> iphone
// appclient 3 --> android
// appclient 1 --> 无
@property (nonatomic, copy) NSString *appclient;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *imgSmall;
@property (nonatomic, copy) NSString *imgBig;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSString *likeCount;
@property (nonatomic, copy) NSString *isLike;
@property (nonatomic, copy) NSString *likeList;
@end

@interface UserModel : LYObject

kPropertyString(name);
kPropertyString(uid);
kPropertyString(portrait);

@end
/*
 <tweet><id>5353301</id><body>
 光盘行动从我做起
 <a href='http://my.oschina.net/u/1539302' target="_blank" rel="nofollow">@Helloall</a>        	</body><author>OSC叶童</author><authorid>2306455</authorid><appclient>3</appclient><commentCount>43</commentCount><portrait>http://static.oschina.net/uploads/user/1153/2306455_50.jpg?t=1429542284000</portrait><pubDate>2015-04-25 22:52:42</pubDate><imgSmall>http://static.oschina.net/uploads/space/2015/0425/225243_y7n6_2306455_thumb.jpg</imgSmall><imgBig>http://static.oschina.net/uploads/space/2015/0425/225243_y7n6_2306455.jpg</imgBig><attach/><likeCount>12</likeCount><isLike>0</isLike><likeList><user><name>开源中国首席技术官</name><uid>1997902</uid><portrait>http://static.oschina.net/uploads/user/998/1997902_50.jpg?t=1407806577000</portrait></user><user><name>be-quiet</name><uid>2298961</uid><portrait>http://static.oschina.net/uploads/user/1149/2298961_50.jpg?t=1421980269000</portrait></user>
 */

