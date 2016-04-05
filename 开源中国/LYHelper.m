//
//  LYHelper.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-26.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYHelper.h"

//#define kScreenSize [[UIScreen mainScreen] bounds].size

@implementation LYHelper
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr {
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //转化为 时间字符串
    return [df stringFromDate:date];
}
// 根据格式化 字符串 返回 返回具体的时间 差值 秒
+ (NSInteger)getSecondNowToDate:(NSString *)toDate formater:(NSString*)formatStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatStr;
    NSDate *date = [dateFormatter dateFromString:toDate];
    return [[NSDate date] timeIntervalSinceDate:date];
}
    // alpha 动画
+ (void)alphaFadeAnimationOnView:(UIView *)view WithTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenSize.width-180)/2, (kScreenSize.height-60)/2, 180, 60)];
    label.font = [UIFont systemFontOfSize:17];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8.0;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.alpha = 0.0;
    [view addSubview:label];
    [view bringSubviewToFront:label];
    [UIView animateWithDuration:0.8 animations:^{
        label.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            label.alpha = 0.0;
        }];
    }];
}




@end
