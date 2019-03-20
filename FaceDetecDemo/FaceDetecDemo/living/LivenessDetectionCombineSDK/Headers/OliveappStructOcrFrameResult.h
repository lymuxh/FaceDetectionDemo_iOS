//
//  StructOcrFrameResult.h
//  IdcardOcrSDK
//
//  Created by Xiaoyang Lin on 16/5/11.
//  Copyright © 2016年 com.yitutech. All rights reserved.
//

#ifndef OliveappStructOcrFrameResult_h
#define OliveappStructOcrFrameResult_h

typedef enum {
    FRONT_IDCARD = 1,
    BACK_IDCARD = 2
} OliveappCardType;

typedef enum {
    ONLY_AUTO_MODE = 1,
    ONLY_MANUAL_MODE = 2,
    MIXED_MODE = 3
} OliveappCaptureMode;

enum OliveappType {
    PASS = 1,
    NOFACE = 2,
    BAD_POSITION = 3,
    LOW_SCORE = 4,
    REFLECT = 5,
    FUZZY = 6,
    SHAKE = 7,
    TOO_FAR = 8,
    TOO_CLOSE = 9,
    BAD_FIRST_RECT = 10,
    BAD_LAST_RECT = 11
};

struct OliveappOcrVerificationResult {
    enum OliveappType status;
    BOOL isFinish; //是否已经检测到合法身份证
    BOOL isValid; //如果是NO代表结果是空的，否则代表有结果
};

#endif /* OliveappStructOcrFrameResult_h */
