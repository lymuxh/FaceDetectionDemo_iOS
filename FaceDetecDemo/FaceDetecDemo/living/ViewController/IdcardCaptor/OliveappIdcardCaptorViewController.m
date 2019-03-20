//
//  CameraViewController.m
//  DemoFanPai
//
//  Created by Xiaoyang Lin on 16/4/22.
//  Copyright © 2016年 com.yitutech. All rights reserved.
//

#import "OliveappIdcardCaptorViewController.h"
#import "OliveappCameraPreviewController.h"
#import "OliveappImageForVerifyConf.h"
#import "OliveappStructOcrFrameResult.h"
#import "OliveappAsyncIdcardCaptorDelegate.h"
#import "OliveappIdcardVerificationController.h"
#import "OliveappImageUtility.h"
#import <AVFoundation/AVFoundation.h>
#import "OliveappDeviceHelper.h"
@interface OliveappIdcardCaptorViewController () <OliveappAsyncIdcardCaptorDelegate,OliveappCameraImageCaptureDelegate>
#if !TARGET_IPHONE_SIMULATOR

@property (strong, nonatomic) OliveappCameraPreviewController * mCameraController;
@property (strong, nonatomic) OliveappIdcardVerificationController * mIdcardVerificationController;
@property (strong, nonatomic) id<OliveappIdcardCaptorResultDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (weak, nonatomic) IBOutlet UIImageView *idCardLocation;
@property (strong, nonatomic) IBOutlet UIView *superFullView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *mImageCaptureButton;
@property (strong, nonatomic) OliveappImageForVerifyConf * mOliveappImageForVerifyConf;
@property (nonatomic, strong) UIImageView * mScanLineImg;
@property (strong, nonatomic) NSDictionary * statusDict;
@property (strong, nonatomic) NSArray * boundsArray;
@property int boundsIndex;
@property OliveappCardType mCardType;
@property OliveappCaptureMode mCaptureMode;
@property int mDurationSecond;
@property (strong, nonatomic) NSTimer * mTimer;
@end

@implementation OliveappIdcardCaptorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置摄像头方向
    [OliveappDeviceHelper setFixedOrientation:PORTRAIT];
    
     NSLog(@"[OliveappIdcardCaptorViewController] viewDidLoad");
    // 调用摄像头
    if (_mCameraController == nil) {
        _mCameraController = [[OliveappCameraPreviewController alloc] init];
    }
    
    //初始化图片配置
    _mOliveappImageForVerifyConf = [[OliveappImageForVerifyConf alloc] init];
    
    //提示文字旋转90度
    _resultLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    //提示文字字典
    NSString * path = [[NSBundle mainBundle] pathForResource:@"OliveappOcrStatus" ofType:@"plist"];
    _statusDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"[OliveappIdcardCaptorViewController] viewWillAppear");
    
    [self.mImageCaptureButton setHidden:YES];
    //使用后置摄像头
    [_mCameraController startCamera:AVCaptureDevicePositionBack withResolution:AVCaptureSessionPresetHigh];
    
    if (_mCaptureMode == ONLY_AUTO_MODE || _mCaptureMode == MIXED_MODE) {
        //初始化算法模块
        NSError * error;
        _mIdcardVerificationController = [[OliveappIdcardVerificationController alloc] init];
        __weak typeof(self)weakSelf = self;
        [_mIdcardVerificationController setDelegate:weakSelf
                                       withCardType:_mCardType
                                          withError:&error];
        
        // 设置委托方法
        __weak typeof (OliveappIdcardVerificationController *) weakIdcardVerificationController = _mIdcardVerificationController;
        [_mCameraController setCameraPreviewDelegate:weakIdcardVerificationController];
        
        [_mCameraController setCameraImageCaptureDelegate:weakSelf];
        [_mIdcardVerificationController setIdCardPreviewView:self.idCardLocation withFullView:self.fullView withSuperView:self.superFullView];
    } else {
        NSLog(@"仅手动拍摄");
        __weak typeof(self) weakSelf = self;
        [_mCameraController setCameraImageCaptureDelegate:weakSelf];
        [self.mImageCaptureButton setHidden:NO];
        [self.resultLabel setHidden:YES];
    }
}


    
- (void) viewDidAppear:(BOOL)animated {
    //如果是混合模式，则开始计时
    if (_mCaptureMode == MIXED_MODE) {
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:_mDurationSecond target:self selector:@selector(startManualMode) userInfo:nil repeats:NO];
    }
    if (_mCaptureMode == ONLY_AUTO_MODE || _mCaptureMode == MIXED_MODE) {
        [self startAnimation];
    }
}
/**
 *  在这里设置预览
 */
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    NSLog(@"[OliveappIdcardCaptorViewController] viewDidLayoutSubviews");
    
    // 设置界面预览，使用全屏
    [_mCameraController setupPreview: _fullView];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     NSLog(@"[OliveappIdcardCaptorViewController] viewWillDisappear");
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    NSLog(@"[OliveappIdcardCaptorViewController] viewDidDisappear");
    //关闭摄像头
    [_mCameraController stopCamera];
    // 析构算法模块
    [_mIdcardVerificationController unInit];
    _mIdcardVerificationController = nil;
    
    [self stopAnimation];
    //记得释放定时器
    [_mTimer invalidate];
    _mTimer = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onImageCapture:(OliveappPhotoImage *)image {
    
    // 预处理图片
    CGRect cropRect = [OliveappPhotoImage getCropWithWidth:image.imageWidth
                                               withHeight:image.imageHeight
                                         withApertureView:self.idCardLocation
                        withCameraPreviewSuperViewAdapter:self.fullView];
    
    //切割后
    CIImage * croppedCIImage = [OliveappImageUtility cropImage:image.ciImage withCropArea:cropRect];
    
    image.ciImage = croppedCIImage;
    image.imageWidth = cropRect.size.width;
    image.imageHeight = cropRect.size.height;
    UIImage * uiimage = [OliveappImageUtility makeUIImageFromCIImage:image.ciImage];
    NSData * imageContent = UIImageJPEGRepresentation(uiimage, 1.0);
    [_delegate onDetectionSucc:imageContent];
}
    
