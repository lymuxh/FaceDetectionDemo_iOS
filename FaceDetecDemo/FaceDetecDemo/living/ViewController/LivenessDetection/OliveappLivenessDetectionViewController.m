//
//  ViewController.m
//  AnimationTestApp
//
//  Created by kychen on 16/12/30.
//  Copyright © 2016年 keyu.chen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "OliveappCameraPreviewController.h"
#import "OliveappViewUpdateEventDelegate.h"
#import "OliveappLivenessDetectionViewController.h"
#import "OliveappVerificationControllerFactory.h"
#import "GifView.h"
#import "OliveappStructLivenessFrameResult.h"
#import "RMDisplayLabel.h"
#import "RMDownloadIndicator.h"
#import "OliveappLivenessDataType.h"
#import "OliveappViewUpdateEventDelegate.h"
#import "LRMacroDefinitionHeader.h"
#import "OliveappApplicationParameter.h"
#import "OliveappTimeUtility.h"
#import "OliveappFileManager.h"
#import "OliveappLivenessDetectionViewController.h"
#import "OliveappDeviceHelper.h"
#import "OliveappEyeLayer.h"
#import "OliveappYellowFrame.h"
#import "OliveappHintView.h"
//#import "ShareData.h"
#import "OliveappLivenessDetectionViewController+Animation.h"
#import <QuartzCore/QuartzCore.h>

@interface OliveappLivenessDetectionViewController () <AVAudioPlayerDelegate,OliveappViewUpdateEventDelegate>
//UI
@property (weak, nonatomic) IBOutlet UIView * mCameraPreview;
@property (weak, nonatomic) IBOutlet UILabel *mCountDownUILabel;
@property CGSize mScreenSize;

//设备类型和用户设置的屏幕方向
@property OliveappDeviceOrientation mDeviceOrientation;
//语音播放控制器
@property (strong, nonatomic) AVAudioPlayer * mAudioPlayer;
//结果回调
@property (weak) id<OliveappLivenessResultDelegate> mLivenessResultDelegate;
//摄像头对象
@property (strong) OliveappCameraPreviewController* mCameraController;
//流程控制器
@property VerificationControllerType mVerificationControllerType;
@property (strong) id mVerificationController;
//动作提示语
@property (strong) NSDictionary *mActionHintTextDict;
// 音频对应字典
@property (strong) NSDictionary *mAudioDict;
//定时循环播放声音
@property (strong, nonatomic) NSTimer * mPreTimer;
@property (strong, nonatomic) NSTimer * mAnimationTimer;
@property (strong, nonatomic) NSString * mCurrentVoiceFile;
@property int mCurrentActionType;
@property (strong, nonatomic) NSArray * mLocationArray;
//帧率显示，实际使用时可隐藏
@property (weak, nonatomic) IBOutlet UILabel *mFrameLabel;
//帧数，用于帧率计算
@property int mFrameNumber;
//用于统计帧率的计时器
@property long long mFrameTimer;
//是否处于预检状态
@property BOOL mIsInPrestart;
@end

//时间常量
const int REPEAT_SECOND = 2;
@implementation OliveappLivenessDetectionViewController



//=============================生命周期函数================================//
#pragma 生命周期相关函数
- (void)viewDidLoad {
    [super viewDidLoad];
    _mDeviceOrientation = [OliveappDeviceHelper getFixedOrientation];
    [self initNeededConfig];
    [self constructUI];
    
    /**
      * 选择verification种类
      * WITH_PRESTART: 带有预检模式(推荐)
      * WITHOUT_PRESTART：不带预检模式
      */
    _mVerificationControllerType = WITH_PRESTART;
    _mIsInPrestart = (_mVerificationControllerType == WITH_PRESTART) ? YES : NO;
    
  
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"[BEGIN] LivenessDetectionViewController.viewWillAppear");
    [super viewWillAppear:animated];
    
    /**
     * 这里设置屏幕分辨率
     * 16:9（一般用于iPhone）
     * 4:3 (一般用于iPad)
     */
    if ([OliveappDeviceHelper deviceIsPad]) {
        [_mCameraController startCamera:AVCaptureDevicePositionBack
                         withResolution:AVCaptureSessionPresetPhoto];
    } else {
        [_mCameraController startCamera:AVCaptureDevicePositionBack
                         withResolution:AVCaptureSessionPresetHigh];
    }
    
    if (_mVerificationControllerType == WITH_PRESTART) {
        [self playBackgroundSoundEffect:@"oliveapp_step_hint_prestart"];
    }
    NSLog(@"[END] LivenessDetectionViewController.viewWillAppear");
}

