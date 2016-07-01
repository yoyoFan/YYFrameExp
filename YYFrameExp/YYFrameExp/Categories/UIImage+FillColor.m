//
//  UIImage+FillColor.m
//  HealthFriends
//
//  Created by pan chow on 15/6/5.
//  Copyright (c) 2015年 pan chow. All rights reserved.
//

#import "UIImage+FillColor.h"

@implementation UIImage (FillColor)

+ (UIImage *)getImgWithFillColor:(UIColor *)fillColor size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *)imageWithColor:(UIColor *)fillColor size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *)imageWithColor:(UIColor *)fillColor cornerRadius:(CGFloat)radius size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    CGContextAddPath(context, rectanglePath.CGPath);
    CGContextFillPath(context);
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}
@end
