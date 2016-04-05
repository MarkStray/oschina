//
//  SegmentEngine.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/6.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

// 所有下载数据的页面只需要调用这些方法就可以了
/*
   -----------------------------------------------------------
 - (void)initPageWithArrays{
 NSArray *titles = @[];
 
 NSArray *urls = @[];
 SegmentEngine *engine = [[SegmentEngine alloc] initWithItems:titles];
 [engine firstDownloadWithUrlArray:urls complete:^(id responseData, NSMutableArray *dataArray) {
 [self parseDataWith:responseData array:dataArray];
 }];
 [engine creatTableViewWithController:self];
 // 处理 tableView 代理方法
 [engine setCellForRowCB:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
 return [self tableView:tableView cellForRowAtIndexPath:indexPath WithArray:dataArray];
 }];
 [engine setHeightForRowCB:^CGFloat(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
 return [self tableView:tableView heightForRowAtIndexPath:indexPath WithArray:dataArray];
 }];
 [engine setDidSelectRowCB:^(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
 [self tableView:tableView didSelectRowAtIndexPath:indexPath WithArray:dataArray];
 }];
 [self.view addSubview:engine];
 }
 - (void)parseDataWith:(id)responseData array:(NSMutableArray *)dataArray{
 }
 // 这里的方法自己调用
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
 
 return nil;
 }
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
 return 0;
 }
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithArray:(NSArray *)dataArray{
 
 }
   -----------------------------------------------------------
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "QFRefreshView.h"

// 直接继承自 NSObject 的类是不能处理 事件的
@interface SegmentEngine : UISegmentedControl

// 解析数据的 block
@property (nonatomic, copy) void (^successCB) (id responseData, NSMutableArray *dataArray);


// tableView block  对应三个代理方法
@property (nonatomic, copy) UITableViewCell* (^cellForRowCB) (UITableView *tableView,NSIndexPath *indexPath,NSArray *dataArray);
@property (nonatomic, copy) void (^didSelectRowCB) (UITableView *tableView,NSIndexPath *indexPath,NSArray *dataArray);
@property (nonatomic, copy) CGFloat (^heightForRowCB) (UITableView *tableView,NSIndexPath *indexPath,NSArray *dataArray);


//- (void)setCellForRowCB:( void (^) (UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray))cellForRowCB;
//- (void)setDidSelectRowCB:( void (^)(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray))didSelectRowCB;
//- (void)setHeightForRowCB:( void (^)(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray))heightForRowCB;
//
//- (UITableViewCell *)cellForRowCB;
//- (void)didSelectRowCB;
//- (CGFloat)heightForRowCB;


- (instancetype)initWithItems:(NSArray *)items;

- (void)creatTableViewWithController:(UIViewController *)vc;

- (void)firstDownloadWithUrlArray:(NSArray *)urlArray complete:(void (^) (id responseData, NSMutableArray *dataArray))successCB;



@end
