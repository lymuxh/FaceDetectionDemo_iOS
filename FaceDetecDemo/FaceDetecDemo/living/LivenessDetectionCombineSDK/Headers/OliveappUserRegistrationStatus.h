//
//  UserRegistrationStatus.h
//  YituLivenessDetectionSDK
//
//  Created by jqshen on 8/25/15.
//  Copyright (c) 2015 YITU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, UserRegistrationStatus) {
    REGISTRATIO_SUCC = 1,
    // USER_NOT_REGISTERED = 2,
    USER_NOT_REGISTERED_WITH_SPRCIFIED_IMAGE_TYPE = 3,
    UNDER_REGISTRATION = 4,
    REGISTRATION_FAILED = 5,
    ERROR = 6
};
