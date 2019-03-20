//
//  AsyncPrestartValidator.h
//  LivenessDetector
//
//  Created by Jiteng Hao on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "OliveappAsyncPrestartValidatorDelegate.h"
#import "OliveappAsyncLivenessDetectorDelegate.h"
#import "OliveappPhotoImage.h"
#import "OliveappSessionManagerConfig.h"

@interface OliveappPrestartValidator : NSObject<OliveappAsyncLivenessDetectorDelegate>


- (BOOL) setConfig: (OliveappSessionManagerConfig *) config
           withDelegate: (id<OliveappAsyncPrestartValidatorDelegate>) delegate
         withError:(NSError **) error;

- (BOOL) unInit: (NSError **) error;

- (BOOL) restartSession;

- (BOOL) doDetection: (OliveappPhotoImage *) photoContent
           withError:(NSError *__autoreleasing *)error;

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
@end
