//
//  OliveappVerificationDelegate.h
//  OliveappLibrary
//
//  Created by rick on 17/1/3.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol OliveappVerificationFilterDelegate <NSObject>
typedef NS_ENUM(NSUInteger,VerificationState) {
    // 定义步骤
    STEP_READY = 0, // 准备步骤
    STEP_PRESTART = 1, // 预检步骤
    STEP_LIVENESS = 2, // 活检步骤
    STEP_FINISH = 3 // 结束步骤
};

- (BOOL) setConfigWithPrestartValidator: (OliveappPrestartValidator *) prestartValidator
                   WithLivenessDetector: (OliveappLivenessDetector *) livenessDetector
                       withViewDelegate: (id<OliveappViewUpdateEventDelegate>) viewDelegate
                              withError: (NSError **) error;

- (BOOL) setConfig: (OliveappSessionManagerConfig *) config
      withDelegate: (id<OliveappViewUpdateEventDelegate>)delegate
         withError: (NSError **) error;

- (void) nextVerificationStep;

- (NSUInteger) getCurrentStep;

- (void) enterLivenessDetection;

- (void) setFaceLocation:(float) xPercent
            withYpercent:(float) yPercent
        withWidthPercent:(float) widthPercent
       withHeightPercent:(float) heightPercent;

- (void) onPreviewFrame:(OliveappPhotoImage *)image;

- (BOOL) unInit;

@end
