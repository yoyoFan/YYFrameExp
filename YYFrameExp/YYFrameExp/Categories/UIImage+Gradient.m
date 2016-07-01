//
//  UIImage+Gradient.m
//  jimao
//
//  Created by Dongle Su on 15/8/3.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "UIImage+Gradient.h"

@implementation UIImage (Gradient)
+ (UIImage *)imageWithVerticalGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

    CGFloat r0, g0, b0, a0, r1, g1, b1, a1;
    size_t gradientNumberOfLocations = 2;
    CGFloat gradientLocations[2] = { 0.0, 1.0 };
    [fromColor getRed:&r0 green:&g0 blue:&b0 alpha:&a0];
    [toColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    CGFloat gradientComponents[8] = { r0, g0, b0, a0,     // Start color
        r1, g1, b1, a1, };  // End color
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents, gradientLocations, gradientNumberOfLocations);

    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithBottomHalfGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, fromColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height/2.0f));

    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat r0, g0, b0, a0, r1, g1, b1, a1;
    size_t gradientNumberOfLocations = 2;
    CGFloat gradientLocations[2] = { 0.0, 1.0 };
    [fromColor getRed:&r0 green:&g0 blue:&b0 alpha:&a0];
    [toColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    CGFloat gradientComponents[8] = { r0, g0, b0, a0,     // Start color
        r1, g1, b1, a1, };  // End color
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents, gradientLocations, gradientNumberOfLocations);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, size.height/2.0f), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return image;
}

@end
