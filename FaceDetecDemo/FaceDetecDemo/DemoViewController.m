//
//  DemoViewController.m
//  FaceDetecDemo
//
//  Created by xiaohui mu on 2019/2/27.
//  Copyright © 2019 xiaohui mu. All rights reserved.
//

#import "DemoViewController.h"
#import "faceView.h"
#import "UIView+ITTAdditions.h"

#import "OliveappLivenessDetectionViewController.h"
#import "OliveappCameraPreviewController.h"
#import "OliveappDetectedFrame.h"
#import <AVFoundation/AVFoundation.h>
#import "OliveappIdcardCaptorViewController.h"

// UIScreen height.
#define LL_ScreenHeight [UIScreen mainScreen].bounds.size.height

// UIScreen width.
#define LL_ScreenWidth [UIScreen mainScreen].bounds.size.width

// iPhone X
#define  LL_iPhoneX (LL_ScreenWidth == 375.f && LL_ScreenHeight == 812.f ? YES : NO)

// Status bar height.
#define  LL_StatusBarHeight      (LL_iPhoneX ? 44.f : 20.f)

// Navigation bar height.
#define  LL_NavigationBarHeight  44.f

// Tabbar height.
#define  LL_TabbarHeight         (LL_iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  LL_TabbarSafeBottomMargin         (LL_iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  LL_StatusBarAndNavigationBarHeight  (LL_iPhoneX ? 88.f : 64.f)

#define LL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

@interface DemoViewController ()<OliveappLivenessResultDelegate,OliveappIdcardCaptorResultDelegate>
/**
 人脸识别
 */
@property(nonatomic,strong) UIButton *faceButton;
/**
 活体检测
 */
@property(nonatomic,strong) UIButton *detectButton;
/**
 身份证拍照
 */
@property(nonatomic,strong) UIButton *idCardButton;
/**
 图片显示
 */
@property(nonatomic,strong) UIImageView *resultImageView;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getCameraPermission:^(NSArray * _Nonnull response) {
        NSLog(@"getCameraPermission:%@",[response description]);
    }];
    
    _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(10, LL_StatusBarAndNavigationBarHeight+10, 80, 50)];
    _faceButton.backgroundColor = [UIColor lightGrayColor];
    [_faceButton setTitle:@"人脸识别" forState:UIControlStateNormal];
    [_faceButton addTarget:self action:@selector(faceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_faceButton];
    
    _detectButton = [[UIButton alloc] initWithFrame:CGRectMake(10, LL_StatusBarAndNavigationBarHeight+10+70, 80, 50)];
    _detectButton.backgroundColor = [UIColor lightGrayColor];
    [_detectButton setTitle:@"活体检测" forState:UIControlStateNormal];
    [_detectButton addTarget:self action:@selector(checkBodyInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_detectButton];
    
    _resultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, LL_StatusBarAndNavigationBarHeight+10, 200, 150)];
    _resultImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_resultImageView];
    
    _idCardButton = [[UIButton alloc] initWithFrame:CGRectMake(10, LL_StatusBarAndNavigationBarHeight+10+70+10+70, 80, 50)];
    _idCardButton.backgroundColor = [UIColor lightGrayColor];
    [_idCardButton setTitle:@"证件拍照" forState:UIControlStateNormal];
    [_idCardButton addTarget:self action:@selector(idCardButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_idCardButton];
}

-(void)faceButtonClick{
    [self beiginRecognition:200];
}

#pragma mark PeopleRecognition
-(void)beiginRecognition:(float)value{
    faceView* fv=[[faceView alloc]initWithFrame:CGRectMake(0,0,LL_ScreenWidth,LL_ScreenHeight)];
    fv.tag=102;
    [fv setCallBackImagePath:^(NSString *url) {
        NSLog(@"url:%@",url);
        self->_resultImageView.image = [UIImage imageWithContentsOfFile:url];
        [self removeFaceView:YES];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:fv];
}

-(void)removeFaceView:(BOOL) s{
    [UIView animateWithDuration:0.2 animations:^{
        [[UIApplication sharedApplication].keyWindow viewWithTag:102].alpha=0.0;
    }completion:^(BOOL finished) {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:102] removeAllSubviews];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:102] removeFromSuperview];
    }];
}

-(void)getCameraPermission:(ResponseSenderBlock)callback{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        granted ? callback(@[@"1"]) : callback(@[@"0"]);
    }];
};


// 活体检测
- (void)checkBodyInfo{
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"LivenessDetection" bundle:nil];
    OliveappLivenessDetectionViewController * livenessDetectionViewController;
    livenessDetectionViewController = (OliveappLivenessDetectionViewController *)[ board instantiateViewControllerWithIdentifier:@"LivenessDetectionStoryboard"];
    NSError *error;
    BOOL isSuccess = [livenessDetectionViewController setConfigLivenessDetection:self withError: &error];
    if (isSuccess){
        [self.navigationController pushViewController:livenessDetectionViewController animated:YES];
    }
}

- (void)onLivenessSuccess:(OliveappDetectedFrame *)detectedFrame{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)onLivenessFail:(int)sessionState withDetectedFrame:(OliveappDetectedFrame *)detectedFrame{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"活体检测失败,是否重新进行活体检测" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkBodyInfo];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [actionsheet addAction:action1];
        [actionsheet addAction:action2];
        
        [self presentViewController:actionsheet animated:YES completion:nil];
    });
}

- (void)onLivenessCancel{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (void)idCardButtonClick{
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"IdcardCaptor" bundle:nil];
    OliveappIdcardCaptorViewController * idCardCaptor;
    idCardCaptor = (OliveappIdcardCaptorViewController *)[ board instantiateViewControllerWithIdentifier:@"idcardCaptorStoryboard"];
    [idCardCaptor setDelegate:self withCardType:FRONT_IDCARD withCaptureMode:MIXED_MODE withDurationSecond:1];
    [self.navigationController pushViewController:idCardCaptor animated:YES];
}

#pragma mark OliveappIdcardCaptorResultDelegate
/**
 *  捕获成功的回调，
 *
 *  @param imgData 返回质量最好的一张身份证
 */
- (void)onDetectionSucc: (NSData *) imgData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_resultImageView.image = [UIImage imageWithData:imgData];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

/**
 *  取消身份证捕获
 */
- (void) onIdcardCaptorCancel{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