- (void)viewDidLayoutSubviews {
    NSLog(@"[BEGIN][LivenessDetectionViewController] viewDidLayoutSubviews");
    [super viewDidLayoutSubviews];
    [_mCameraController setupPreview: _mCameraPreview];
    NSLog(@"[END][LivenessDetectionViewController] viewDidLayoutSubviews");
}


- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"[BEGIN][LivenessDetectionViewController viewDidAppear]");
    
    /**
     * 循环播放提示动画
     */
    _mPreTimer = [NSTimer scheduledTimerWithTimeInterval:REPEAT_SECOND
                                                    target:self
                                                  selector:@selector(playPreHint)
                                                  userInfo:nil
                                                   repeats:YES];
    if (_mVerificationControllerType == WITH_PRESTART) {
        [self playAperture];
    }
    
    
    /**
     * 启动活体检测算法
     */
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError * error;
        [self startDetection:&error];
    });
    
    NSLog(@"[END][LivenessDetectionViewController viewDidAppear]");
}


- (void)viewWillDisappear:(BOOL)animated {
    [_mAudioPlayer stop];
    _mAudioPlayer = nil;
    [_mPreTimer invalidate];
    _mPreTimer = nil;
    [_mAnimationTimer invalidate];
    _mAnimationTimer = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"[BEGIN][LivenessDetectionViewController] viewDidDisappear");
    [super viewDidDisappear:animated];
    [_mCameraController stopCamera];
    [_mVerificationController unInit];
    _mVerificationController = nil;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    NSLog(@"[END][LivenessDetectionViewController] viewDidDisappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//=============================设置配置方法================================//
#pragma 设置配置方法
/**
 初始化各种变量
 */
- (void)initNeededConfig {
    if (_mCameraController == nil) {
        _mCameraController = [[OliveappCameraPreviewController alloc] init];
    }

    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource: @"ActionHintConstants"
                                                                                       ofType: @"plist"];
    _mActionHintTextDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    //读取音频plist
    NSString *audioConstantsPath = [[NSBundle bundleForClass:[self class]] pathForResource: @"AudioConstants"
                                                                                    ofType: @"plist"];
    _mAudioDict = [NSDictionary dictionaryWithContentsOfFile:audioConstantsPath];
    
    _mFrameNumber = 0;
}



#pragma mark -- 活体检测相关
//=============================活检相关方法================================//
- (BOOL) setConfigLivenessDetection: (id<OliveappLivenessResultDelegate>) delegate
                          withError: (NSError **) error {
    // 设置参数
    _mLivenessResultDelegate = delegate;
    return YES;
}



/**
 启动活体检测的方法

 @param error 错误码
 */
