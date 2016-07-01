//
//  TextLayer.m
//  jimao
//
//  Created by pan chow on 15/8/7.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "TextLayer.h"

@interface TextLayer ()
{
    NSString *_text;
}
@end

@implementation TextLayer

- (void)fillWithText:(NSString *)text
{
    _text = text;
    
    [self setNeedsDisplay];
}
- (void)drawInContext:(CGContextRef)ctx
{
   
    [self drawText:nil];
//    CGContextSaveGState(ctx);
//    CGFloat height = self.bounds.size.height;
//    //图形上下文形变，解决图片倒立的问题
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -height);
//    
//    //注意这个位置是相对于图层而言的不是屏幕
//    //CGContextDrawImage(ctx, CGRectMake(0, 0, height, height), _img.CGImage);
//    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
//    //    CGContextDrawPath(ctx, kCGPathFillStroke);
//    
//    CGContextRestoreGState(ctx);
    
}
- (void)drawText:(CGContextRef)context
{
    if(_text)
    {
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        self.contentsScale = [UIScreen mainScreen].scale;
        
        self.alignmentMode = kCAAlignmentJustified;
        self.wrapped = YES;
        
        self.backgroundColor = [UIColor blackColor].CGColor;
        self.font = (__bridge CFTypeRef)([UIFont16 fontName]);
        self.foregroundColor = [UIColor whiteColor].CGColor;
        self.fontSize = 14;
        NSDictionary *attDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:UIFont16,NSBackgroundColorAttributeName:[UIColor whiteColor]};
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_text attributes:attDic];
        self.string = _text;
//        CGSize textSize = [_text sizeWithAttributes:attDic];
//        CGFloat Xoffset = 8;
//        CGFloat Yoffset = 8;
//        CGPoint origin = CGPointMake( Xoffset, Yoffset);
//        CGContextSetTextDrawingMode(context, kCGTextStroke);
//        CGContextSetLineWidth(context, textSize.height/10);
//        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
//        
//        [_text drawAtPoint:origin withAttributes:attDic];
//        
//        CGContextSetTextDrawingMode(context, kCGTextFill);
//        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
//        [_text drawAtPoint:origin withAttributes:attDic];
    }
    
}
@end
