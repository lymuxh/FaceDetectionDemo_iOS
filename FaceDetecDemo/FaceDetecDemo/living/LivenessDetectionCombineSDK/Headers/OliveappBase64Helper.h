//
//  Base64Helper.h
//  YituFaceVerifiactionSDK
//
//  Created by Jiteng Hao on 15/10/8.
//  Copyright © 2015年 YITU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OliveappBase64Helper : NSObject

+ (NSString*) encode: (NSData*) data;

// NOTE: this code is not tested
+ (NSData*) decode: (NSString*) encoded;
                     
@end
