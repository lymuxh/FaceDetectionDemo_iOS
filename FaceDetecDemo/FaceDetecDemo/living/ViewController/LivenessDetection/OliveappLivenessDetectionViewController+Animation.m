//
//  OliveappLivenessDetectionViewController+Animation.m
//  AppSampleYitu
//
//  Created by Xiaoyang Lin on 17/2/8.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import "OliveappLivenessDetectionViewController+Animation.h"
#import "OliveappLivenessDetectionViewController.h"
#import "OliveappApplicationParameter.h"
#import "OliveappChinLayer.h"
#import "OliveappChinUpLayer.h"
#import "OliveappMouthLayer.h"
CABasicAnimation * mAnimation;
const float HINT_TEXT_DURATION = 0.15;
NSString * mHintText;
int mXBias = 0;

OliveappChinLayer * chinLayer;
OliveappChinUpLayer * chinUpLayer;
OliveappMouthLayer * mouthLayerIn;
OliveappMouthLayer * mouthLayerOut;
OliveappEyeLayer * leftEyeLayer;
OliveappEyeLayer * rightEyeLayer;

@implementation OliveappLivenessDetectionViewController (Animation)

- (void) playAperture {
    [self.mBlueFrame animationWithScale:1.2f
                       withDuration:HINT_TEXT_DURATION];
    [self.mLeftDownYellowFrame flashAnimationWithTranslate:-25.0f
                                          withDuration:HINT_TEXT_DURATION];
    [self.mRightUpYellowFrame flashAnimationWithTranslate:25.0f
                                         withDuration:HINT_TEXT_DURATION];
}


- (void) playHintTextAnimation: (NSString *) hintText {
    
    mHintText = hintText;
    __weak typeof(self) weakSelf = self;
    mAnimation = [self.mHintView animationWithScale:0.f
                          withDuration:HINT_TEXT_DURATION
                             withDelay:0
                      withTimeFunction:nil
                          withDelegate:weakSelf];
    
    mXBias = self.mRightUpYellowFrame.frame.origin.x - self.mHintView.center.x;
    [self.mLeftDownYellowFrame animationWithTranslate:mXBias
                                         withDuration:HINT_TEXT_DURATION
                                            withDelay:0.f];
    [self.mRightUpYellowFrame animationWithTranslate:-mXBias
                                         withDuration:HINT_TEXT_DURATION
                                            withDelay:0.f];
    
}