- (void) startDetection:(NSError **) error {
    
    /**
      * 初始化算法对象VerificationController
      */
    _mVerificationController = [OliveappVerificationControllerFactory create:_mVerificationControllerType];
    OliveappSessionManagerConfig* config = [OliveappSessionManagerConfig new];
    [config usePredefinedConfig: 0]; // 这里配置检测步骤
  
    //如果超时时间设置过长，则不显示倒计时
    if (config.timeoutMs > 100000) {
        [self.mCountDownUILabel setHidden:YES];
    }
    
    /**
     * 配置算法对象VerificationController
     */
    __weak typeof(self) weakSelf = self;
    [_mVerificationController setConfig:config
                           withDelegate:weakSelf
                              withError:error];
    
    /** 
      * 这里设置了检测人脸框的坐标和宽高，需要根据具体UI配置，详细请参考定制文档
      */
    [_mVerificationController setFaceLocation:((_mBlueFrame.center.x - _mBlueFrame.bounds.size.width / 2)/ [UIScreen mainScreen].bounds.size.width)
                                 withYpercent:((_mBlueFrame.center.y - _mBlueFrame.bounds.size.height / 2) / [UIScreen mainScreen].bounds.size.height)
                             withWidthPercent:(_mBlueFrame.bounds.size.width / [UIScreen mainScreen].bounds.size.width)
                            withHeightPercent:(_mBlueFrame.bounds.size.height / [UIScreen mainScreen].bounds.size.height)];
    //设置摄像头回调
    [_mCameraController setCameraPreviewDelegate: _mVerificationController];
    
    //启动活体检测
    if ([_mVerificationController getCurrentStep] == STEP_READY) {
        NSLog(@"启动检测");
        [_mVerificationController nextVerificationStep];
    }
}


//=============================回调方法（全部都在UI线程回调）================================//
#pragma 算法的回调
/**
 *  预检成功回调
 *
 *  @param detectedFrame 捕获到的图片
 *  @param faceInfo 捕获到的人脸信息
 */
- (void) onPrestartSuccess: (OliveappDetectedFrame*) detectedFrame
              withFaceInfo: (OliveappFaceInfo *)faceInfo{
    
    NSLog(@"[BEGIN][OliveappLivenessDetectionViewController]预检成功");
    assert([NSThread isMainThread] == 1);
    //停止动画
    [_mPreTimer invalidate];
    _mPreTimer = nil;
    
    //使用以下方法进入活体检测步骤
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       _mIsInPrestart = NO;
       [_mVerificationController enterLivenessDetection];
    });
    NSLog(@"[END][OliveappLivenessDetectionViewController]预检成功");
}

/**
 *  预检失败回调
 */
- (void) onPrestartFail {
    assert([NSThread isMainThread] == 1);
    // 处理预检失败事件(一般为超时)
    NSAssert(false, @"预检失败，现在的实现不应该运行到这里");
}

/**
 *  单帧回调
 *
 *  @param remainingTimeoutMilliSecond 剩余时间
 */
- (void) onFrameDetected: (int) remainingTimeoutMilliSecond
            withFaceInfo:faceInfo
withErrorCodeOfInActionArray:(NSArray *)errorCodeOfInAction{
    assert([NSThread isMainThread] == 1);
    
    //计算帧率的代码
//    {
//        ++_mFrameNumber;
//        long long delta = [OliveappTimeUtility getTimeStampInMilliSec] - _mFrameTimer;
//        if (delta > 1000) {
//            [_mFrameLabel setText:[NSString stringWithFormat:@"帧率:%lld",_mFrameNumber * 1000 / delta]];
//            _mFrameNumber = 0;
//            _mFrameTimer = [OliveappTimeUtility getTimeStampInMilliSec];
//        }
//    }
}

/**
 *  活体检测成功的回调
 *
 *  @param detectedFrame 活体检测抓取的图片
 *  @param faceInfo 捕获到的人脸信息
 */
- (void) onLivenessSuccess: (OliveappDetectedFrame*) detectedFrame
              withFaceInfo:(OliveappFaceInfo *)faceInfo{
    
    NSLog(@"[BEGIN] LivenessDetectionViewController::onLivenessSuccess");
    assert([NSThread isMainThread] == 1);
    assert(detectedFrame.frameData == nil);
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [_mLivenessResultDelegate onLivenessSuccess:detectedFrame];
    NSLog(@"[END] LivenessDetectionViewController::onLivenessSuccess");
}

/**
 *  活体检测失败的回调
 *
 *  @param sessionState  session状态，用于区别超时还是动作不过关
 *  @param detectedFrame 活体检测抓取的图片
 */
