//
//  OliveappIdcardVerificationController.h
//  LivenessDetector
//
//  Created by Xiaoyang Lin on 16/6/4.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OliveappAsyncIdcardCaptorDelegate.h"
#import <UIKit/UIKit.h>
#import "OliveappCameraPreviewDelegate.h"
#import "OliveappStructOcrFrameResult.h"
@interface OliveappIdcardVerificationController : NSObject<OliveappCameraPreviewDelegate>

/**
 *  初始化时设置委托方法
 *
 *  @param delegate 委托对象
 *  @param error    错误类
 */
- (void) setDelegate: (id<OliveappAsyncIdcardCaptorDelegate>) delegate
        withCardType: (OliveappCardType) cardType
           withError: (NSError **) error;


/**
 *  设置截图的参照物
 *
 *  @param idCardView 身份证的框
 *  @param fullView   全屏框
 *  @param superView  为了iPhone4特制的框
 */
- (void) setIdCardPreviewView:(UIImageView *) idCardView
                 withFullView:(UIView *) fullView
                withSuperView:(UIView *) superView;


/**
 *  析构
 */
- (void) unInit;


/**
 *  debug功能开的话会存图
 */
- (void) enableDebug: (BOOL) isDebug;
@end
