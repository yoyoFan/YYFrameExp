//
//  UIImage+FillColor.h
//  HealthFriends
//
//  Created by pan chow on 15/6/5.
//  Copyright (c) 2015年 pan chow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FillColor)
+ (UIImage *)getImgWithFillColor:(UIColor *)fillColor size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)fillColor size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)fillColor cornerRadius:(CGFloat)radius size:(CGSize)size;
@end
