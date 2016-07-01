//
//  UIImage+Gradient.h
//  jimao
//
//  Created by Dongle Su on 15/8/3.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Gradient)
+ (UIImage *)imageWithVerticalGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size;
+ (UIImage *)imageWithBottomHalfGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size;
@end
