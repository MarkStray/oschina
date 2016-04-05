//
//  FeedbackViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/13.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "LYHelper.h"
@interface FeedbackViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *placeHolderTextView;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(commitAdviceFeedback)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = @"意见反馈";
    [self creatTextView];
}
//<app=2&msg=%E7%BB%A7%E7%BB%AD%E5%BC%80%E6%BA%90%E7%B2%BE%E7%A5%9E%0A&report=2>
- (void)commitAdviceFeedback{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:kFeedBackUrl parameters:@{@"app":@"2",@"msg":self.textView.text,@"report":@"2"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // <正在发送反馈 感谢你的反馈>
        if (responseObject) {
            NSString *success = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([success isEqualToString:@"success"]) {
                [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"成功提交,感谢你的反馈!"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"post feedBack failed : %@",error);
    }];
}
- (void)creatTextView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    // placeHolderTextView
    self.placeHolderTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
    self.placeHolderTextView.text = @"感谢你的反馈,请提出你的意见与建议";
    self.placeHolderTextView.font = [UIFont systemFontOfSize:16];
    self.placeHolderTextView.textColor = [UIColor lightGrayColor];
    self.placeHolderTextView.backgroundColor = [UIColor whiteColor];
    self.placeHolderTextView.editable = NO;
    self.textView.scrollEnabled = NO;
    [self.view addSubview:self.placeHolderTextView];
    // 真正的 textView
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.editable = YES;
    self.textView.scrollEnabled = NO;
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        // 事实 证明 只需要 改 backgroundColor  就能 达到 效果
        //self.placeHolderTextView.hidden = YES;
        self.textView.backgroundColor = [UIColor whiteColor];
    }
    // 下面的判断是   证明  向后 退的 最后一格
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        //self.placeHolderTextView.hidden = NO;
        self.textView.backgroundColor = [UIColor clearColor];
    }
    return YES;
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
