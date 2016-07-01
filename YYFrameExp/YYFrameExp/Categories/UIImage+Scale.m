//
//  UIImage+Scale.m
//  jimao
//
//  Created by Dongle Su on 14-12-5.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)
+ (void)beginImageContextWithSize:(CGSize)size
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
}

+ (void)endImageContext
{
    UIGraphicsEndImageContext();
}

- (UIImage *)imageScaledToSize:(CGSize)newSize
{
    [UIImage beginImageContextWithSize:newSize];
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    [UIImage endImageContext];
    return newImage;
}
@end
