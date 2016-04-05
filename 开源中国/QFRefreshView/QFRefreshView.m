//
//  QFRefreshView.m
//  EGODemo
//
//  Created by LZXuan on 15/4/3.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "QFRefreshView.h"
#import <objc/runtime.h>
#import "UIImage+rotation.h"

#if __has_feature(objc_arc)
#define RELEASE(myObj)
#define AUTORELEASE(myObj)
#define SUPERDEALLOC
#else
#define RELEASE(myObj) [myObj release]
#define AUTORELEASE(myObj) [myObj autorelease]
#define SUPERDEALLOC [super dealloc]
#endif

#define kRefreshViewVisibleHeight 60

#pragma mark - QFRefreshView


@interface QFRefreshView ()

@property (nonatomic, strong) UILabel *lastUpdatedLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CALayer *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) UIScrollView *scrollView;

- (void)refreshStateForScroll;
- (void)refreshLastUpdatedDate;

@end

@implementation QFRefreshView
@synthesize state = _state;

- (void)startLoading {
    @throw [NSException exceptionWithName:@"QFRefreshViewException" reason:@"method startLoading should be happen in subclass object" userInfo:nil];
}

- (void)stopLoading {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [self.scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    self.state = QFRefreshViewStateNormal;
}

- (void)refreshStateForScroll {
    @throw [NSException exceptionWithName:@"QFRefreshViewException" reason:@"method refreshStateForScroll should be happen in subclass object" userInfo:nil];
}

- (void)setState:(QFRefreshViewState)state {
    @throw [NSException exceptionWithName:@"QFRefreshViewException" reason:@"method setState: should be happen in subclass object" userInfo:nil];
}

- (void)refreshLastUpdatedDate {
    NSDate *date = [NSDate date];
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    AUTORELEASE(dateFormatter);
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    // self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:date]];
    self.lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Last Updated", @"Last Updated"), [dateFormatter stringFromDate:date]];
    
    // 保存在NSUserDefaults里面不是太实用，故此去掉
    // [[NSUserDefaults standardUserDefaults] setObject:self.lastUpdatedLabel.text forKey:[NSString stringWithFormat:@"%@_LastRefresh", NSStringFromClass(self.class)]];
    // [[NSUserDefaults standardUserDefaults] synchronize];
}

/** - (void)willMoveToSuperview:(UIView *)newSuperview
 *  这个地方需要注意，特别是关于KVO
 *  当当前视图QFRefreshView将要加到newSuperView上的时候这个方法会被调用，这时候，让当前视图QFRefreshView观察superView:
 [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
 
 而当newSuperView将要被销毁时，这个法- (void)willMoveToSuperview:(UIView *)newSuperview 同样也会调用，并且po newSuperView显示它是nil
 .
 newSuperView被销毁时，也就是被观察者对象被销毁时，这时候观察者(当前对象QFRefreshView)应该停止观察：
 [self.superview removeObserver:self forKeyPath:@"contentOffset" context:NULL]
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:NULL];
    
    if (newSuperview) {
        UIScrollView *scrollView = (UIScrollView *)newSuperview;
        self.scrollView = scrollView;
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    if (self.state == QFRefreshViewStateLoading) return;
    if (self.scrollView.refreshFooterView.isLoading) return;
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        /**
        CGPoint point  = CGPointZero;
        NSValue *value = [change objectForKey:@"new"];
        [value getValue:&point];
        [self refreshState:point];
         */
        [self refreshStateForScroll];
    }
}

- (void)dealloc {
    self.lastUpdatedLabel = nil;
    self.statusLabel      = nil;
    self.arrowImage       = nil;
    self.activityView     = nil;

    SUPERDEALLOC;
}

@end

// -----------------------------------------------------------------

