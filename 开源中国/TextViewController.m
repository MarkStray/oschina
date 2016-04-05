//
//  TextViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/11.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "TextViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "DDXML.h"
#import "AppDelegate.h"
#import "LYHelper.h"
#import "LZXHelper.h"
#import "CustomImageView.h"

#define KTweetPubUrl @"http://www.oschina.net/action/api/tweet_pub"

extern BOOL isLogin;

@interface TextViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
// 实现 提示语 的 placeHolderTextView
@property (nonatomic, strong) UITextView *placeHolderTextView;
@property (nonatomic, strong) CustomImageView *imageView;

@property (nonatomic, assign) BOOL isHidden;

@end

@implementation TextViewController
/*
 --Boundary+06AD79055B33A724
 Content-Disposition: form-data; name="msg"
 
 666
 --Boundary+06AD79055B33A724
 Content-Disposition: form-data; name="uid"
 
 2352281
 --Boundary+06AD79055B33A724--
 
 ----------------------- -----------------------  -----------------------
 --Boundary+BC739D9B6482FFD8
 Content-Disposition: form-data; name="msg"
 
 {发送的内容}
 --Boundary+BC739D9B6482FFD8
 Content-Disposition: form-data; name="uid"
 
 {2352281}
 --Boundary+BC739D9B6482FFD8
 Content-Disposition: form-data; name="img"; filename="img.jpg"
 Content-Type: image/jpeg
 
 {图片二进制编码}
--Boundary+BC739D9B6482FFD8--
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"弹一弹";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(SendClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self creatTextView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];// 收键盘
}

- (void)creatTextView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    // placeHolderTextView
    self.placeHolderTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
    self.placeHolderTextView.text = @"今天你动弹了吗?";
    NSLog(@"self.placeHolderTextView.font:%@",self.placeHolderTextView.font);
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
    if (self.image) {
        self.imageView = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 120, 80, 80)];
        self.isHidden = NO;
        self.imageView.image = self.image;
        __weak typeof(self) weakSelf = self;
        [self.imageView setDeleteBlocks:^{
            weakSelf.isHidden = YES;
            [weakSelf.imageView removeFromSuperview];
        }];
        // 设置textView  的光标位置 下移 80
        [self.textView addSubview:self.imageView];
    }
}
/*
 1.如果只是静态显示textView的内容为设置的行间距，执行如下代码：
 
 //    textview 改变字体的行间距
 NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
 paragraphStyle.lineSpacing = 10;// 字体的行间距
 
 NSDictionary *attributes = @{
 NSFontAttributeName:[UIFont systemFontOfSize:15],
 NSParagraphStyleAttributeName:paragraphStyle
 };
 textView.attributedText = [[NSAttributedString alloc] initWithString:@"输入你的内容" attributes:attributes];
 
 
 
 2.如果是想在输入内容的时候就按照设置的行间距进行动态改变，那就需要将上面代码放到textView的delegate方法里
 
 -(void)textViewDidChange:(UITextView *)textView
 
 {
 
 //    textview 改变字体的行间距
 
 NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
 
 paragraphStyle.lineSpacing = 20;// 字体的行间距
 
 
 
 NSDictionary *attributes = @{
 
 NSFontAttributeName:[UIFont systemFontOfSize:15],
 
 NSParagraphStyleAttributeName:paragraphStyle
 
 };
 
 textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
 }
 */

#pragma mark - UItextViewDelegate
// 改变 imageView 的偏移量
- (void)textViewDidChange:(UITextView *)textView{
    kDebugPrint();
    CGFloat height = [LZXHelper textHeightFromTextString:textView.text width:kScreenSize.width fontSize:18];
    self.imageView.frame = CGRectMake(10, 120+height, 80, 80);
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
- (void)SendClick{
    if (isLogin) {
        if (self.textView.text || self.image) {
            NSLog(@"将要发送的文本内容：%@",self.textView.text);
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            // post 上传 文件 图片
            [manager POST:KTweetPubUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                // 上传文字
                [formData appendPartWithFormData:[self.textView.text dataUsingEncoding:NSUTF8StringEncoding] name:@"msg"];
                // 上传账号
                [formData appendPartWithFormData:[[AppDelegate globalDelegate].myAuthorId dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
                // 上传图片
                //NSData *data = UIImagePNGRepresentation(self.image);
                if (self.image && self.isHidden == NO) {
                    NSData *data = UIImageJPEGRepresentation(self.image, 1.0);
                    [formData appendPartWithFileData:data name:@"img" fileName:@"img.jpg" mimeType:@"image/jpeg"];
                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                /*
                 <?xml version="1.0" encoding="UTF-8"?>
                 <oschina><result><errorCode>1</errorCode><errorMessage>动弹发表成功</errorMessage></result><notice><atmeCount>0</atmeCount><msgCount>0</msgCount><reviewCount>0</reviewCount><newFansCount>0</newFansCount><newLikeCount>0</newLikeCount></notice></oschina>

                 */
                if (responseObject) {
                    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
                    NSInteger flag = [[[[[doc rootElement] childAtIndex:0] childAtIndex:0] stringValue] integerValue];
                    if (flag == 1) {
                        [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"动弹发表成功"];
                    }else{
                        [LYHelper alphaFadeAnimationOnView:self.view WithTitle:@"网络异常，发送失败"];
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"KTweetPubUrl failed : %@",error);
            }];
        }else{// 弹出警告框
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送内容不能为空!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }else{
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
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
