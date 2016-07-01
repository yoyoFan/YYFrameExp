//
//  UIColor+Common.h
//  jimao
//
//  Created by pan chow on 14/11/26.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
//see:https://github.com/VAlexander/Chameleon#color-schemes-methods

/**
 *  Defines the gradient style and direction of the gradient color.
 */
typedef NS_ENUM (NSUInteger, UIGradientStyle) {
    /**
     *  Returns a gradual blend between colors originating at the leftmost point of an object's frame, and ending at the rightmost point of the object's frame.
     */
    UIGradientStyleLeftToRight,
    /**
     *  Returns a gradual blend between colors originating at the center of an object's frame, and ending at all edges of the object's frame. NOTE: Supports a Maximum of 2 Colors.
     */
    UIGradientStyleRadial,
    /**
     *  Returns a gradual blend between colors originating at the topmost point of an object's frame, and ending at the bottommost point of the object's frame.
     */
    UIGradientStyleTopToBottom
};

/**
 *  Defines the shade of a any flat color.
 */
typedef NS_ENUM (NSInteger, UIShadeStyle) {
    /**
     *  Returns the light shade version of a flat color.
     */
    UIShadeStyleLight,
    /**
     *  Returns the dark shade version of a flat color.
     */
    UIShadeStyleDark
};



@interface UIColor (Common)

#pragma mark - Chameleon - Instance Variables
/**
 *  Stores an object's UIColor image if the UIColor was created using colorWithPatternImage.
 */
@property (nonatomic, strong) UIImage *gradientImage;

#pragma mark - Chameleon - Quick Shorthand Macros

//Quick & Easy Shorthand for RGB x HSB Colors - The reason we don't import our Macro file is to prevent naming conflicts.
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define hsba(h,s,b,a) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:a]
#define hsb(h,s,b) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:1.0]



#pragma mark - UIColor from Hex
+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)colorWithGradientStyle:(UIGradientStyle)gradientStyle withFrame:(CGRect)frame andColors:(NSArray *)colors;


@end
