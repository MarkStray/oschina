//
//  ScanViewController.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/11.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "Scan_dupViewController.h"
#import "UserInforViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface Scan_dupViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preLayer;

@end

@implementation Scan_dupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kDebugPrint();
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"扫一扫";
    [self scanQRCode];
    [self checkAVAuthorizationStatus];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenSize.width-250)/2, (kScreenSize.height-250)/2, 250, 250)];
    imageView.image = [UIImage imageNamed: @"scan"];
    [self.view addSubview:imageView];
}
- (void)scanQRCode{
    kDebugPrint();
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    // 设置手机 分辨率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
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
    
    self.preLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preLayer.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64);
    self.preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.preLayer];
    //[self.session startRunning];
    
}
- (void)checkAVAuthorizationStatus{
    kDebugPrint();
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSString *tips = NSLocalizedString(@"AVAuthorization", @"您没有权限访问相机");
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized // 开始捕获
        [self.session startRunning];
    } else {
        NSLog(@"%@",tips);
    }
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    kDebugPrint();
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        UserInforViewController *user = [[UserInforViewController alloc] init];
        user.authorid = object.stringValue;
        NSLog(@"QR code = %@",object.stringValue);
        
        [self.navigationController pushViewController:user animated:YES];
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
