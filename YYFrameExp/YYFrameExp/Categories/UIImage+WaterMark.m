//
//  UIImage+WaterMark.m
//  Demo-CustomQRCore
//
//  Created by pan chow on 15/5/5.
//  Copyright (c) 2015年 yourtion. All rights reserved.
//

#import "UIImage+WaterMark.h"

@implementation UIImage (WaterMark)

- (UIImage *)getImgWithWaterMark:(UIImage *)markImg witFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //水印图片的位置
    [markImg drawInRect:frame];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
@end
