//
//  OliveappHintView.m
//  AppSampleYitu
//
//  Created by kychen on 17/1/16.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappHintView.h"

@implementation OliveappHintView

- (CABasicAnimation *)animationWithScale:(CGFloat)scale
              withDuration:(CGFloat)duration
                 withDelay:(CGFloat)delay
          withTimeFunction:(CAMediaTimingFunction *)fn
              withDelegate: (id) delegate {
    CATransform3D transform1 = self.layer.transform;
    CATransform3D transform2 = CATransform3DMakeScale(scale, scale, 1);
    self.layer.transform = transform2;
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.fromValue = [NSValue valueWithCATransform3D:transform1];
    animation.keyPath = @"transform";
    animation.toValue = [NSValue valueWithCATransform3D:transform2];
    animation.duration = duration;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.timingFunction = fn;
    animation.delegate = delegate;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:@"hintView"];
    
    return animation;
}


@end
