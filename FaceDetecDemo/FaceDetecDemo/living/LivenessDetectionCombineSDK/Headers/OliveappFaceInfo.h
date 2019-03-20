//
//  OliveappFaceInfo.h
//  OliveappLibrary
//
//  Created by Xiaoyang Lin on 17/1/9.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OliveappStructLivenessFrameResult.h"
@interface OliveappFaceInfo : NSObject

@property (nonatomic) struct Position leftEye;
@property (nonatomic) struct Position rightEye;
@property (nonatomic) struct Position mouth;
@property (nonatomic) struct Position chin;
@end
