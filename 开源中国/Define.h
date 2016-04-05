//
//  Define.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#ifndef _____Define_h
#define _____Define_h
// 属性字符串
#define kPropertyString(s) @property (nonatomic, copy) NSString *s

// 通知中心 常量
#define kLoginValidateSuccess @"LoginValidateSuccess"
#define kLoginValidateFailed @"LoginValidateFailed"

#define kLogout @"Logout"

// 左边视图 登录
#define kShouldLoginMessage @"ShouldLoginMessage"
// 左边视图 常量
#define kLeftViewLetNavigationPushControllers @"NavigationPushControllers"



// 注释 开关
//#define __OPTIMIZE__
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif
// 自定义 常量
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kDebugPrint() NSLog(@"%s,%d",__func__,__LINE__)
#define kDebugSeparator() NSLog(@"─────────────────────────────────────────────────────────────────────────────────────────────────────")
// 定义 宏 取消 导航响
#define kDismissNavigationItem self.navigationItem.leftBarButtonItem = nil,self.navigationItem.rightBarButtonItem = nil

#define K_BLUE_COLOR [UIColor colorWithRed:161/255.f green:202/255.f blue:52/255.f alpha:1.0]
#define K_BLACK_COLOR [UIColor colorWithRed:105/255.f green:105/255.f blue:105/255.f alpha:1.0]
#define K_GRAY_COLOR [UIColor colorWithRed:126/255.f green:126/255.f blue:126/255.f alpha:1.0]
#define K_BG_WHITE_COLOR [UIColor colorWithRed:236/255.f green:236/255.f blue:236/255.f alpha:1.0]
#define K_TABBAR_COLOR [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1.0]

#define K_ORANGE_COLOR [UIColor colorWithRed:168/255.f green:149/255.f blue:120/255.f alpha:1.0]

//-----------------------------开源中国接口-------------------------------//
// News接口:<第一部分>
#define kInfoUrl @"http://www.oschina.net/action/api/news_list?catalog=1&pageIndex=%ld&pageSize=20"
#define kHotUrl @"http://www.oschina.net/action/api/news_list?show=week"
#define kBolgUrl @"http://www.oschina.net/action/api/blog_list?type=latest&pageIndex=%ld&pageSize=20"
#define kRecommendUrl @"http://www.oschina.net/action/api/blog_list?type=recommend&pageIndex=%ld&pageSize=20"

// News详情接口:  以下 id 属性值 均为 上个接口中的 id 值
#define kInfoDetailUrl @"http://www.oschina.net/action/api/news_detail?id=%@"
#define kHotDetailUrl @"http://www.oschina.net/action/api/news_detail?id=%@"
#define kBolgDetailUrl @"http://www.oschina.net/action/api/blog_detail?id=%@"
#define kRecommendDetailUrl @"http://www.oschina.net/action/api/blog_detail?id=%@"

// 所有评论接口: (comment)<catalog:1-news/2-QA/3-tweet>

// catalog 1/2/3/4    新闻/问题/动态/博客
/*
#define kCommentCatalogUrl @"http://www.oschina.net/action/api/comment_list?catalog=%ld&id=%@&pageIndex=%ld&pageSize=20"
#define kCommentBlogUrl @"http://www.oschina.net/action/api/blogcomment_list?id=%@&pageIndex=%ld&pageSize=20"
*/
#define kNewsCommentUrl @"http://www.oschina.net/action/api/comment_list?catalog=1&id=%@&pageIndex=%ld&pageSize=20"
#define kBlogCommentUrl @"http://www.oschina.net/action/api/blogcomment_list?id=%@&pageIndex=%ld&pageSize=20"
#define kSoftCommentUrl @"http://www.oschina.net/action/api/comment_list?catalog=3&id=%@&pageIndex=%ld&pageSize=20"
#define kPostCommentUrl @"http://www.oschina.net/action/api/comment_list?catalog=2&id=%@&pageIndex=%ld&pageSize=20"


