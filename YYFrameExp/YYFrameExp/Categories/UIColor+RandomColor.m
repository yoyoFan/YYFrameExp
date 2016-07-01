//
//  UIColor+RandomColor.m
//  Mei
//
//  Created by fwr on 15/12/3.
//  Copyright © 2015年 pan chow. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+(UIColor *) randomColor
{
//    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
//    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    UIColor *color_1 = [UIColor colorWithRed:102.0/255 green:204.0/255 blue:204.0/255 alpha:1];
    UIColor *color_2 = [UIColor colorWithRed:204.0/255 green:255.0/255 blue:102.0/255 alpha:1];
    UIColor *color_3 = [UIColor colorWithRed:255.0/255 green:153.0/255 blue:204.0/255 alpha:1];
    UIColor *color_4 = [UIColor colorWithRed:255.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    UIColor *color_5 = [UIColor colorWithRed:255.0/255 green:204.0/255 blue:153.0/255 alpha:1];
    UIColor *color_6 = [UIColor colorWithRed:255.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color_7 = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:102.0/255 alpha:1];
    UIColor *color_8 = [UIColor colorWithRed:153.0/255 green:204.0/255 blue:102.0/255 alpha:1];
    UIColor *color_9 = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:153.0/255 alpha:1];
    //UIColor *color_10 = [UIColor colorWithRed:153.0/255 green:51.0/255 blue:153.0/255 alpha:1];
    UIColor *color_11 = [UIColor colorWithRed:255.0/255 green:153.0/255 blue:204.0/255 alpha:1];
    UIColor *color_12 = [UIColor colorWithRed:255.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color_13 = [UIColor colorWithRed:51.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    UIColor *color_14 = [UIColor colorWithRed:255.0/255 green:153.0/255 blue:204.0/255 alpha:1];
    //UIColor *color_15 = [UIColor colorWithRed:0.0/255 green:51.0/255 blue:153.0/255 alpha:1];
    UIColor *color_16 = [UIColor colorWithRed:204.0/255 green:255.0/255 blue:0.0/255 alpha:1];
    NSArray *colorArray=[[NSArray alloc]initWithObjects:color_1,color_2,color_3,color_4,color_5,color_6,color_7,color_8,color_9,color_11,color_12,color_13,color_14,color_16,nil];
    int r = arc4random() % [colorArray count];
    return colorArray[r];
}

@end
