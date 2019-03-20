//
//  CaptureRecentPhotoViewController.h
//  YituFaceVerifiactionSDK
//
//  Created by Jiteng Hao on 15/9/1.
//  Copyright (c) 2015年 YITU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OliveappOnDatabaseImageCapturedEventListener.h"
#import "OliveappFaceRect.h"

@interface OliveappCaptureDatabaseImageViewController : UIViewController

typedef NS_ENUM(int, DatabaseImageCaptureMode)
{
    DEFAULT = 0, // 默认模式
    IDCARD_FRONT = 1, // 身份证正面照片
    IDCARD_BACK = 2 // 身份证背面照片
};
@property DatabaseImageCaptureMode captureMode;

/**
 *  启动登记照片捕获
 *
 *  @param onCapturedListener 捕获成功后的回调
 *  @param accessInfo 客户信息
 *  @param mode 拍摄模式，参考DatabaseImageCaptureMode
 *
 *  @return 是否拍摄成功
 */
- (BOOL) startDatabaseImageCapture:(id<OliveappOnDatabaseImageCapturedEventListener>) onCapturedListener
                   withCaptureMode:(DatabaseImageCaptureMode) mode;

@end
