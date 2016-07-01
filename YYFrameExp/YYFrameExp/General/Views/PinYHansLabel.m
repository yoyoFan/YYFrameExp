//
//  PinYHansLabel.m
//  jimao
//
//  Created by pan chow on 15/6/12.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "PinYHansLabel.h"

#import <Masonry/Masonry.h>

#define HORI_MARGIN 10
#define VER_MARGIN 10
@interface PinYHansLabel ()
{
    NSInteger row;
    NSInteger col;
}
@property (nonatomic,strong)NSArray *Pins;
@property (nonatomic,strong)NSArray *hans;
@property (nonatomic,strong)NSDictionary *attDic;
@end
@implementation PinYHansLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    row = 0;
    col = 0;
    CGFloat labelHeight = .0f;
    CGFloat right = .0f;
    CGFloat lastHeight = .0f;
    if(_Pins.count == _hans.count)
    {
        NSInteger count = _Pins.count;
        for(NSInteger i = 0;i<count;i++)
        {
            NSString *pinYin = _Pins[i];
            NSString *hans = _hans[i];
            CGSize pin_size = [pinYin sizeWithAttributes:_attDic];
            CGSize Han_size = [hans sizeWithAttributes:_attDic];
            CGFloat width = MAX(pin_size.width, Han_size.width);
            
            right +=HORI_MARGIN + width;
            if(right>rect.size.width)
            {
                row++;
                col = 0;
                
                labelHeight +=pin_size.height+Han_size.height+2*VER_MARGIN;
                lastHeight = pin_size.height+Han_size.height+2*VER_MARGIN;
                right = .0f;
                right +=HORI_MARGIN + width;
                
            }
            
            CGFloat centerX = right - width*.5;
            CGFloat topY = (row+1)*VER_MARGIN +row*(pin_size.height+Han_size.height);
            //此处不加20的话文字会超出顶部，原因未明。
            [pinYin drawWithRect:CGRectMake(centerX-pin_size.width*.5, topY+20, pin_size.width, pin_size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:_attDic context:nil];
            
            [hans drawWithRect:CGRectMake(centerX-Han_size.width*.5, topY+pin_size.height+VER_MARGIN+20 , Han_size.width, Han_size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:_attDic context:nil];
            
            col++;
        }
}
}
+ (CGFloat)heightForPins:(NSArray *)pins hans:(NSArray *)Hans attibutes:(NSDictionary *)attDic width:(CGFloat)label_width
{
    NSInteger row = 0;
    NSInteger col = 0;
    CGFloat labelHeight = .0f;
    CGFloat right = .0f;
    CGFloat lastHeight = .0f;
    
    CGFloat max_height_min = .0f;
    if(pins.count == Hans.count)
    {
        NSInteger count = pins.count;
        for(NSInteger i = 0;i<count;i++)
        {
            NSString *pinYin = pins[i];
            NSString *hans = Hans[i];
            CGSize pin_size = [pinYin sizeWithAttributes:attDic];
            CGSize Han_size = [hans sizeWithAttributes:attDic];
            CGFloat width = MAX(pin_size.width, Han_size.width);
            
            max_height_min = pin_size.height+Han_size.height+2*VER_MARGIN + 20;
            right +=HORI_MARGIN + width;
            if(right>label_width)
            {
                row++;
                col = 0;
                
                labelHeight +=pin_size.height+Han_size.height+2*VER_MARGIN + 20;
                lastHeight = pin_size.height+Han_size.height+2*VER_MARGIN;
                right = .0f;
                right +=HORI_MARGIN + width;
            }
            
            col++;
        }
        labelHeight += lastHeight;
        return  MAX(max_height_min, labelHeight);
      }
    return .0f;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self setNeedsDisplay];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame fillWithPinYins:(NSArray *)pins Hans:(NSArray *)hans attibutes:(NSDictionary *)attDic
{
    self = [self initWithFrame:frame];
    
    if(pins && hans && pins.count>0 && hans.count>0)
    {
        self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.Pins = pins;
        self.hans = hans;
        self.attDic = attDic;
        
        [self setNeedsDisplay];
    }
    return self;
}
- (void)fillWithPinYins:(NSArray *)pins Hans:(NSArray *)hans attibutes:(NSDictionary *)attDic
{
    if(pins && hans && pins.count>0 && hans.count>0)
    {
        self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.Pins = pins;
        self.hans = hans;
        self.attDic = attDic;
        
        [self setNeedsDisplay];
    }
   
}
@end
