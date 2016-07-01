//
//  CircleImgLayer.m
//  jimao
//
//  Created by pan chow on 15/8/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "CircleImgLayer.h"

@interface CircleImgLayer ()
{
    UIImage *_img;
    
    BOOL _isCircle;
}
@end
@implementation CircleImgLayer

- (void)fillWithImg:(UIImage *)img Circle:(BOOL)isCircle
{
    _img = img;
    _isCircle = isCircle;
    [self setNeedsDisplay];
}
- (void)fillWithImg:(UIImage *)img
{
    [self fillWithImg:img Circle:YES];
}
- (void)drawInContext:(CGContextRef)ctx
{
    if(_isCircle)
    {
        [self drawCircle];
    }
    
    
    CGContextSaveGState(ctx);
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -height);
    
    //注意这个位置是相对于图层而言的不是屏幕
    if(_isCircle)
    {
         CGContextDrawImage(ctx, CGRectMake(0, 0, height, height), _img.CGImage);
    }
    else
    {
         CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), _img.CGImage);
    }
    
    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);

}
- (void)drawCircle
{
    CGFloat height = self.bounds.size.height;
    
    self.backgroundColor=[UIColor clearColor].CGColor;
    self.cornerRadius=height/2;
    self.masksToBounds=YES;
    //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
    //而阴影效果刚好在外边框
    //    layer.shadowColor=[UIColor grayColor].CGColor;
    //    layer.shadowOffset=CGSizeMake(2, 2);
    //    layer.shadowOpacity=1;
    //设置边框
    self.borderColor=[UIColor whiteColor].CGColor;
    self.borderWidth=1;
}
- (void)drawShadow
{
    
}
@end
