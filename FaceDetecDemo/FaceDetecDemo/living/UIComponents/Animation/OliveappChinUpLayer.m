//
//  OliveappChinUpLayer.m
//  AppSampleYitu
//
//  Created by Xiaoyang Lin on 17/2/8.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappChinUpLayer.h"

@implementation OliveappChinUpLayer

- (void)animationWithDuration: (CGFloat) duration {
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.repeatCount = INFINITY;
    [self addAnimation:animation forKey:nil];
}
@end
