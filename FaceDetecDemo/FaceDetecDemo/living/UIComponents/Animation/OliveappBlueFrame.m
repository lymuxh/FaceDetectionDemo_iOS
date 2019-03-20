//
//  OliveappBlueFrame.m
//  AppSampleYitu
//
//  Created by kychen on 17/1/13.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappBlueFrame.h"

@implementation OliveappBlueFrame

/**
 闪动动画

 @param scaleSize 放大比例
 @param duration 动画时间
 */
- (void)animationWithScale:(CGFloat)scaleSize
              withDuration:(CGFloat)duration {
    CATransform3D transform1 = self.layer.transform;
    CATransform3D transform2 = CATransform3DScale(transform1, scaleSize, scaleSize, 1);
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform";
    animation.values = @[
                         [NSValue valueWithCATransform3D:transform1],
                         [NSValue valueWithCATransform3D:transform2],
                         [NSValue valueWithCATransform3D:transform1]
                         ];
    animation.duration = duration;
    animation.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f :0.0f :0.2f :0.1f];
    [self.layer addAnimation:animation forKey:nil];
}

@end
