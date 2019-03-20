//
//  StructLivenessFrameResult.h
//  LivenessDetector
//
//  Created by Xiaoyang Lin on 16/1/7.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#ifndef StructLivenessFrameResult_h
#define StructLivenessFrameResult_h


/*
 * 活体检测会话状态
 */
enum EnumLivenessSessionResult
{
    SESSION_NOT_START = 0, // 活体检测未开始
    SESSION_NOT_SURE = 1, // 不确定 是否结束
    SESSION_PASS = 2, // 活体检测通过
    SESSION_FAIL = 3, // 活体检测失败
    SESSION_TIMEOUT = 4 // 活体检测超时
};

enum EnumFacialActionType
{
    FACIAL_ACTION_UNKOWN = 0, //不支持
    FACIAL_ACTION_MOUTH_OPEN = 1,//支持
    FACIAL_ACTION_EYE_CLOSE = 3,//支持
    FACIAL_ACTION_CAPTURE = 50,//支持
    FACIAL_ACTION_HEAD_LEFT = 51,//不支持
    FACIAL_ACTION_HEAD_RIGHT = 52,//不支持
    FACIAL_ACTION_HEAD_UP = 53,//支持
    FACIAL_ACTION_HEAD_DOWN = 54,//不支持
    FACIAL_ACTION_HEAD_SHAKE_SIDE_TO_SIDE = 60//支持
};

enum StructFacialActionVerificationResultType
{
    START = 0,          /// waiting user to focus on screen
    PASS = 1000,        /// genuine & finished the facial action
    FAIL = 1001,        /// the facial action is not finished
    NOT_SURE = 1002    /// Not sure
};


enum EnumErrorCodeOfInAction
{
    NONE = 0,
    
    FACE_NOT_FOUND = 10,
    FACE_TOO_SMALL_FACE,
    FACE_TOO_LARGE_FACE,
    
    LIGHT_TOO_BRIGHT = 20,
    LIGHT_TOO_DARK,
    
    FACE_SIDE_FACE = 30,
    FACE_UP_FACE,
    FACE_DOWN_FACE
};

struct StructFacialActionVerificationResult
{
    enum StructFacialActionVerificationResultType state;
    double normalizedConfidence; // verify score(normalized score), should be in range [0, 100]
};

struct Position
{
    double x;
    double y;
};

// 单帧活体检测结果
struct StructLivenessFrameResult
{
    // 错误码
    int rtn;
    
    // Session级的信息
    enum EnumLivenessSessionResult sessionState; // 活体检测结果
    bool isActionChanged; // 动作是否切换
    
    
    // 动作级的信息
    int currentActionIndex;
    enum EnumFacialActionType actionTypes[10]; // 当前动作是什么，上限是10个，可以根据需要调整
    struct StructFacialActionVerificationResult actionResults[10]; // 动作的状态，上限是10个，可以根据需要调整
    int remainTimeoutMilliSecond; // 剩余的超时时间
    enum EnumErrorCodeOfInAction errorCodeOfInAction[10]; //动作反馈
    struct Position leftEye;//左眼坐标
    struct Position rightEye;//右眼坐标
    struct Position mouth;
    struct Position chin;
};

#endif /* StructLivenessFrameResult_h */