- (void) playActionAnimation: (int) actionType
                withLocation: (NSArray *) locationArray {
    
    [self.view.layer removeAllAnimations];
    [chinLayer removeFromSuperlayer];
    [chinUpLayer removeFromSuperlayer];
    [leftEyeLayer removeFromSuperlayer];
    [rightEyeLayer removeFromSuperlayer];
    [mouthLayerIn removeFromSuperlayer];
    [mouthLayerOut removeFromSuperlayer];
    switch (actionType) {
        case EYE_CLOSE_ACTION: {
            //闭眼的动画
            CGPoint leftPoint = [locationArray[0] CGPointValue];
            CGPoint rightPoint = [locationArray[1] CGPointValue];
            
            //左右眼layer
            leftEyeLayer = [OliveappEyeLayer layer];
            leftEyeLayer.contents = (__bridge id)([UIImage imageNamed:@"oliveapp_eye_blink.png"].CGImage);
            leftEyeLayer.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 4);
            
            rightEyeLayer = [OliveappEyeLayer layer];
            rightEyeLayer.contents = (__bridge id)([UIImage imageNamed:@"oliveapp_eye_blink.png"].CGImage);
            rightEyeLayer.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 4);
            
            [self.view.layer addSublayer:leftEyeLayer];
            [self.view.layer addSublayer:rightEyeLayer];
            
            [leftEyeLayer animationAt:leftPoint
                                  withDelay:0];
            [rightEyeLayer animationAt:rightPoint
                                   withDelay:0.25f];
            break;
        }
        case HEAD_UP_ACTION: {
            //抬头的动画
            chinLayer = [OliveappChinLayer layer];
            chinLayer.contents = (__bridge id)([UIImage imageNamed:@"oliveapp_chin.png"].CGImage);
            chinLayer.bounds = CGRectMake(0, 0, self.mBlueFrame.frame.size.width / 4 * 3, self.mBlueFrame.frame.size.width / 2);
            CGPoint chinPoint = CGPointMake(self.mBlueFrame.center.x, self.mBlueFrame.center.y + self.mBlueFrame.frame.size.width / 4);
            chinLayer.position = chinPoint;
            chinLayer.contentsGravity = kCAGravityResizeAspect;
            [self.view.layer addSublayer:chinLayer];
            [chinLayer animationWithScale:1.5 withDuration:HINT_TEXT_DURATION * 2];
            chinUpLayer = [OliveappChinUpLayer layer];
            chinUpLayer.contents = (__bridge id)([UIImage imageNamed:@"oliveapp_chin_up.png"].CGImage);
            chinUpLayer.bounds = CGRectMake(0, 0, self.mBlueFrame.frame.size.width / 7, self.mBlueFrame.frame.size.width / 5);
            CGPoint chinUpPoint = CGPointMake(self.mBlueFrame.center.x, self.mBlueFrame.center.y + self.mBlueFrame.frame.size.width / 4);
            chinUpLayer.position = chinUpPoint;
            chinUpLayer.contentsGravity = kCAGravityResizeAspect;
            [self.view.layer addSublayer:chinUpLayer];
            [chinUpLayer animationWithDuration:HINT_TEXT_DURATION * 2];
            break;
        }
        case MOUTH_OPEN_ACTION: {
            CGPoint mouthPosition = [locationArray[0] CGPointValue];
            
            mouthLayerIn = [OliveappMouthLayer layer];
            mouthLayerIn.contents = (__bridge id)([UIImage imageNamed:@"oliveapp_mouth_close.png"].CGImage);
            mouthLayerIn.bounds = CGRectMake(0, 0, self.mBlueFrame.frame.size.width / 4, self.mBlueFrame.frame.size.width / 8);
            mouthLayerIn.position = mouthPosition;
            mouthLayerIn.contentsGravity = kCAGravityResizeAspect;
            [self.view.layer addSublayer:mouthLayerIn];
            [mouthLayerIn animationFadeIn:2
                             withDuration:HINT_TEXT_DURATION * 3
                                withDelay:0];
            
            mouthLayerOut = [OliveappMouthLayer layer];
            mouthLayerOut.contents = (__bridge id)([UIImage imageNamed:@"oliveapp_mouth_open.png"].CGImage);
            mouthLayerOut.bounds = CGRectMake(0, 0, self.mBlueFrame.frame.size.width / 4, self.mBlueFrame.frame.size.width / 8);
            mouthLayerOut.position = mouthPosition;
            mouthLayerOut.contentsGravity = kCAGravityResizeAspect;
            [self.view.layer addSublayer:mouthLayerOut];
            [mouthLayerOut animationFadeOut:2
                              withDuration:HINT_TEXT_DURATION * 3
                                 withDelay:HINT_TEXT_DURATION * 3];
            break;
        }
        default:
            break;
    }
}

- (void)animationDidStop:(CABasicAnimation *)anim
                finished:(BOOL)flag {
    if (flag) {
        if (anim == [self.mHintView.layer animationForKey:@"hintView"]) {
            [self.mHintView.layer removeAllAnimations];
            self.mHintView.text = mHintText;
            mAnimation = [self.mHintView animationWithScale:1.f
                                               withDuration:HINT_TEXT_DURATION
                                                  withDelay:0
                                           withTimeFunction:nil
                                               withDelegate:nil];
            [self.mLeftDownYellowFrame animationWithTranslate:-mXBias
                                                 withDuration:HINT_TEXT_DURATION
                                                    withDelay:0.f];
            [self.mRightUpYellowFrame animationWithTranslate:mXBias
                                                withDuration:HINT_TEXT_DURATION
                                                   withDelay:0.f];
        }
        if (anim == [self.mHintView.layer animationForKey:@"mouthClose"]) {
            [self.mHintView.layer removeAllAnimations];
            self.mHintView.text = mHintText;
            mAnimation = [self.mHintView animationWithScale:1.f
                                               withDuration:HINT_TEXT_DURATION
                                                  withDelay:0
                                           withTimeFunction:nil
                                               withDelegate:nil];
            [self.mLeftDownYellowFrame animationWithTranslate:-mXBias
                                                 withDuration:HINT_TEXT_DURATION
                                                    withDelay:0.f];
            [self.mRightUpYellowFrame animationWithTranslate:mXBias
                                                withDuration:HINT_TEXT_DURATION
                                                   withDelay:0.f];
        }
    }
}
@end
