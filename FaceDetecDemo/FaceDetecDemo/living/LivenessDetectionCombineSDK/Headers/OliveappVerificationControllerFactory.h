//
//  OliveappVerificationControllerFactory.h
//  OliveappLibrary
//
//  Created by rick on 17/1/3.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//
#import "Foundation/Foundation.h"
#import "OliveappVerificationController.h"
#import "OliveappVerificationControllerWithoutPrestart.h"

@interface OliveappVerificationControllerFactory : NSObject
typedef NS_ENUM(NSUInteger,VerificationControllerType) {
    // 定义检测种类
    WITH_PRESTART = 0,
    WITHOUT_PRESTART = 1
};
+ (id)create:(NSUInteger)withType;
@end
