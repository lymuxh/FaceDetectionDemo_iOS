//
//  OliveappChinLayer.m
//  AppSampleYitu
//
//  Created by Xiaoyang Lin on 17/2/8.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappChinLayer.h"

@implementation OliveappChinLayer

- (void)animationWithScale: (CGFloat) scale
              withDuration: (CGFloat) duration {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform";
    animation.values = @[
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.f, 1.f, 1)]
                         ];
    animation.duration = duration;
    [self addAnimation:animation forKey:nil];
}
@end
