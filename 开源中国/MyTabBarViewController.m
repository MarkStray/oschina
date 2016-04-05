//
//  MyTabBarViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "HYActivityView.h"
// 底部 add 视图
#import "TextViewController.h"
#import "ShakeViewController.h"
#import "ScanViewController.h"
#import "SeekViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>


#define kPopIconNumbers 6

@interface MyTabBarViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatViewControllers];
    [self creatMyTabBar];
}
- (void)creatViewControllers{
    NSArray *titles = @[@"综合",@"动弹",@"发现",@"我"];
    NSArray *controllers = @[@"NewsViewController",@"TweetViewController",@"DiscoverViewController",@"MeViewController"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i=0; i<4; i++) {
        Class class = NSClassFromString(controllers[i]);
        BaseViewController *bvc = [[class alloc] init];
        bvc.navigationItem.title = titles[i];;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bvc];
        [mutableArray addObject:nav];
    }
    self.viewControllers = [mutableArray copy];
    NSLog(@"self_viewControllers_count:%ld",self.viewControllers.count);
}
// 解决思路 让系统的 tabBar 为空  把自己的放在系统上
- (void)creatMyTabBar{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 49)];
    view.tag = 9999;
    view.backgroundColor = K_TABBAR_COLOR;
    view.userInteractionEnabled = YES;
    NSArray *titles = @[@"综合",@"动弹",@"",@"发现",@"我"];
    NSArray *images = @[@"news",@"tweet",@"more",@"discover",@"me"];
    for (NSInteger i=0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat space = (kScreenSize.width-30*5)/6;
        
        btn.frame = CGRectMake(space+(30+space)*i, 5, 30, 30);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar-%@",images[i]]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar-%@-selected",images[i]]] forState:UIControlStateSelected];
        
        btn.tag = 1001+i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            //默认选中第0个
            self.selectedIndex = 0;
            btn.selected = YES;
        }
        if (i == 2) {
            btn.frame = CGRectMake(space+(26+space)*i, 5, 42, 42);
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 20;
            btn.backgroundColor = K_BLUE_COLOR;
            [view addSubview:btn];
            continue;
        }
        [view addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space/2+(space+30)*i, 30+5, space+30, 14)];
        label.tag = btn.tag + 10;
        label.backgroundColor = K_TABBAR_COLOR;
        label.font = [UIFont systemFontOfSize:10];
        label.text = titles[i];
        label.textColor = K_GRAY_COLOR;
        if (i == 0) {
            label.textColor = K_BLUE_COLOR;
        }
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    NSLog(@"view_super_view:%@",self.view);
    [self.tabBar addSubview:view];// 把自己的tabbar 放在系统的上面
}
// 用button  来控制器tabBarController 的 selectedIndex 或者 selectedViewController 就可以切换 tabBarController中的子视图控制器
- (void)buttonClick:(UIButton *)button{
    NSInteger index = button.tag-1001;
    //设置选中的索引 那么 就会切换视图
    if (index < 2) {
        self.selectedIndex = index;
    }else if (index > 2){
        self.selectedIndex = index-1;
    }else{// 中间 加号按钮 弹出视图
        [self addPopUpView];
    }
    
    //遍历 imageView 的所有子视图 找出UIButton
    for (UIView *view in button.superview.subviews) {
        // 修改 button 的选中状态
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag != button.tag) {
                btn.selected = NO;//把其他非选中的按钮 置为NO
            }else{
                button.selected = YES;//选中
            }
        }
        // 修改 label 的颜色
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            if (label.tag != button.tag+10) {
                label.textColor = K_GRAY_COLOR;
            }else{
                label.textColor = K_BLUE_COLOR;
            }
        }
    }
}
#pragma mark - 弹出视图
- (void)addPopUpView{
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = kPopIconNumbers;
        NSArray *titles = @[@"文字",@"相册",@"拍照",@"摇一摇",@"扫一扫",@"找人"];
        NSArray *images = @[@"tweetEditing",@"picture",@"shooting",@"shake",@"scan",@"search"];
        for (NSInteger i=0; i<kPopIconNumbers; i++) {
            ButtonView *buttonView = [[ButtonView alloc] initWithText:titles[i] image:[UIImage imageNamed:images[i]] handler:^(ButtonView *buttonView) {
                [self handleBlockWithTag:i];
            }];
            [self.activityView addButtonView:buttonView];
        }
    }
    [self.activityView show];
}

- (void)handleBlockWithTag:(NSInteger)tag{
    if (tag == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self loadImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else{
            [self showAlertViewWithMessage:@"不支持相册功能"];
        }
        return;
    }else if (tag == 2){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self loadImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
        }else{
            [self showAlertViewWithMessage:@"不支持拍照功能"];
        }
        return;
    }
    
    NSArray *vcArray = @[@"TextViewController",@"",@"",@"Shake_dupViewController",@"Scan_dupViewController",@"Seek_dupViewController"];
    Class class = NSClassFromString(vcArray[tag]);
    SuperViewController *baseVc = [[class alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:baseVc];
    // 默认就是 这种 效果
    //nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:nav animated:YES completion:^{
        NSLog(@"模态跳转完成");
    }];
}
#pragma mark - 相册 照片
- (void)loadImagePickerControllerWithType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)showAlertViewWithMessage:(NSString *)msg{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    kDebugPrint();
}
// choose
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    kDebugPrint();
    NSString *sourceType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        TextViewController *sendMsg = [[TextViewController alloc] init];
        sendMsg.image = image;
        // 下面这句话  必须要  模态跳转不能嵌套
        [picker dismissViewControllerAnimated:YES completion:nil];
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendMsg];
        [self presentViewController:nav animated:YES completion:^{
            NSLog(@"模态跳转完成2");
        }];
        return;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// cancle
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    kDebugPrint();
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 屏幕适配

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
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