#pragma mark - QFRefreshheaderView
@implementation QFRefreshHeaderView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame arrowImageName:@"blackArrow.png" textColor:[UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]];
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
    
    CGFloat labelHeight = 25.0;
    UILabel *label         = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 2*labelHeight, self.frame.size.width, labelHeight)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font             = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor        = textColor;
    label.shadowColor      = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset     = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor  = [UIColor clearColor];
    label.textAlignment    = NSTextAlignmentCenter;
    self.statusLabel  = label;
    [self addSubview:label];
    RELEASE(label);
    
    label                  = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(label.frame), self.frame.size.width, labelHeight)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font             = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor        = textColor;
    label.shadowColor      = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset     = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor  = [UIColor clearColor];
    
    label.textAlignment    = NSTextAlignmentCenter;
    self.lastUpdatedLabel  =   label;
    [self addSubview:label];
    RELEASE(label);
    
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents        = (id)[UIImage imageNamed:arrow].CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    self.arrowImage = layer;
    [[self layer] addSublayer:layer];
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
    self.activityView = view;
    [self addSubview:view];
    RELEASE(view);
    
    self.state = QFRefreshViewStateNormal;
    return self;
}

- (void)refreshStateForScroll {
    self.loading = NO;
    CGPoint contentOffset = self.scrollView.contentOffset;
    //NSLog(@"-----------down-------%f",contentOffset.y);
    if (contentOffset.y > 0) return;
    if (self.state == QFRefreshViewStateLoading) {
        //NSLog(@"-------0-------");
        CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, kRefreshViewVisibleHeight);
        self.scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    } else {
        if (self.scrollView.isDragging) {
            if (self.state == QFRefreshViewStatePulling && contentOffset.y > -65.0 && !self.isLoading) {
                //NSLog(@"-------1-------");
                self.state = QFRefreshViewStateNormal;
            } else if (self.state == QFRefreshViewStateNormal && contentOffset.y < -65.0 && !self.isLoading) {
                //NSLog(@"-------2-------");
                self.state = QFRefreshViewStatePulling;
            }
        } else {
            //NSLog(@"-------3-------");
            if (self.state == QFRefreshViewStatePulling) {
                //NSLog(@"-------4-------");
                self.state = QFRefreshViewStateLoading;
                self.loading = YES;
            }
        }
    }
    
    /**
    if (scrollView.contentInset.top != 0) {
        scrollView.contentInset = UIEdgeInsetsZero;
    }*/
}

- (void)setState:(QFRefreshViewState)state {
    switch (state) {
        case QFRefreshViewStatePulling:
            self.statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.18];
            self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            break;
        case QFRefreshViewStateNormal:
            if (self.state == QFRefreshViewStatePulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:0.18];
                self.arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            // self.statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
            self.statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"");
            [self.activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.arrowImage.hidden = NO;
            self.arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            [self refreshLastUpdatedDate];
            break;
        case QFRefreshViewStateLoading:
            self.statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            [self.activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.arrowImage.hidden = YES;
            [CATransaction commit];
            [self startLoading];
            if (self.scrollView.pullDownHandler) {
                self.scrollView.pullDownHandler(self);
            }
            break;
        default:
            break;
    }
    
    _state = state;
}

- (void)startLoading {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.scrollView.contentInset = UIEdgeInsetsMake(kRefreshViewVisibleHeight, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
}

- (void)dealloc {
    self.pullDownHandler = nil;
    SUPERDEALLOC;
}

@end

// -----------------------------------------------------------------

#pragma mark - QFRefreshFooterView
@implementation QFRefreshFooterView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame arrowImageName:@"blackArrow.png" textColor:[UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]];
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
    CGFloat labelHeight    = 25.0;
    UILabel *label         = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, labelHeight)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font             = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor        = textColor;
    label.shadowColor      = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset     = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor  = [UIColor clearColor];
    label.textAlignment    = NSTextAlignmentCenter;
    self.statusLabel       = label;
    [self addSubview:label];
    RELEASE(label);
    
    label                  = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(label.frame), self.frame.size.width, labelHeight)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font             = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor        = textColor;
    label.shadowColor      = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset     = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor  = [UIColor clearColor];
    label.textAlignment    = NSTextAlignmentCenter;
    self.lastUpdatedLabel  =   label;
    [self addSubview:label];
    RELEASE(label);
    
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(25.0f, 5, 30.0f, 55.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
    UIImage *image = [UIImage imageNamed:arrow];
    // UIImage *rotationImage = [[UIImage alloc] initWithCGImage:[image CGImage] scale:1.0 orientation:UIImageOrientationDown];
    UIImage *rotationImage    = [image rotation:180];
    layer.contents            = (id)rotationImage.CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    self.arrowImage = layer;
    [[self layer] addSublayer:layer];
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(25.0f, 20, 10.0f, 20.0f);
    self.activityView = view;
    [self addSubview:view];
    RELEASE(view);
    
    self.state = QFRefreshViewStateNormal;
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
    
    if (newSuperview) {
        UIScrollView *scrollView = (UIScrollView *)newSuperview;
        self.scrollView = scrollView;
        [newSuperview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    if (self.scrollView.refreshHeaderView.isLoading) return;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.state == QFRefreshViewStateLoading) return;
        [self refreshStateForScroll];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self refreshFrameForContentSize];
    }
}

