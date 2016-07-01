//
//  UIImage+WaterMark.h
//  Demo-CustomQRCore
//
//  Created by pan chow on 15/5/5.
//  Copyright (c) 2015年 yourtion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WaterMark)

- (UIImage *)getImgWithWaterMark:(UIImage *)markImg witFrame:(CGRect)frame;

@end
