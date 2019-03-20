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
@protocol OliveappAsyncPrestartValidatorDelegate <NSObject>

@required
/**
 *  预检成功回调
 *
 *  @param detectedFrame 捕获到的图片
 *  @param faceInfo 捕获到的人脸信息
 */
- (void) onPrestartSuccess: (OliveappDetectedFrame*) detectedFrame
              withFaceInfo: (OliveappFaceInfo *) faceInfo;

/**
 *  预检失败回调
 */
- (void) onPrestartFail;

/**
 *  单帧回调
 *
 *  @param remainingTimeoutMilliSecond 剩余时间
 */
- (void) onFrameDetected: (int) remainingTimeoutMilliSecond
            withFaceInfo: (OliveappFaceInfo *) faceInfo
withErrorCodeOfInActionArray: (NSArray *) errorCodeOfInAction;


@end
