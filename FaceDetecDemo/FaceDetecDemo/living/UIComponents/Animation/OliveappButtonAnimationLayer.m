//
//  OliveappButtonAnimationLayer.m
//  AppSampleYitu
//
//  Created by kychen on 17/1/16.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappButtonAnimationLayer.h"

@implementation OliveappButtonAnimationLayer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
        self.bounds = frame;
        self.cornerRadius = frame.size.width / 2;
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.borderWidth = frame.size.width / 2.2;
        CGColorRef yellowTransport = CGColorCreateCopyWithAlpha([UIColor yellowColor].CGColor, 0.0f);
        self.borderColor = yellowTransport;
        CGColorRelease(yellowTransport);
        
        [self setZPosition:100.0f];
    }
    return self;
}



- (void)animationAt:(CGPoint)position
 withTransformArray:(NSArray *)array
    withParentLayer:(CALayer *)buttonLayer{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.position = position;
    [CATransaction commit];
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1f];
    self.borderColor = [UIColor yellowColor].CGColor;
    [CATransaction commit];
    //
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.fromValue = @(self.borderWidth);
    animation.keyPath = @"borderWidth";
    animation.toValue = @(0.0f);
    animation.duration = 0.2f;
    self.borderWidth = 0.0f;
    __weak typeof(self) weakSelf = self;
    animation.delegate = weakSelf;
    [self addAnimation:animation forKey:nil];
    //
    if (buttonLayer != nil) {
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
        animation.beginTime = CACurrentMediaTime() + 0.2f;
        animation.keyPath = @"contents";
        animation.duration = 0.2f;
        animation.values = array;
        [buttonLayer addAnimation:animation forKey:nil];
    }
}

- (void)animationDidStop:(CABasicAnimation *)anim
                finished:(BOOL)flag {
    [CATransaction setDisableActions:YES];
    self.borderWidth = self.bounds.size.width / 2.2;
    CGColorRef yellowTransport = CGColorCreateCopyWithAlpha([UIColor yellowColor].CGColor, 0.0f);
    self.borderColor = yellowTransport;
    CGColorRelease(yellowTransport);
}

@end
