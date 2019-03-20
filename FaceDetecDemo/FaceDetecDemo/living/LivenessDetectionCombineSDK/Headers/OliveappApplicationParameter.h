//
//  Header.h
//
//
//  Created by jqshen on 6/25/15.
//  Copyright (c) 2015 Oliveapp. All rights reserved.
//

#ifndef FaceVerifiactionSDK_Header_h
#define FaceVerifiactionSDK_Header_h

const static char * const SDK_VERSION_NAME = "1.7.a";  // TODO: 发布SDK前应该检查此值
const static int SDK_VERSION_CODE = 1; // TODO: 每次发布SDK时应该增加此值
const static char * const VERSION_IDENTIFIER = "livenessdetetion";
const static int FRAME_BUFFER_CAPACITY = 1;

const static int SESSION_START_DROP_FRAMES = 10;
const static long GETREADY_COOLDOWN_MILLISECOND = 400;
const static long START_COOLDOWN_MILLISECOND = 0;
const static long GETREADY_TIMEOUT_MILLISECOND = 10000;
const static long ACTION_TIMEOUT_MILLISECOND = 5000;
const static int FACIAL_ACTION_WORKER_THREAD_POOL_SIZE = 1;

// 图像截取参数
const static float FACE_IMAGE_TARGET_WIDTH = 300;
const static float FACE_IMAGE_TARGET_HEIGHT = 400;
const static float FACE_CROP_HORIZONTAL_PERCENT = 1.0f;
const static float FACE_CROP_HORIZONTAL_PERCENT_IPAD_LANDSCAPE = 1.f;
const static float FACE_VERTICAL_TOP_PERCENT = 0.0f; // android version is 0.0f
const static int FACE_PRE_ROTATION_DEGREE_0 = 0;
const static int FACE_PRE_ROTATION_DEGREE_90 = 90;
const static int FACE_PRE_ROTATION_DEGREE_180 = 180;
const static int FACE_PRE_ROTATION_DEGREE_IPAD_LANDSCAPE = 0;
const static bool FACE_IMAGE_SHOULD_FLIP = false;
const static int FACE_HORIZONTAL_MARGIN = 100;
const static float FACE_VERTICAL_OFFSET_IPAD_LANDSCAPE = 0.f;

// 网络请求参数
const static int DEFAULT_CONNECT_TIMEOUT_MILLISECOND = 10000;
const static int DEFAULT_RESPONSE_TIMEOUT_MILLISECOND = 30000;

const static char * const MODEL_PATH = "/sdcard/models/model2";

const static bool SAVE_IMAGE = false;
const static int SAVE_IMAGE_THREADS = 1;

const static char * const PAIR_VERIFICATION_FILE_PATH = "/sdcard/tmp/pair_verify/";

const static int MAX_PAIR_VERIFICATION_WAIT_DURATION_MILLISEC = 30000;

const static char * const SERVICE_IP = "121.42.152.46";

const static int USER_REGISTRACTION_UPLOAD_IMAGE_QUALITY = 95;

const static int ID_CARD_UPLOAD_IMAGE_WIDTH = 1920;

const static int MIN_FACE_PIXEL = 200;

const static int MAX_NO_FACE_FRAME_THRESHOULD = 10000000;

const static NSString * LIVENESS_PORTRAIT_STORYBOARD = @"LivenessDetectionStoryboard";
const static NSString * LIVENESS_LANDSCAPE_STORYBOARD = @"LivenessDetectionLandscapeStoryboard";

const static int OLIVEAPP_PACKAGE_VERSION = 5;

const static BOOL IS_DEBUG = NO;
//存储相关
static NSString * const SAVE_PATH = @"oliveapp_debug";

//动作相关
const static int EYE_CLOSE_ACTION = 3;
const static int MOUTH_OPEN_ACTION = 1;
const static int HEAD_UP_ACTION = 53;
#endif
