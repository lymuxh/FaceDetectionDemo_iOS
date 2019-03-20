//
//  OliveappYellowFrame.m
//  AppSampleYitu
//
//  Created by kychen on 17/1/16.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappYellowFrame.h"

@implementation OliveappYellowFrame

- (void)flashAnimationWithTranslate:(CGFloat)XBias
                  withDuration:(CGFloat)duration {
    CATransform3D transform1 = self.layer.transform;
    CATransform3D transform2 = CATransform3DTranslate(transform1, XBias, 0, 0);
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


- (void) animationWithTranslate:(CGFloat)XBias
                        withDuration:(CGFloat)duration
                           withDelay:(CGFloat)delay {
    CATransform3D transform1 = self.layer.transform;
    CATransform3D transform2 = CATransform3DTranslate(transform1, XBias, 0, 0);
    self.layer.transform = transform2;
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.fromValue = [NSValue valueWithCATransform3D:transform1];
    animation.keyPath = @"transform";
    animation.toValue = [NSValue valueWithCATransform3D:transform2];
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.duration = duration;
    animation.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.0f :0.0f :0.2f :1.0f];
    [self.layer addAnimation:animation forKey:nil];
}

@end
