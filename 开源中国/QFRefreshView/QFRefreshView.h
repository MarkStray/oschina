//
//  QFRefreshView.h
//  EGODemo
//
//  Created by LZXuan on 15/4/3.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QFRefreshViewState) {
    QFRefreshViewStatePulling = 0,
    QFRefreshViewStateNormal,
    QFRefreshViewStateLoading
};

@class QFRefreshView;
typedef void (^QFRefreshViewHandler) (QFRefreshView *refreshView);

#pragma mark - QFRefreshView
@interface QFRefreshView : UIView
{
    QFRefreshViewState _state;
}

@property (nonatomic, copy) QFRefreshViewHandler handler;
@property (nonatomic, getter=isLoading) BOOL loading;

@property (nonatomic) QFRefreshViewState state;

- (void)startLoading;
- (void)stopLoading;

@end

// -----------------------------------------------------------------

#pragma mark - QFRefreshHeaderView
@interface QFRefreshHeaderView : QFRefreshView
//modfy by lzx 2015-4-13
@property (nonatomic, copy) QFRefreshViewHandler pullDownHandler;

@end

// -----------------------------------------------------------------

#pragma mark - QFRefreshFooterView
@interface QFRefreshFooterView : QFRefreshView

@property (nonatomic, copy) QFRefreshViewHandler pullUpHandler;
@end

// -----------------------------------------------------------------

@interface UIScrollView (refresh)

/*modfy by lzx 2015-4-13
    reason:用 @property 声明带block的变量 提示不全
 */

#pragma mark - modify by liuyuan
////设置 下拉刷新
//- (void)setPullDownWithPageCount:(NSInteger)index Handler:(QFRefreshViewHandler)pullDownHandler;
//
////设置上拉加载
//- (void)setPullUpWithPageCount:(NSInteger)index Handler:(QFRefreshViewHandler)pullUpHandler;
#pragma mark - end ---------------

//设置 下拉刷新
- (void)setPullDownHandler:(QFRefreshViewHandler)pullDownHandler;

//设置上拉加载
- (void)setPullUpHandler:(QFRefreshViewHandler)pullUpHandler;



- (QFRefreshViewHandler)pullDownHandler;
- (QFRefreshViewHandler)pullUpHandler;

/*
 @property (nonatomic, copy) void (^pullDownHandler)(QFRefreshView *refreshView);
@property (nonatomic, copy) void (^pullUpHandler)(QFRefreshView *refreshView);
 */
@property (nonatomic, strong) QFRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) QFRefreshFooterView *refreshFooterView;
- (void)stopHeaderViewLoading;
- (void)stopFooterViewLoading;

@end
