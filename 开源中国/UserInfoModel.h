//
//  UserInfoModel.h
//  开源中国
//
//  Created by qianfeng01 on 15/4/30.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYObject.h"

@interface UserInfoModel : LYObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *fans;
@property (nonatomic, copy) NSString *followers;
@property (nonatomic, copy) NSString *jointime;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *devplatform;
@property (nonatomic, copy) NSString *expertise;
@property (nonatomic, copy) NSString *relation;
@property (nonatomic, copy) NSString *latestonline;
// 存放 activeModel
@property (nonatomic, strong) NSMutableArray *activiesArray;
@end

@interface ActiveModel : LYObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *catalog;
@property (nonatomic, copy) NSString *objectcatalog;
@property (nonatomic, copy) NSString *objecttype;
@property (nonatomic, copy) NSString *appclient;
@property (nonatomic, copy) NSString *objecttitle;
@property (nonatomic, copy) NSString *objectID;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSString *tweetimage;
@property (nonatomic, copy) NSString *tweetattach;

@end
/*
 <user><name>小潘pfl</name><uid>726879</uid><portrait>http://static.oschina.net/uploads/user/363/726879_100.jpg?t=1401544893000</portrait><score>35</score><fans>18</fans><followers>0</followers><jointime>2012-08-24 12:08:39</jointime><gender>男</gender><from>福建 福州</from><devplatform>Java EE,Java SE,Android,PHP,Linux/Unix</devplatform><expertise>WEB开发,手机软件开发,服务器端开发</expertise><relation>3</relation><latestonline>2015-05-14 13:30:34</latestonline></user><pagesize>20</pagesize><activies><active><id>5489686</id><portrait>http://static.oschina.net/uploads/user/363/726879_50.jpg?t=1401544893000</portrait><author>小潘pfl</author><authorid>726879</authorid><catalog>1</catalog><objecttype>16</objecttype><objectcatalog>0</objectcatalog><objecttitle>2015年5月 TIOBE 编程语言排行榜单</objecttitle><appclient>0</appclient><url/><objectID>62430</objectID><message>java依旧红旗不倒
 </message><commentCount>76</commentCount><pubDate>2015-05-14 08:23:46</pubDate><tweetimage/><tweetattach/></active><active>
 */

