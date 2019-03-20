//
//  AsyncOcrManagerDelegate.h
//  IdcardOcrSDK
//
//  Created by Xiaoyang Lin on 16/5/13.
//  Copyright © 2016年 com.yitutech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OliveappAsyncIdcardCaptorDelegate <NSObject>

@required

/**
 *  捕获成功的回调，
 *
 *  @param imgData 返回质量最好的一张身份证
 */
- (void) onDetectionSucc: (NSData *) imgData;

/**
 *  身份证检测的回调
 *
 *  @param status 检测状态
 */
- (void) onDetectionStatus: (int) status;

@end
