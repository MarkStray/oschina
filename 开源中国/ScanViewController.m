//
//  ScanViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/11.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "ScanViewController.h"
#import "UserInforViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
// 捕捉会话 把输入输出练习在一起
@property (nonatomic, strong) AVCaptureSession *session;
// 捕捉视频输入设备 🈯️(前后)摄像头 默认后置
@property (nonatomic, strong) AVCaptureDeviceInput *input;
// 输出 指定一种类型后 捕捉到该类型 (比如二维码) 会自动调用代理
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
// 显示捕获的头像用的
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preLayer;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDismissNavigationItem;
    self.navigationItem.title = @"扫一扫";
    [self scanQRCode];
    [self checkAVAuthorizationStatus];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenSize.width-250)/2, (kScreenSize.height-250)/2, 250, 250)];
    imageView.image = [UIImage imageNamed: @"scan"];
    [self.view addSubview:imageView];
}
- (void)scanQRCode{
    //UIImagePickerController
    // 初始化一个设备 使用后置摄像头 AVMediaTypeVideo
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 创建指定类型的输出 指定代理为 self 当类型的元数据 被捕捉到后 自动调用代理
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    // 设置手机分辨率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // session 捏合
    // 必须把输出添加session后 才能设置output的元数据类型
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        // 指定元数据的类型 为二维码
        [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }
    // 显示数据的 layer
    self.preLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preLayer.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64);
    // 设置视频的填充模式
    self.preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.preLayer];
    // 开始捕获
    //[self.session startRunning];
    
}
- (void)checkAVAuthorizationStatus{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSString *tips = NSLocalizedString(@"AVAuthorization", @"您没有权限访问相机");
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized // 开始捕获
        [self.session startRunning];
    } else {
        NSLog(@"%@",tips);
    }
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
// 检测到 对应元数据上的 元数据后就会调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"metadataObjects_count:%ld",metadataObjects.count);
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *object = metadataObjects[0];
        UserInforViewController *user = [[UserInforViewController alloc] init];
        user.authorid = object.stringValue;
        NSLog(@"QR code = %@",object.stringValue);
        
        [self.navigationController pushViewController:user animated:YES];
        // 停止捕获
        [self.session stopRunning];
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