- (void) onLivenessFail: (int) sessionState
      withDetectedFrame: (OliveappDetectedFrame *) detectedFrame{
    
    NSLog(@"[BEGIN] LivenessDetectionViewController::onLivenessFail");
    assert([NSThread isMainThread] == 1);
    // 回调给用户
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [_mLivenessResultDelegate onLivenessFail:sessionState withDetectedFrame:detectedFrame];
    NSLog(@"[END] LivenessDetectionViewController::onLivenessFail");
}

/**
 * 活体检测取消回调
 */
- (IBAction)touchCancelLiveness:(UIButton *)sender {
    [_mLivenessResultDelegate onLivenessCancel];
}


/**
 每一帧结果的回调方法

 @param currentActionType 当前是什么动作
 @param actionState 当前动作的检测结果
 @param sessionState  整个Session是否通过
 @param faceInfo 检测到的人脸信息，可以用来做动画
 @param remainingTimeoutMilliSecond 剩余时间，以毫秒为单位
 @param errorCodeOfInAction 动作不过关的可能原因，可以用来做提示语
 */
- (void) onFrameDetected: (int)currentActionType
         withActionState: (int)actionState
        withSessionState: (int)sessionState
            withFaceInfo:(OliveappFaceInfo *)faceInfo
withRemainingTimeoutMilliSecond: (int)remainingTimeoutMilliSecond
withErrorCodeOfInActionArray:(NSArray *)errorCodeOfInAction {
    
    NSLog(@"[BEGIN] LivenessDetectionViewController::onFrameDetected");
    assert([NSThread isMainThread] == 1);
    self.mCountDownUILabel.text = [NSString stringWithFormat:@"%d", remainingTimeoutMilliSecond / 1000 + 1];
    _mLocationArray = [self getLocation:_mCurrentActionType
                           withFaceInfo:faceInfo];
    //计算帧率的代码
//    {
//        ++_mFrameNumber;
//        long long delta = [OliveappTimeUtility getTimeStampInMilliSec] - _mFrameTimer;
//        if (delta > 1000) {
//            [_mFrameLabel setText:[NSString stringWithFormat:@"帧率:%lld",_mFrameNumber * 1000 / delta]];
//            _mFrameNumber = 0;
//            _mFrameTimer = [OliveappTimeUtility getTimeStampInMilliSec];
//        }
//    }
    NSLog(@"[END] LivenessDetectionViewController::onFrameDetected");
}



/**
 切换到下一个动作时的回调方法

 @param lastActionType 上一个动作类型
 @param lastActionResult 上一个动作的检测结果
 @param newActionType 当前新生成的动作类型
 @param currentActionIndex 当前是第几个动作
 @param faceInfo 人脸的信息
 */
- (void) onActionChanged: (int)lastActionType
    withLastActionResult: (int)lastActionResult
       withNewActionType: (int)newActionType
  withCurrentActionIndex: (int)currentActionIndex
            withFaceInfo:(OliveappFaceInfo *)faceInfo {

    NSString * text = [_mActionHintTextDict objectForKey: [NSString stringWithFormat:@"hinttext_action_%d", newActionType]];
    [self playHintTextAnimation:text];
    _mCurrentVoiceFile = [_mAudioDict objectForKey: [NSString stringWithFormat:@"audio_action_%d", newActionType]];
    [self playBackgroundSoundEffect:_mCurrentVoiceFile];
    
    _mCurrentActionType = newActionType;
    
    _mLocationArray = [self getLocation:_mCurrentActionType
                           withFaceInfo:faceInfo];
    
    [self playActionAnimation:_mCurrentActionType
                 withLocation:_mLocationArray];
    [_mAnimationTimer invalidate];
    _mAnimationTimer = nil;
    _mAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:REPEAT_SECOND
                                               target:self
                                             selector:@selector(playActionAnimation)
                                             userInfo:nil
                                              repeats:YES];
}



//=============================UI/动画相关================================//
#pragma UI相关函数
/**
 * 对不同屏幕进行动画适配
 */
