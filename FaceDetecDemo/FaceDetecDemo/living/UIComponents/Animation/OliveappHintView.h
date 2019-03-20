//
//  OliveappHintView.h
//  AppSampleYitu
//
//  Created by kychen on 17/1/16.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface OliveappHintView : UILabel

- (CABasicAnimation *) animationWithScale:(CGFloat)scale
              withDuration:(CGFloat)duration
                 withDelay:(CGFloat)delay
          withTimeFunction:(CAMediaTimingFunction *)fn
            withDelegate: (id) delegate;

@end
