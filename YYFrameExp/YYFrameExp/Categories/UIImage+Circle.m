//
//  UIImage+Circle.m
//  jimao
//
//  Created by pan chow on 14/12/13.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)


+ (UIImage *)CircleImageWithName:(NSString *)imgName
{
    return [[self class] CircleImageWithName:imgName borderColor:[UIColor clearColor] inset:0];
}


+ (UIImage *)CircleImageWithName:(NSString *)imgName borderColor:(UIColor *)color inset:(float)inset
{
    UIImage *oImg = [UIImage imageNamed:imgName];
    UIGraphicsBeginImageContext(oImg.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色
     CGContextSetLineWidth(context,2);
    if(color)
    {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    }
   
    CGRect rect = CGRectMake(inset, inset, oImg.size.width - inset *2.0f, oImg.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [oImg drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}
@end
