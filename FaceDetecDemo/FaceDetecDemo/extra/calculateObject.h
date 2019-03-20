//
//  calculateObject.h
//  CZRemote
//
//  Created by archie on 17/6/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface calculateObject : NSObject

+(void)recognitionFace:(UIImage *)img completion:(void (^)(int faces,CGRect rect))done;


@end
