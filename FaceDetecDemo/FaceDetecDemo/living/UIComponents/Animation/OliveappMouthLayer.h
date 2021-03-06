//
//  OliveappMouthLayer.h
//  AppSampleYitu
//
//  Created by Xiaoyang Lin on 17/2/8.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface OliveappMouthLayer : CALayer

- (void)animationFadeIn: (CGFloat) scale
            withDuration: (CGFloat) duration
               withDelay: (CGFloat) delay;

- (void)animationFadeOut: (CGFloat) scale
            withDuration: (CGFloat) duration
               withDelay: (CGFloat) delay;

@end
