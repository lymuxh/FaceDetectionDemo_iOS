//
//  OliveappEyeView.m
//  AppSampleYitu
//
//  Created by kychen on 17/1/13.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappEyeLayer.h"

@implementation OliveappEyeLayer


/**
 眼睛动画

 @param position <#position description#>
 @param delay <#delay description#>
 */
- (void)animationAt:(CGPoint)position
          withDelay:(CGFloat)delay{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.opacity = 0;
    self.position = position;
    [CATransaction commit];
    {
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform";
        animation.values = @[
                             [NSValue valueWithCATransform3D:CATransform3DIdentity],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.35, 0.35, 1)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1)]
                             ];
        animation.duration = 0.5f;
        animation.beginTime = CACurrentMediaTime() + delay;
        self.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        [self addAnimation:animation forKey:nil];
    }
    {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:1.0f];
        animation.duration = 0.5f;
        animation.beginTime = CACurrentMediaTime() + delay;
        self.opacity = 1.0f;
        [self addAnimation:animation forKey:nil];
    }
    {
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.beginTime = CACurrentMediaTime() + 0.65f;
        animation.keyPath = @"opacity";
        animation.fromValue = @(1.0f);
        animation.toValue = @(0.0f);
        animation.duration = 0.2f;
        animation.beginTime = CACurrentMediaTime() + delay;
        self.opacity = 0.0f;
        [self addAnimation:animation forKey:nil];
    }
}

@end