// News评论接口(发表pub):<post> <catalog=1&content=%E5%90%8A&id=61674&isPostToMyZone=0&uid=2352281>
#define kInfoCommentPubUrl @"http://www.oschina.net/action/api/comment_pub"
#define kCommentPubUrl @"http://www.oschina.net/action/api/comment_pub"
#define kBlogCommentPubUrl @"http://www.oschina.net/action/api/blogcomment_pub"
#define kRecommendCommentPubUrl @"http://www.oschina.net/action/api/blogcomment_pub"

// 接口(收藏):<post> <objid=61707&type=4&uid=2352281>
#define kFavoriteAddUrl @"http://www.oschina.net/action/api/favorite_add"
#define kFavoriteDeleteUrl @"http://www.oschina.net/action/api/favorite_add"
/* 友盟
 http://log.umsns.com/bar/get/54c9a412fd98c5779c000752/?ud_get=+CIx/QwfRFvjTT7AV/XrknYwtuu1EFW61ggdBGUG/naYq+QuE1YPUYu0HxOupYd6KMFkjJtY0Fkw+xzxMBAvTH2DcZ8o1RdcvehtKlTV7kuB+Rnxo00FHbtii6WWHo0DBa35g2tmTGhy1z5Zaf04Kw+5gGuAG+m8TlOAmuzSpUtixXuAvdchYdFvt1VzYMl+7pnwzvQ/yBG2dzYhRAECKWs+2v5eSm2zOYAntm3hHfNCSXYtgIhwbRWOGrVv8Fh5dBwIXJMa+lTv6gUnnGqojw==
 */

// 动弹接口: <第二部分> 0/-1/2352281
#define kTweetUrl @"http://www.oschina.net/action/api/tweet_list?uid=%@&pageIndex=%ld&pageSize=20"
#define kHotTweetUrl @"http://www.oschina.net/action/api/tweet_list?uid=%@&pageIndex=%ld&pageSize=20"
// uid 为用户名  id 标记那一条评论
#define kMyTweetUrl @"http://www.oschina.net/action/api/tweet_list?uid=%@&pageIndex=%ld&pageSize=20"
// 动弹评论接口:
#define kTweetCommentUrl @"http://www.oschina.net/action/api/comment_list?catalog=3&id=%@&pageIndex=%ld&pageSize=20"
#define kTweetDetailUrl @"http://www.oschina.net/action/api/tweet_detail?id=%@";
#define kTweetLikeListUrl @"http://www.oschina.net/action/api/tweet_like_list?tweetid=%@&pageIndex=0&pageSize=20"
#define kUserInformationUrl @"http://www.oschina.net/action/api/user_information?uid=%@&hisuid=%@&pageIndex=0&pageSize=20"

// 搜索接口: <第三部分>
// catelog : software/post/blog/news  content = ?????搜索内容
#define kSearchListUrl @"http://www.oschina.net/action/api/search_list?catalog=%@&content=%@&pageIndex=%ld&pageSize=20"
// ? : software/post/blog/news |||||   ? id --> result_id

//<title>编码定位 Open Location Code</title>
//http://www.oschina.net/action/api/software_detail?ident=open-location-code
// 详情接口
#define kSoftwordDetailUrl @"http://www.oschina.net/action/api/software_detail?ident=%@"
#define kSearchDetailUrl @"http://www.oschina.net/action/api/%@_detail?id=%@"
// 评论接口
#define kSoftwordCMTUrl @"http://www.oschina.net/action/api/software_tweet_list?project=29504&pageIndex=0&pageSize=20"
#define kSearchCMTUrl @"http://www.oschina.net/action/api/comment_list?catalog=2&id=164547&pageIndex=0&pageSize=20"
// <------------------------登录------------------------> //

#define kLoginValidateUrl @"http://www.oschina.net/action/api/login_validate"
// 消息中心
//@"http://www.oschina.net/action/api/active_list?catalog=2&pageIndex=0&pageSize=20&uid=2352281"
//@"http://www.oschina.net/action/api/active_list?catalog=3&pageIndex=0&pageSize=20&uid=2352281"
//@"http://www.oschina.net/action/api/message_list?uid=2352281&pageIndex=0&pageSize=20"
// 收藏 type=1/2/3/4/5
#define kFavoriteListUrl @"http://www.oschina.net/action/api/favorite_list?uid=%ld&type=1&pageIndex=0&pageSize=20"
// 关注/粉丝 relation=1/0
#define kFriendsListFollowersUrl @"http://www.oschina.net/action/api/friends_list?uid=%@&relation=1&pageIndex=0&pageSize=20"
#define kFriendsListFansUrl @"http://www.oschina.net/action/api/friends_list?uid=%@&relation=0&pageIndex=0&pageSize=20"