- (void)constructUI {
    if ([OliveappDeviceHelper deviceIsPad]) {
        if (_mDeviceOrientation == PORTRAIT) {
            _mScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.height * 9 / 16, [UIScreen mainScreen].bounds.size.height);
        } else {
            _mScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.height * 16 / 9, [UIScreen mainScreen].bounds.size.height);
        }
    } else {
        _mScreenSize = [UIScreen mainScreen].bounds.size;
    }
}

/**
 播放预检动画和音频
 */
- (void) playPreHint {
    if (_mVerificationControllerType == WITH_PRESTART && _mIsInPrestart) {
        [self playBackgroundSoundEffect:@"oliveapp_step_hint_prestart"];
        [self playAperture];
    }
}

/**
 播放活检动画和音频
 */
- (void) playActionAnimation {
    NSLog(@"重复动画");
    [self playActionAnimation:_mCurrentActionType withLocation:_mLocationArray];
    [self playBackgroundSoundEffect:_mCurrentVoiceFile];
}

/**
 *  播放音频
 *
 *  @param resource 音频名字
 */
- (void) playBackgroundSoundEffect: (NSString*) resource {
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: resource ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    @synchronized (_mAudioPlayer) {
        if ([_mAudioPlayer isPlaying]) {
            [_mAudioPlayer stop];
        }
        _mAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error:nil];
        [_mAudioPlayer play];
    }
}


/**
 拿到当前动作对应的脸部坐标，用于做动画

 @param actionType 动作类型
 @param faceInfo 对应的人脸信息
 @return 脸部坐标数组
 */
- (NSArray *) getLocation: (int) actionType
             withFaceInfo: (OliveappFaceInfo *) faceInfo {
    
    NSArray * resultArray;
    switch (actionType) {
        case EYE_CLOSE_ACTION: {
            //左右眼坐标
            CGPoint leftPoint = CGPointMake((1.f - faceInfo.leftEye.x) * [UIScreen mainScreen].bounds.size.width, faceInfo.leftEye.y * _mScreenSize.height);
            CGPoint rightPoint = CGPointMake((1.f - faceInfo.rightEye.x) * [UIScreen mainScreen].bounds.size.width, faceInfo.rightEye.y * _mScreenSize.height);
            resultArray = @[[NSValue valueWithCGPoint:leftPoint],
                            [NSValue valueWithCGPoint:rightPoint]];
            break;
        }
        case MOUTH_OPEN_ACTION: {
            CGPoint mouthPoint = CGPointMake((1.f - faceInfo.mouth.x) * [UIScreen mainScreen].bounds.size.width, faceInfo.mouth.y * _mScreenSize.height);
            resultArray = @[[NSValue valueWithCGPoint:mouthPoint]];
            break;
        }
        case HEAD_UP_ACTION: {
            CGPoint chinPoint = CGPointMake((1.f - faceInfo.chin.x) * [UIScreen mainScreen].bounds.size.width, faceInfo.chin.y * _mScreenSize.height);
            resultArray = @[[NSValue valueWithCGPoint:chinPoint]];
            break;
        }
        default:
            break;
    }
    
    return resultArray;
}
//=============================设备辅助函数================================//
#pragma 设备辅助函数
- (BOOL) shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    switch (_mDeviceOrientation) {
        case LANDSCAPE_RIGHT:
            return UIInterfaceOrientationMaskLandscapeRight;
            break;
        case LANDSCAPE_LEFT:
            return UIInterfaceOrientationMaskLandscapeLeft;
        default:
            return UIInterfaceOrientationMaskPortrait;
            break;
    }
}


//================废弃的回调接口==========================//
#pragma 废弃的回调函数
- (void) onInitializeSucc {
    assert([NSThread isMainThread] == 1);
    NSLog(@"活体检测初始化成功");
    
}

- (void) onInitializeFail:(NSError*) error {
    assert([NSThread isMainThread] == 1);
    NSLog(@"活体检测初始化失败，错误信息: %@", [error localizedDescription]);
}
@end
