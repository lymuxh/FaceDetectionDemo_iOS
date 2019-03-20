//
//  OliveappButtonAnimationLayer.h
//  AppSampleYitu
//
//  Created by kychen on 17/1/16.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OliveappButtonAnimationLayer : CALayer

- (instancetype)initWithFrame:(CGRect)frame;


/**
 炸开动画
 
 @param position <#position description#>
 @param array <#array description#>
 @param buttonLayer <#buttonLayer description#>
 */
- (void)animationAt:(CGPoint)position
 withTransformArray:(NSArray *)array
    withParentLayer:(CALayer *)buttonLayer;

@end
