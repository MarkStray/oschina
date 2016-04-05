//
//  LYHelper.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYHelper : NSObject
//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;

// 根据格式化 字符串 返回 返回具体的时间 差值 秒
+ (NSInteger)getSecondNowToDate:(NSString *)toDate formater:(NSString*)formatStr;

+ (void)alphaFadeAnimationOnView:(UIView *)view WithTitle:(NSString *)title;

@end