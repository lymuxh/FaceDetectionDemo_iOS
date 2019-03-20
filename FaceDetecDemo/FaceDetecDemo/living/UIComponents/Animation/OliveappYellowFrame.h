//
//  OliveappYellowFrame.h
//  AppSampleYitu
//
//  Created by kychen on 17/1/16.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OliveappYellowFrame : UIImageView

- (void)flashAnimationWithTranslate:(CGFloat)XBias
                  withDuration:(CGFloat)duration;

- (void) animationWithTranslate:(CGFloat)XBias
                        withDuration:(CGFloat)duration
                           withDelay:(CGFloat)delay;

@end
