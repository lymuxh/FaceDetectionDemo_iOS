//
//  ImageForVerifyConf.m
//  LivenessDetector
//
//  Created by Xiaoyang Lin on 16/1/16.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OliveappImageForVerifyConf: NSObject

@property int imgWidth;
@property int imgHeight;
@property int targetWidth;
@property int targetHeight;
@property float horizontalPercent;
@property float verticalOffset;
@property int preRotationDegree;
@property int horizontalMargin;
@property bool shouldFlip;

@end
