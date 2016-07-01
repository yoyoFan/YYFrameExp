//
//  UIColor+Between.m
//  jimao
//
//  Created by Dongle Su on 15/8/3.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "UIColor+Between.h"

@implementation UIColor (Between)
+ (UIColor *)colorBetween:(UIColor *)color1 and:(UIColor *)color2 percent:(CGFloat)percent {
    CGFloat red1, green1, blue1, alpha1;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    
    CGFloat red2, green2, blue2, alpha2;
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    CGFloat p1 = percent;
    CGFloat p2 = 1-percent;
    UIColor *mid = [UIColor colorWithRed:red1*p1+red2*p2 green:green1*p1+green2*p2 blue:blue1*p1+blue2*p2 alpha:alpha1*p1+alpha2*p2];
    return mid;
}

@end
