//
//  faceView.h
//  FaceIOS
//
//  Created by archie on 17/4/13.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface faceView : UIView
@property(nonatomic,strong)void(^callBackImagePath)(NSString*UrlPath); //回调地址
@property(nonatomic, strong)void(^callBackImageData)(NSData *imgData);
@end
