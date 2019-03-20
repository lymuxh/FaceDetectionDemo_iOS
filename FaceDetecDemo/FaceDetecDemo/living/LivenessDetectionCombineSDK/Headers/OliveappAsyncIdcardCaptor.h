//
//  OliveappAsyncOcrManager.h
//  IdcardOcrSDK
//
//  Created by Xiaoyang Lin on 16/5/13.
//  Copyright © 2016年 com.yitutech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OliveappPhotoImage.h"
#import "OliveappAsyncIdcardCaptorDelegate.h"
#import "OliveappImageForVerifyConf.h"
#import "OliveappStructOcrFrameResult.h"
@interface OliveappAsyncIdcardCaptor : NSObject


/**
 *  初始化对象
 *
 *  @return <#return value description#>
 */
- (instancetype) initWithCardType:(OliveappCardType)cardType;

/**
 *  处理一帧图片
 *
 *  @param photoContent 图片信息
 *  @param isoSpeed     iso速度（快门时间），暂时无用
 *  @param error        错误信息
 *
 *  @return 是否成功
 */
- (BOOL) doDetection: (OliveappPhotoImage *) photoContent
        withIsoSpeed: (int) isoSpeed
           withError: (NSError *__autoreleasing *)error;


/**
 *  设置参数
 *
 *  @param delegate  委托对象
 *  @param imgConfig 图片信息
 *  @param error     错误类
 *
 *  @return 是否成功
 */
- (BOOL) setDelegate: (id<OliveappAsyncIdcardCaptorDelegate>) delegate
        withCardType: (OliveappCardType) cardType
     withImageConfig: (OliveappImageForVerifyConf *) imgConfig
           withError: (NSError **) error;

/**
 *  是否存图，不要使用！
 *
 *  @param isDebug <#isDebug description#>
 */
- (void) enableDebug: (BOOL) isDebug;

/**
 *  停止算法模块
 *
 *  @return 是否成功
 */
- (BOOL) stopDetection;

@end
