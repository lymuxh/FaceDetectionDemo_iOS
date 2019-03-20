//
//  OliveappLivenessDetectionViewController+Animation.h
//  AppSampleYitu
//
//  Created by Xiaoyang Lin on 17/2/8.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappLivenessDetectionViewController.h"

@interface OliveappLivenessDetectionViewController (Animation)


/**
 播放预检时的提示动画
 */
- (void) playAperture;



/**
 播放提示文字改变的动画

 @param hintText 要更新的提示文字
 */
- (void) playHintTextAnimation: (NSString *) hintText;


/**
 播放特定动作对应的动画

 @param actionType 特定动作
 @param 特定部位的坐标
 */
- (void) playActionAnimation: (int) actionType
                withLocation: (NSArray *) locationArray;
@end
