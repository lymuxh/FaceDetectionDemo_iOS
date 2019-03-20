//
//  ViewController.h
//  AnimationTestApp
//
//  Created by kychen on 16/12/30.
//  Copyright © 2016年 keyu.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OliveappLivenessResultDelegate.h"
#import "OliveappBlueFrame.h"
#import "OliveappYellowFrame.h"
#import "OliveappHintView.h"
#import "OliveappEyeLayer.h"
@interface OliveappLivenessDetectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet OliveappBlueFrame * mBlueFrame;
@property (weak, nonatomic) IBOutlet OliveappYellowFrame * mLeftDownYellowFrame;
@property (weak, nonatomic) IBOutlet OliveappYellowFrame * mRightUpYellowFrame;
@property (weak, nonatomic) IBOutlet OliveappHintView * mHintView;


/**
 配置活体检测

 @param delegate 回调的代理对象
 @param error 错误码
 @return 是否配置成功
 */
- (BOOL) setConfigLivenessDetection: (id<OliveappLivenessResultDelegate>) delegate
                          withError: (NSError **) error;

@end

