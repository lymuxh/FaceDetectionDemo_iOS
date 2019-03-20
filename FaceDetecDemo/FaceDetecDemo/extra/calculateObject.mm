//
//  calculateObject.m
//  CZRemote
//
//  Created by archie on 17/6/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "calculateObject.h"
#import <opencv2/opencv.hpp>

@implementation calculateObject

+(void)recognitionFace:(UIImage *)img completion:(void (^)(int faces,CGRect rect))done{
  NSString *pstrCascadeFileName =[[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
  CvHaarClassifierCascade *pHaarCascade=(CvHaarClassifierCascade*)cvLoad([pstrCascadeFileName cStringUsingEncoding:NSASCIIStringEncoding],NULL,NULL,NULL);
  CvMemStorage*pcvMStorage = cvCreateMemStorage(0);
  cvClearMemStorage(pcvMStorage);
  IplImage*grayImage=[self createIplImage:img WithChannel:1];
  CvSeq *Faces = cvHaarDetectObjects(grayImage,pHaarCascade,pcvMStorage);
  
  if (Faces->total==1) {
    CvRect* r = (CvRect*)cvGetSeqElem(Faces, 0);
    done(Faces->total,CGRectMake(r->x, r->y, r->width, r->height));
  }else{
    done(Faces->total,CGRectZero);
  }
  
//  for(int i = 0; i <Faces->total; i++)
//  {
//    CvRect* r = (CvRect*)cvGetSeqElem(Faces, i);
//    CvPoint center;
//    int radius;
//    center.x = cvRound((r->x + r->width * 0.5));
//    center.y = cvRound((r->y + r->height * 0.5));
//    radius = cvRound((r->width + r->height) * 0.25);
//    
//    NSLog(@"中心x:%d,中心y:%d,半径:%d",center.x,center.y,radius);
//  }
  cvReleaseHaarClassifierCascade(&pHaarCascade);
  cvReleaseMemStorage(&pcvMStorage);
  cvReleaseImage(&grayImage);
  
}
/*灰度图*/
+(IplImage*)createIplImage:(UIImage*)img WithChannel:(int)channels {
  CGImageRef OldImageRef=img.CGImage;
  CGColorSpaceRef space=CGColorSpaceCreateDeviceRGB();
  IplImage*NewImage=cvCreateImage(cvSize(img.size.width, img.size.height), IPL_DEPTH_8U, 4);
  CGContextRef contextRef=CGBitmapContextCreate(NewImage->imageData, NewImage->width, NewImage->height, NewImage->depth, NewImage->widthStep, space, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
  CGContextDrawImage(contextRef, CGRectMake(0, 0, img.size.width, img.size.height), OldImageRef);
  CGColorSpaceRelease(space);
  CGContextRelease(contextRef);
  
  IplImage*grayImg=cvCreateImage(cvGetSize(NewImage), NewImage->depth, channels);
  cvCvtColor(NewImage, grayImg, channels==1?CV_RGBA2GRAY:CV_RGBA2BGR);
  cvReleaseImage(&NewImage);
  return grayImg;
}
@end
