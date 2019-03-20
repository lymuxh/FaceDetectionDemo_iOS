//
//  AsyncLivenessDetectorDelegate.h
//  LivenessDetector
//
//  Created by Xiaoyang Lin on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OliveappDetectedFrame.h"
#import "OliveappFaceInfo.h"
@protocol OliveappAsyncLivenessDetectorDelegate <NSObject>

@required
/**
 *  活体检测成功的回调
 *
 *  @param detectedFrame 活体检测抓取的图片
 *  @param faceInfo 捕获到的人脸信息
 */
- (void) onLivenessSuccess: (OliveappDetectedFrame*) detectedFrame
              withFaceInfo:(OliveappFaceInfo*) faceInfo;

/**
 *  活体检测失败的回调
 *
 *  @param sessionState  session状态，用于区别超时还是动作不过关
 *  @param detectedFrame 活体检测抓取的图片
 */
- (void) onLivenessFail: (int) sessionState
      withDetectedFrame: (OliveappDetectedFrame*) detectedFrame;

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
            withFaceInfo: (OliveappFaceInfo*) faceInfo;

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
            withFaceInfo:(OliveappFaceInfo*) faceInfo
withRemainingTimeoutMilliSecond: (int)remainingTimeoutMilliSecond
withErrorCodeOfInActionArray: (NSArray *) errorCodeOfInAction;

@end
