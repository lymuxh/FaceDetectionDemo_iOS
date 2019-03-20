//
//  PhotoImage.h
//  
//
//  Created by Xiaoyang Lin on 5/1/15.
//  Copyright (c) 2015 Oliveapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface OliveappPhotoImage : NSObject

- (id)initWithCIImage: (CIImage*) ciImage
          withFrameId: (int) frameId
 withCaptureTimestamp: (long long) captureTimestamp
            withWidth: (size_t) width
           withHeight: (size_t) height
         withRowWidth: (size_t) rowSize;

- (NSData*) getImageContent;

@property NSData * imageContent;
@property CIImage* ciImage;
@property int frameId;
@property long long captureTimestamp;

@property size_t imageWidth;
@property size_t imageHeight;
@property size_t imageRowSize;


+ (CGRect) getCropWithWidth: (unsigned long) imageWidth
                 withHeight: (unsigned long) imageHeight
           withApertureView: (UIView *) apertureView
withCameraPreviewSuperViewAdapter: (UIView *) cameraPreviewSuperViewAdapter;

@end
