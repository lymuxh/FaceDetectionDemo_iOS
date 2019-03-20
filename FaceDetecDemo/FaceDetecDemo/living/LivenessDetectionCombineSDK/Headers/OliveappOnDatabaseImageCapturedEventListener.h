//
//  OnDatabaseImageCapturedEventListener.h
//  YituFaceVerifiactionSDK
//
//  Created by Jiteng Hao on 15/9/1.
//  Copyright (c) 2015年 YITU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "OliveappFaceRect.h"

@protocol OliveappOnDatabaseImageCapturedEventListener <NSObject>

@required
/**
 *  捕获到合格的登记照片时的回调函数
 *
 *  @param imageContent 图片内容。如需网络传输，请调用UIImageJPEGRepresentation(imageContent, 0.7)
 *  @param face 检测到的人脸信息。如果为nil表示未检测到或检测到多张人脸
 *  @param error 错误信息
 */
- (void) onDatabaseImageTaken: (UIImage*) imageContent
             withDetectedFace: (OliveappFaceRect*) face
                    withError: (NSError *) error;

/**
 *  用户点击取消按钮后的响应事件
 */
- (void) onCancelCapture;

@end
