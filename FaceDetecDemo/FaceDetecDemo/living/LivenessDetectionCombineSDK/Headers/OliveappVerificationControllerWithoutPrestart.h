//
//  OliveappVerificationControllerWithoutPrestart.h
//  OliveappLibrary
//
//  Created by rick on 17/1/3.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "OliveappAsyncLivenessDetectorDelegate.h"
#import "OliveappAsyncPrestartValidatorDelegate.h"
#import "OliveappCameraPreviewDelegate.h"
#import "OliveappPrestartValidator.h"
#import "OliveappLivenessDetector.h"
#import "OliveappViewUpdateEventDelegate.h"
#import "OliveappVerificationDelegate.h"

@interface OliveappVerificationControllerWithoutPrestart : NSObject <OliveappAsyncLivenessDetectorDelegate, OliveappCameraPreviewDelegate, OliveappVerificationFilterDelegate>



/**
 * 构造函数(依赖注入方式，主要用于测试). 注意: 所有参数不能为null
 * @param ViewUpdateEventDelegate 更新UI的事件响应回调
 * @param prestartValidator 预检模块实现
 * @param livenessDetector 活体检测模块实现
 */
- (BOOL) setConfigWithPrestartValidator: (OliveappPrestartValidator *) prestartValidator
                   WithLivenessDetector: (OliveappLivenessDetector *) livenessDetector
                       withViewDelegate: (id<OliveappViewUpdateEventDelegate>) viewDelegate
                              withError: (NSError **) error;


/**
 * 异步构造函数，内部会启动后台线程进行初始化, 初始化结束后会调用onInitializeSucc或onInitializeFail
 * 注意: 所有参数不能为null
 * @param ViewUpdateEventDelegate 更新UI的事件响应回调
 * @param SessionManagerConfig SessionManager的配置
 * @param mode 1表示动作间无间隔切换，2表示动作间可延迟切换
 */
- (BOOL) setConfig: (OliveappSessionManagerConfig *) config
      withDelegate: (id<OliveappViewUpdateEventDelegate>)delegate
         withError: (NSError **) error;

/**
 * 进入状态机的下一个步骤。其中READY和FINISH步骤是不做任何事情的
 * READY -> PRESTART -> LIVENESS -> FINISH
 * 准备  -> 预检      -> 活检     -> 结束
 */
- (void) nextVerificationStep;

- (NSUInteger) getCurrentStep;

/*
 * 进入活检流程
 */
- (void) enterLivenessDetection;


/**
 根据UI交互调整人脸框的位置，采用百分比，请务必设置正确
 
 @param xPercent      需要检测人脸左上角坐标x占全宽的百分比
 @param yPercent      需要检测人脸左上角坐标y占全宽的百分比
 @param widthPercent  需要检测人脸宽度占全宽的百分比
 @param heightPercent 需要检测人脸高度占全宽的百分比
 */
- (void) setFaceLocation:(float) xPercent
            withYpercent:(float) yPercent
        withWidthPercent:(float) widthPercent
       withHeightPercent:(float) heightPercent;

// 仅供测试，请不要直接调用
- (void) onPreviewFrame:(OliveappPhotoImage *)image;


- (BOOL) unInit;


@end
