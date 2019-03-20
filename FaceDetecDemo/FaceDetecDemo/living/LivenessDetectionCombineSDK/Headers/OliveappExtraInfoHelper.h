//
//  OliveappExtraInfoHelper.h
//  OliveappLibrary
//
//  Created by Xiaoyang Lin on 16/12/3.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OliveappExtraInfoHelper : NSObject


/**
 获取SDK版本号

 @return 获取SDK版本号
 */
+ (NSString *) getSdkVersionCode;

/**
 获取SDK名

 @return 获取SDK名
 */
+ (NSString *) getSdkName;


/**
 获取SDK识别号

 @return 获取SDK识别号
 */
+ (NSString *) getSdkIdentifier;


+ (NSNumber *) getUsingTime;


/**
 设置开始时间

 @param startTime 开始时间
 */
+ (void) setStartTime: (long long) startTime;


/**
 设置结束时间

 @param stopTime 结束时间
 */
+ (void) setStopTime: (long long) stopTime;
/**
 获取App相关信息

 @return 获取App相关信息
 */
+ (NSDictionary *) getAppInfo;
@end
