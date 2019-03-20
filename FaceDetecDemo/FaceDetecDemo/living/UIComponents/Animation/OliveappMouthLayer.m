//
//  OliveappMouthLayer.m
//  AppSampleYitu
//
//  Created by Xiaoyang Lin on 17/2/8.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappMouthLayer.h"

@implementation OliveappMouthLayer


- (void)animationFadeIn: (CGFloat) scale
           withDuration: (CGFloat) duration
              withDelay: (CGFloat) delay {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.opacity = 0;
    [CATransaction commit];
    
    CABasicAnimation * animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"opacity";
    animation1.fromValue = [NSNumber numberWithFloat:0.f];
    animation1.toValue = [NSNumber numberWithFloat:1.f];
    animation1.duration = duration;
    
    
    CABasicAnimation * animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"transform";
    animation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    animation2.duration = duration;
    
    
    
    [self addAnimation:animation1 forKey:nil];
    [self addAnimation:animation2 forKey:nil];

}

- (void)animationFadeOut: (CGFloat) scale
            withDuration: (CGFloat) duration
               withDelay: (CGFloat) delay {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.opacity = 0;
    [CATransaction commit];
    
    CABasicAnimation * animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"opacity";
    animation1.fromValue = [NSNumber numberWithFloat:1.f];
    animation1.toValue = [NSNumber numberWithFloat:0.f];
    animation1.duration = duration;
    animation1.beginTime = CACurrentMediaTime() + delay;
    
    CABasicAnimation * animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"transform";
    animation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    animation2.duration = duration;
    animation2.beginTime = CACurrentMediaTime() + delay;
    
    
    [self addAnimation:animation1 forKey:nil];
    [self addAnimation:animation2 forKey:nil];
}
@end
