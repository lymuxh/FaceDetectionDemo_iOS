//
//  LivenessResultDelegate.h
//  LivenessDetector
//
//  Created by Jiteng Hao on 16/1/17.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "OliveappDetectedFrame.h"

@protocol OliveappLivenessResultDelegate <NSObject>

@required

/**
 *  活体检测成功的回调
 *
 *  @param detectedFrame 活体检测抓取的图片
 */
- (void) onLivenessSuccess: (OliveappDetectedFrame*) detectedFrame;

/**
 *  活体检测失败的回调
 *
 *  @param sessionState  session状态，用于区别超时还是动作不过关
 *  @param detectedFrame 活体检测抓取的图片
 */
- (void) onLivenessFail: (int)sessionState withDetectedFrame: (OliveappDetectedFrame*) detectedFrame;

/**
 *  取消活体检测的回调
 */
- (void) onLivenessCancel;

@end