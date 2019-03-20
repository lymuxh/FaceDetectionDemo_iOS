//
//  ImageUtility.h
//  FaceVerificationSDK
//
//  Created by jqshen on 5/4/15.
//  Copyright (c) 2015 Oliveapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface OliveappImageUtility : NSObject

+ (CIImage*)cropImage: (CIImage*) ciImage withCropArea: (CGRect)cropArea;

+ (CIImage*)scaleImage: (CIImage*) ciImage withScaleRatio: (CGFloat)scaleRatio;

+ (CIImage*)rotateImageClockWise90: (CIImage*) ciImage witdDegree: (double) degree;

+ (void)storeImage:(CIImage*)_image withFileName: (NSString*) fileName;

+ (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage ;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (void) printImageInfo: (UIImage*) image;

+ (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height;
@end
