//
//  ErrorHelper.h
//  FaceVerificationSDK
//
//  Created by xylin on 13/01/16.
//  Copyright (c) 2015 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OliveappErrorHelper : NSObject

typedef NS_ENUM(NSInteger, FaceVerificationErrorCode)
{
    FACE_VERIFICATION_PARAMETER_NIL,
    FACE_VERIFICATION_PARAMETER_NOT_VALID,
    ILLUMINATION_EVALUATION_TOO_STRONG,
    ILLUMINATION_EVALUATION_TOO_DARK,
    ILLUMINATION_EVALUATION_UNEVEN,
    MORE_THAN_ONE_FACE_ON_IMAGE,
    NO_FACE_ON_IMAGE,
    FACE_TOO_SMALL_ON_IMAGE,
    SERVER_ERROR,
    RESPONSE_ERROR,
    USER_NOT_EXIST_ERROR,
    SERVICE_NOT_AVALIABLE,
    FACE_NOT_IN_FRAME_ERROR,
    //SEND_SYNCHRONOUS_REQUEST_ERROR,
    JSON_OBJECT_WITH_DATA_ERROR,
    DATA_WITH_JSON_OBJECT_ERROR,
    LIVENESS_START_FAIL,
    SESSION_MANAGER_INIT_FAIL,
    SESSION_MANAGER_UNINIT_FAIL,
    INVALID_SESSION_CONFIG_ERROR,
    EMPTY_OBJECT,
    NORMAL_ERROR,
    NETWORK_ERROR
};

+ (NSError*) newErrorWithDescription: (NSString*)errorDescriotion withErrorCode: (FaceVerificationErrorCode)errorCode;

@end
