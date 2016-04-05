//
//  LoginModel.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYObject.h"
#define kPropertyString(s) @property (nonatomic, copy) NSString *s
@interface LoginModel : LYObject
// user
kPropertyString(uid);
kPropertyString(location);
kPropertyString(name);
kPropertyString(followers);
kPropertyString(fans);
kPropertyString(score);
kPropertyString(portrait);
kPropertyString(favoritecount);
kPropertyString(gender);
// 关注/收藏
kPropertyString(expertise);// 开发平台

kPropertyString(userid);
// 搜索
kPropertyString(from);


// notice
//kPropertyString(atmeCount);
//kPropertyString(msgCount);
//kPropertyString(reviewCount);
//kPropertyString(newFansCount);
//kPropertyString(newLikeCount);
@end