//@"http://www.oschina.net/action/api/my_tweet_like_list"

#define kFeedBackUrl @"http://www.oschina.net/action/api/user_report_to_admin"
// <正在发送反馈 感谢你的反馈>
//--// 意见反馈 post <app=2&msg=%E7%BB%A7%E7%BB%AD%E5%BC%80%E6%BA%90%E7%B2%BE%E7%A5%9E%0A&report=2> http://www.oschina.net/action/api/user_report_to_admin




// wo de
//@"http://www.oschina.net/action/api/tweet_list?uid=2352281&pageIndex=0&pageSize=20"

/*
#define api_news_list @"http://www.oschina.net/action/api/news_list"
#define api_news_detail @"http://www.oschina.net/action/api/news_detail"
#define api_post_list @"http://www.oschina.net/action/api/post_list"
#define api_post_detail @"http://www.oschina.net/action/api/post_detail"
#define api_post_pub @"http://www.oschina.net/action/api/post_pub"
#define api_tweet_list @"http://www.oschina.net/action/api/tweet_list"
#define api_tweet_detail @"http://www.oschina.net/action/api/tweet_detail"
#define api_tweet_delete @"http://www.oschina.net/action/api/tweet_delete"
#define api_tweet_pub @"http://www.oschina.net/action/api/tweet_pub"
#define api_active_list @"http://www.oschina.net/action/api/active_list"
#define api_message_list @"http://www.oschina.net/action/api/message_list"
#define api_message_delete @"http://www.oschina.net/action/api/message_delete"
#define api_message_pub @"http://www.oschina.net/action/api/message_pub"
#define api_comment_list @"http://www.oschina.net/action/api/comment_list"
#define api_comment_pub @"http://www.oschina.net/action/api/comment_pub"
#define api_comment_reply @"http://www.oschina.net/action/api/comment_reply"
#define api_comment_delete @"http://www.oschina.net/action/api/comment_delete"
#define api_login_validate @"https://www.oschina.net/action/api/login_validate"
#define api_user_info @"http://www.oschina.net/action/api/user_info"
#define api_user_information @"http://www.oschina.net/action/api/user_information"
#define api_user_updaterelation @"http://www.oschina.net/action/api/user_updaterelation"
#define api_notice_clear @"http://www.oschina.net/action/api/notice_clear"
#define api_software_detail @"http://www.oschina.net/action/api/software_detail"
#define api_blog_detail @"http://www.oschina.net/action/api/blog_detail"
#define api_favorite_list @"http://www.oschina.net/action/api/favorite_list"
#define api_favorite_add @"http://www.oschina.net/action/api/favorite_add"
#define api_favorite_delete @"http://www.oschina.net/action/api/favorite_delete"
#define api_user_notice @"http://www.oschina.net/action/api/user_notice"
#define api_search_list @"http://www.oschina.net/action/api/search_list"
#define api_friends_list @"http://www.oschina.net/action/api/friends_list"
#define api_softwarecatalog_list @"http://www.oschina.net/action/api/softwarecatalog_list"
#define api_software_list @"http://www.oschina.net/action/api/software_list"
#define api_softwaretag_list @"http://www.oschina.net/action/api/softwaretag_list"
#define api_blogcomment_list @"http://www.oschina.net/action/api/blogcomment_list"
#define api_blogcomment_pub @"http://www.oschina.net/action/api/blogcomment_pub"
#define api_my_information @"http://www.oschina.net/action/api/my_information"
#define api_blogcomment_delete @"http://www.oschina.net/action/api/blogcomment_delete"
#define api_userblog_delete @"http://www.oschina.net/action/api/userblog_delete"
#define api_userblog_list @"http://www.oschina.net/action/api/userblog_list"
#define api_blog_list @"http://www.oschina.net/action/api/blog_list"
#define api_userinfo_update @"http://www.oschina.net/action/api/portrait_update"
*/
#endif
