//
//  faceView.m
//  FaceIOS
//
//  Created by archie on 17/4/13.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "faceView.h"
#import <AVFoundation/AVFoundation.h>
#import "calculateObject.h"


@interface faceView()<AVCaptureVideoDataOutputSampleBufferDelegate>{
  UIView*faceRect;
  UILabel*Promptla;
  BOOL pickImageSelected;
}
@property(nonatomic,strong)AVCaptureSession*session;
@property(nonatomic,strong) AVCaptureStillImageOutput*captrueOut;
@property(nonatomic,strong)CAShapeLayer*circleLayer;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer*previewLayer;

@end


@implementation faceView

-(instancetype)initWithFrame:(CGRect)frame{
  if (self=[super initWithFrame:frame]) {
    [self capture];
  }
  return self;
}
-(void)capture{
  pickImageSelected=YES;
  NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
  [formatter setDateFormat:@"yyyyMMddHHmmss"];
  NSString*tmpName=[formatter stringFromDate:[NSDate date]];
  [UIApplication sharedApplication].idleTimerDisabled=YES;
  self.session=[[AVCaptureSession alloc]init];
  [self.session setSessionPreset:AVCaptureSessionPresetMedium];
  
  NSArray*as=[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
  [as enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    AVCaptureDevice*device=obj;
    if (device.position==AVCaptureDevicePositionBack) {
      AVCaptureDeviceInput*input=[[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
      [self.session addInput:input];
    }
  }];
  AVCaptureVideoDataOutput*Output=[[AVCaptureVideoDataOutput alloc]init];
  Output.alwaysDiscardsLateVideoFrames=YES;
  [Output setSampleBufferDelegate:self queue:dispatch_queue_create(tmpName.UTF8String, DISPATCH_QUEUE_SERIAL)];
  NSDictionary*pixelDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
  [Output setVideoSettings:pixelDic];
  [self.session addOutput:Output];
  
  CGSize screenSize =[UIScreen mainScreen].bounds.size;
  self.previewLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
  self.previewLayer.frame=CGRectMake(0, 0, screenSize.width,self.bounds.size.height);
  self.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
  [self.layer addSublayer:self.previewLayer];
  
  if (self.frame.size.height==kScreenHeight) {
    UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imgView.image=[UIImage imageNamed:@"Recognition"];
    [self addSubview:imgView];
  }
  [self.session startRunning];
  
  Promptla=[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, (kScreenHeight-70)/2, 200, 70)];
  Promptla.layer.cornerRadius=7;
  Promptla.layer.masksToBounds=YES;
  Promptla.numberOfLines=0;
  Promptla.font=[UIFont fontWithName:@"Arial" size:15];
  Promptla.textAlignment=NSTextAlignmentCenter;
  Promptla.backgroundColor=[UIColor whiteColor];
  Promptla.textColor=[UIColor blackColor];
  Promptla.text=@"";
  Promptla.hidden=YES;
  [self addSubview:Promptla];
  
//  faceRect=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//  faceRect.layer.borderWidth=2;
//  faceRect.layer.borderColor=[UIColor redColor].CGColor;
//  [self addSubview:faceRect];
  
  
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
  [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
  
  CVPixelBufferRef imageBuffer=CMSampleBufferGetImageBuffer(sampleBuffer);
  CVPixelBufferLockBaseAddress(imageBuffer, 0);
  void*baseAddress=CVPixelBufferGetBaseAddress(imageBuffer);
  size_t width=CVPixelBufferGetWidth(imageBuffer);
  size_t height=CVPixelBufferGetHeight(imageBuffer);
  size_t bytesPerRow=CVPixelBufferGetBytesPerRow(imageBuffer);
  CGColorSpaceRef space=CGColorSpaceCreateDeviceRGB();
  CGContextRef context=CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, space, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
  CGImageRef imageRef=CGBitmapContextCreateImage(context);
  CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
  
  UIImage*img=[UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationLeft];
  CGImageRelease(imageRef);
  CGColorSpaceRelease(space);
  CGContextRelease(context);
  [calculateObject recognitionFace:img completion:^(int faces, CGRect rect) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (pickImageSelected) {
        if (faces>1) {
          Promptla.hidden=NO;
          Promptla.text=@"人数过多,请只对准申请人.";
        }else if(faces<1){
          Promptla.hidden=NO;
          Promptla.text=@"请对准申请人.";
        }else{
           NSLog(@"矩形:%@",NSStringFromCGRect(rect));
          if (rect.size.width>135*(kScreenWidth/320)&&fabs(rect.origin.x)<185){
            //成功
            [self.session stopRunning];
            Promptla.hidden=YES;
            pickImageSelected=NO;
            Promptla.text=@"";
            NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString*tmpName=[formatter stringFromDate:[NSDate date]];
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",tmpName]];
            if ([UIImageJPEGRepresentation(img, 1.0) writeToFile:fullPathToFile atomically:NO]) {
              self.callBackImagePath(fullPathToFile);
            }
//              if (self.callBackImageData) {
//                  self.callBackImageData(UIImageJPEGRepresentation(img, 1.0));
//              }
          }else if (fabs(rect.origin.x)>150){
            Promptla.hidden=NO;
            Promptla.text=@"请申请人摆正姿势";
          }else{
            Promptla.hidden=NO;
            Promptla.text=@"申请人和设备距离不要过远.";
          }
        }
      }
      
    });
    
    
  }];
  
}


@end
