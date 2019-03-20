//
//  OliveappIdcardCaptorResultDelegate.h
//  AppSampleYitu
//
//  Created by Xiaoyang Lin on 16/7/23.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OliveappIdcardCaptorResultDelegate<NSObject>

@required
/**
 *  捕获成功的回调，
 *
 *  @param imgData 返回质量最好的一张身份证
 */
- (void) onDetectionSucc: (NSData *) imgData;

/**
 *  取消身份证捕获
 */
- (void) onIdcardCaptorCancel;

@end