- (void)refreshStateForScroll {
   // NSLog(@"frame: %f   contentSize: %f", self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    self.loading = NO;
    CGPoint contentOffset = self.scrollView.contentOffset;
    if (contentOffset.y < 0) return;
    
    if (self.state == QFRefreshViewStateLoading) {
        // self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
    } else {
        if (self.scrollView.isDragging) {
            CGSize contentSize = self.scrollView.contentSize;
            if (contentSize.height < self.scrollView.frame.size.height) {
                contentSize.height = self.scrollView.frame.size.height;
            }
            
            CGFloat contentSizeHeight = contentSize.height;
            
            
            if (self.state == QFRefreshViewStatePulling && contentOffset.y < contentSizeHeight-self.scrollView.frame.size.height+65.0 && !self.isLoading) {
                self.state = QFRefreshViewStateNormal;
            } else if (self.state == QFRefreshViewStateNormal && contentOffset.y > contentSizeHeight-self.scrollView.frame.size.height+65 && !self.isLoading) {
                self.state = QFRefreshViewStatePulling;
            }
        } else {
            if (self.state == QFRefreshViewStatePulling) {
                self.state = QFRefreshViewStateLoading;
                self.loading = YES;
            }
        }
    }
}

/**
 *  may be bug here
 */
- (void)refreshFrameForContentSize {
    CGRect frame = self.frame;
    frame.origin.y = MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    self.frame = frame;
    NSLog(@"2-->%f--%@",self.scrollView.contentSize.height,NSStringFromCGRect(frame));
}

- (void)setState:(QFRefreshViewState)state {
    switch (state) {
        case QFRefreshViewStatePulling:
            self.statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.18];
            self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            break;
        case QFRefreshViewStateNormal:
            if (self.state == QFRefreshViewStatePulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:0.18];
                self.arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            self.statusLabel.text = NSLocalizedString(@"Pull up to refresh...", @"Pull up to refresh status");
            [self.activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.arrowImage.hidden = NO;
            self.arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            [self refreshLastUpdatedDate];
            break;
        case QFRefreshViewStateLoading:
            self.statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            [self.activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.arrowImage.hidden = YES;
            [CATransaction commit];
            [self startLoading];
            if (self.scrollView.pullUpHandler) {
                self.pullUpHandler(self);
            }
            break;
        default:
            break;
    }
    
    _state = state;
}

- (void)startLoading {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    /**
     如果当前表格的数据量比较小，当进行上拉操作并松手引起上拉加载时，refreshFooterView会随着tableView的下载而下降到看不见，故加以下判断
     */
    if (self.scrollView.contentSize.height <= self.scrollView.frame.size.height) {
        [self.scrollView setContentOffset:CGPointMake(0, kRefreshViewVisibleHeight) animated:YES];
    }

    self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, kRefreshViewVisibleHeight, 0.0f);
    [UIView commitAnimations];
}

- (void)dealloc {
    self.pullUpHandler = nil;
    SUPERDEALLOC;
}

@end

