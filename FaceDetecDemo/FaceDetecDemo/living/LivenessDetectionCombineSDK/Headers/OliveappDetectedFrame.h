//
//  DetectedFrame.h
//  LivenessDetector
//
//  Created by Jiteng Hao on 16/1/18.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OliveappDetectedFrame : NSObject

@property (strong) NSData* frameData; // 默认为nil
@property (strong) NSData* verificationData;

- (id) initWithFrameData: (NSData*) frameData
    withVerificationData: (NSData*) verificationData;

@end