- (void) onDetectionSucc: (NSData *) imgData {
    // 一定要在UI线程
    assert([NSThread isMainThread] == 1);
    [_delegate onDetectionSucc:imgData];
}

- (void) onDetectionStatus: (int) status {
    // 一定要在UI线程
    assert([NSThread isMainThread] == 1);
    NSLog(@"[OliveappIdcardCaptorViewController] onDetectionStatus: %d",status);
    [self.resultLabel setText:[_statusDict objectForKey:[NSString stringWithFormat:@"ocr_status_%d",status]]];
}
- (IBAction)captureImage:(UIButton *)sender {
    [_mCameraController takePhoto];
}

- (IBAction)cancelButton:(UIButton *)sender {
    // 先停止算法模块，然后退出界面
    [_delegate onIdcardCaptorCancel];
}

- (void) setDelegate: (id<OliveappIdcardCaptorResultDelegate>) delegate
        withCardType: (OliveappCardType) cardType
     withCaptureMode: (OliveappCaptureMode) captureMode
  withDurationSecond: (int) second {
    _delegate = delegate;
    _mCardType = cardType;
    _mCaptureMode = captureMode;
    _mDurationSecond = second;
}

- (void) dealloc {
    NSLog(@"OliveappIdcardCaptorViewController dealloc");
    _delegate = nil;
}

- (void) startManualMode {
    //停止算法
    [_mIdcardVerificationController unInit];
    _mIdcardVerificationController = nil;
    //显示按钮
    [_mImageCaptureButton setHidden:NO];
    [_resultLabel setHidden:YES];
    [self stopAnimation];
}
    
    

- (void) startAnimation {
    //扫描线
    UIImage * scanLine = [UIImage imageNamed:@"oliveapp_scan_line.png"];
    self.mScanLineImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.idCardLocation.frame.origin.x,self.idCardLocation.frame.origin.y,scanLine.size.width,self.idCardLocation.frame.size.height)];
    self.mScanLineImg.image = scanLine;
    self.mScanLineImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.mScanLineImg];
    [self.mScanLineImg.layer addAnimation:[self animation] forKey:nil];
}

- (CABasicAnimation *)animation{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.idCardLocation.frame.origin.x,self.idCardLocation.frame.origin.y + self.idCardLocation.frame.size.height / 2)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.idCardLocation.frame.origin.x + self.idCardLocation.frame.size.width, self.idCardLocation.frame.origin.y + self.idCardLocation.frame.size.height / 2)];
    
    return animation;
}

- (void) stopAnimation {
    [self.mScanLineImg removeFromSuperview];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#endif
@end