// -----------------------------------------------------------------

#pragma mark - UIScrollView refresh

@implementation UIScrollView (refresh)

- (void)setRefreshHeaderView:(QFRefreshHeaderView *)refreshHeaderView {
    objc_setAssociatedObject(self, "refreshHeaderView", refreshHeaderView, OBJC_ASSOCIATION_RETAIN);
    [self addSubview:refreshHeaderView];
}

- (QFRefreshHeaderView *)refreshHeaderView {
    QFRefreshHeaderView *headerView = objc_getAssociatedObject(self, "refreshHeaderView");
    return headerView;
}

- (void)setRefreshFooterView:(QFRefreshFooterView *)refreshFooterView {
    objc_setAssociatedObject(self, "refreshFooterView", refreshFooterView, OBJC_ASSOCIATION_RETAIN);
    // [self insertSubview:refreshFooterView atIndex:0];
    [self addSubview:refreshFooterView];
}

- (QFRefreshFooterView *)refreshFooterView {
    QFRefreshFooterView *footerView = objc_getAssociatedObject(self, "refreshFooterView");
    return footerView;
}

#pragma mark - modify by liuyuan
/*
- (void)setPullDownWithPageCount:(NSInteger)index Handler:(QFRefreshViewHandler)pullDownHandler {
    if (self.refreshHeaderView.tag != 1001+index) {
        QFRefreshHeaderView *headerView = [[QFRefreshHeaderView alloc] initWithFrame:CGRectMake(self.frame.size.width*index, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        headerView.tag = 1001+index;
        headerView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        //保存 block
        headerView.pullDownHandler = pullDownHandler;
        self.refreshHeaderView     = headerView;
        NSLog(@"index_%ld : %@",index,self.refreshHeaderView);
        RELEASE(headerView);
    }
}

- (void)setPullUpWithPageCount:(NSInteger)index Handler:(void (^)(QFRefreshView *))pullUpHandler {
    if (self.refreshFooterView.tag != 1005+index) {
        CGFloat originY = MAX(self.contentSize.height, self.frame.size.height);
        QFRefreshFooterView *footerView = [[QFRefreshFooterView alloc] initWithFrame:CGRectMake(self.frame.size.width*index, originY, self.frame.size.width, self.frame.size.height)];
        footerView.tag = 1005+index;
        //保存block
        footerView.pullUpHandler        = pullUpHandler;
        footerView.backgroundColor      = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.refreshFooterView          = footerView;
        RELEASE(footerView);
    }
}
*/
#pragma mark - end -----------------


- (void)setPullDownHandler:(QFRefreshViewHandler)pullDownHandler {
    if (!self.refreshHeaderView) {
        QFRefreshHeaderView *headerView = [[QFRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        NSLog(@"%@",NSStringFromCGRect(headerView.frame));
        headerView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        //保存 block
        headerView.pullDownHandler = pullDownHandler;
        self.refreshHeaderView     = headerView;
        RELEASE(headerView);
    }
}

- (void)setPullUpHandler:(void (^)(QFRefreshView *))pullUpHandler {
    if (!self.refreshFooterView) {
        CGFloat originY = MAX(self.contentSize.height, self.frame.size.height);
        QFRefreshFooterView *footerView = [[QFRefreshFooterView alloc] initWithFrame:CGRectMake(0, originY, self.frame.size.width, self.frame.size.height)];
        NSLog(@"%@",NSStringFromCGRect(footerView.frame));
        //保存block
        footerView.pullUpHandler        = pullUpHandler;
        footerView.backgroundColor      = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.refreshFooterView          = footerView;
        RELEASE(footerView);
    }
}



- (void (^)(QFRefreshView *))pullDownHandler {
    return self.refreshHeaderView.pullDownHandler;
}

- (void (^)(QFRefreshView *))pullUpHandler {
    return self.refreshFooterView.pullUpHandler;
}

- (void)stopHeaderViewLoading {
    [self.refreshHeaderView stopLoading];
}
- (void)stopFooterViewLoading {
    [self.refreshFooterView stopLoading];
}


@end