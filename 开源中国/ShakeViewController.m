//
//  ShakeViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/4/28.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "ShakeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RockView.h"
#import "NewsModel.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "NewsDetailViewController.h"
@interface ShakeViewController ()
{
    SystemSoundID soundID;
}
@property (nonatomic) UIImageView *imageView;
@property (nonatomic, strong) RockView *bottomView;
@property (nonatomic, strong) NewsModel *model;
@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    kDismissNavigationItem;
    self.navigationItem.title = @"摇一摇";
    // 摇动图片
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenSize.width-176)/2-88, (kScreenSize.height-200)/2+50, 176, 200)];
    self.imageView.image = [UIImage imageNamed: @"shaking"];
    
    // 修改 锚点
    self.imageView.layer.anchorPoint = CGPointMake(0, 1);
    [self.view addSubview:self.imageView];
    
    // 初始化 系统声音
#if 0
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
#else
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"glass" withExtension:@"wav"];
#endif
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    
    
#if 0
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 70, 50, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
#endif
    [self creatBottomView];
}
#pragma mark - rockView
- (void)creatBottomView{
    self.bottomView = [[[UINib nibWithNibName:@"RockView" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
    self.bottomView.frame = CGRectMake(0, kScreenSize.height-82, kScreenSize.width, 82);
    self.bottomView.hidden = YES;
    [self.view addSubview:self.bottomView];
    // 增加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewClick)];
    [self.bottomView addGestureRecognizer:tap];
}
- (void)bottomViewClick{
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    newsDetail.model = self.model;
    newsDetail.hidesBottomBarWhenPushed = YES;
    // 1/2/3  -->> news/blog/soft
    if (self.model.randomtype.integerValue == 1) {
        newsDetail.tableViewTag = 1001;
    }else if (self.model.randomtype.integerValue == 2){
        newsDetail.tableViewTag = 1003;
    }else if (self.model.randomtype.integerValue == 3){
        newsDetail.tableViewTag = 999;
    }
    [self.navigationController pushViewController:newsDetail animated:YES];
}

- (void)btnClick{
    [self addShakeAnimation];
}
#pragma mark - 手机摇动特效

- (void)addShakeAnimation{
    
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 加上物理特效
    keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 关键帧
    keyframeAnimation.values = @[@(M_PI_2),@(0)];
    keyframeAnimation.repeatCount = 2;
    // 每帧对应的时间
    keyframeAnimation.keyTimes = @[@0.5,@0.5];
    keyframeAnimation.duration = 0.5;
    [self.imageView.layer addAnimation:keyframeAnimation forKey:nil];
    
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    kDebugPrint();
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"开始摇动");
    }
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"取消摇动");
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    kDebugPrint();
    if (motion == UIEventSubtypeMotionShake) {
        [self addShakeAnimation];
        AudioServicesPlaySystemSound(soundID);
        [self downloadRockData];
        NSLog(@"结束摇动");
    }
}
- (void)downloadRockData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://www.oschina.net/action/api/rock_rock" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            GDataXMLElement *ele = [doc rootElement];
            self.model = [[NewsModel alloc] init];
            [self.model setValuesForKeysWithDictionary:[ele subDictWithArray:@[@"randomtype",@"id",@"title",@"detail",@"author",@"authorid",@"image",@"url",@"pubDate",@"commentCount"]]];
            [self.bottomView updateUIWithModel:self.model];
            self.bottomView.hidden = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"rock data download failed : %@",error);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
