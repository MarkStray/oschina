//
//  JVFloatingDrawerView.h
//  JVFloatingDrawer
//
//  Created by Julian Villella on 2015-01-11.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatingDrawerViewController.h"

@interface JVFloatingDrawerView : UIView

@property (nonatomic, strong) UIView *leftViewContainer;
@property (nonatomic, strong) UIView *rightViewContainer;
@property (nonatomic, strong) UIView *centerViewContainer;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, assign) CGFloat leftViewContainerWidth;
@property (nonatomic, assign) CGFloat rightViewContainerWidth;

- (UIView *)viewContainerForDrawerSide:(JVFloatingDrawerSide)drawerSide;

- (void)willOpenFloatingDrawerViewController:(JVFloatingDrawerViewController *)viewController;
- (void)willCloseFloatingDrawerViewController:(JVFloatingDrawerViewController *)viewController;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com