//
//  LZXHelper.h
//  Connotation
//
//  Created by LZXuan on 14-12-20.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZXHelper : NSObject
//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

//获取 当前设备版本
+ (double)getCurrentIOS;
//获取当前设备屏幕的大小
+ (CGSize)getScreenSize;

//获得当前系统时间到指定时间的时间差字符串,传入目标时间字符串和格式

+(NSString*)stringNowToDate:(NSString*)toDate formater:(NSString*)formatStr;
//常用 加密 --》md5  base 64  DES

//获取 缓存文件在 沙盒 的路径
+ (NSString *)getFullPathWithMyCacheFile:(NSString *)url;

//检测 缓存文件 是否超时
+ (BOOL)isTimeOutFile:(NSString *)urlPath time:(double)timeout;


@end





