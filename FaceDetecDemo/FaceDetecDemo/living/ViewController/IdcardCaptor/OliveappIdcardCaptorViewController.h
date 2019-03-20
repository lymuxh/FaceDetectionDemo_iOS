//
//  CameraViewController.h
//  DemoFanPai
//
//  Created by Xiaoyang Lin on 16/4/22.
//  Copyright © 2016年 com.yitutech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OliveappIdcardCaptorResultDelegate.h"
#import "OliveappStructOcrFrameResult.h"
@interface OliveappIdcardCaptorViewController : UIViewController


/**
 设置身份证自动捕获算法

 @param delegate    回调函数
 @param cardType    捕获卡片的类型，现有FRONT_IDCARD(身份证正面),BACK_IDCARD(身份证反面)两种
 @param captureMode 捕获模式,
                    ONLY_AUTO_MODE: 全自动捕获
                    ONLY_MANUAL_MODE: 全手动捕获
                    MIXED_MODE: 先自动捕获，超时后自动切换成手动捕获
 @param second      如果上面是MIXED_MODE,这里就是超时时间，否则无效
 */
- (void) setDelegate: (id<OliveappIdcardCaptorResultDelegate>) delegate
        withCardType: (OliveappCardType) cardType
     withCaptureMode: (OliveappCaptureMode) captureMode
  withDurationSecond: (int) second;
@end
