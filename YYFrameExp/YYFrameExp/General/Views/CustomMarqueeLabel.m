//
//  CustomMarqueeLabel.m
//  Demo
//
//  Created by pan zhou on 13-3-21.
//  Copyright (c) 2013年 pan zhou. All rights reserved.
//

#import "CustomMarqueeLabel.h"
#import <QuartzCore/QuartzCore.h>
#define SCROLL_SPEED 50.0f
#define LABEL_SPACE 25.0f


@implementation CustomMarqueeLabel

- (void)dealloc
{

}
#pragma mark -----系统方法----
- (id)init
{
    self=[super init];
    if(self)
    {
        [self initMarqueeLabel];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        [self initMarqueeLabel];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMarqueeLabel];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame byScrollSpeed:(float)anSpeed
{
    self=[self initWithFrame:frame];
    if(self)
    {
        scrollSpeed=anSpeed;
    }
    return self;
}
#pragma mark ---private---
/**
 *	@brief	初始化速率参数，以及backScrollView，label等相关subViews
 */
- (void)initMarqueeLabel

{
    scrollSpeed=0.0f;
    backScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backScrollView.backgroundColor=[UIColor clearColor];
    backScrollView.showsHorizontalScrollIndicator=NO;
    backScrollView.showsVerticalScrollIndicator=NO;
    backScrollView.userInteractionEnabled=NO;
    [self addSubview:backScrollView];
    
    frontLB=[self settingLabel];
    [backScrollView addSubview:frontLB];
    behindLB=[self settingLabel];
    [backScrollView addSubview:behindLB];
}
/**
 *	@brief	设定Label子视图的默认属性
 *
 *	@return	设置好的一个子视图Label
 */
- (ImageLabel *)settingLabel

{
    ImageLabel *anLB=[[ImageLabel alloc] initWithFrame:CGRectMake(0, 0, 0, backScrollView.frame.size.height)];
    anLB.textColor=[UIColor whiteColor];
    anLB.backgroundColor=[UIColor clearColor];
    return anLB;
}
/**
 *	@brief	重置子视图Label
 *
 *	@param 	anLabel 	需要重置的Label
 */
- (void)resetLabel:(UILabel *)anLabel

{
    anLabel.frame=CGRectMake(0, 0, 0, backScrollView.frame.size.height);
}
#pragma mark ---scroll---
/**
 *	@brief	使能文本内容滚动
 */
- (void)scrollLabel
//
{
    if(_permitScrolling)
    {
        backScrollView.contentOffset=CGPointMake(0, 0);
        NSTimeInterval interval=frontLB.frame.size.width/(scrollSpeed <= 0.0f ? SCROLL_SPEED :scrollSpeed);
        [UIView animateWithDuration:interval delay:delayInterval options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionOverrideInheritedDuration) animations:^{
            backScrollView.contentOffset = CGPointMake(frontLB.frame.origin.x + frontLB.frame.size.width+LABEL_SPACE,0);
        } completion:^(BOOL finished) {
            delayInterval=.0f;
            [self scrollLabel];
        }];
    }
    
}
#pragma mark ---engin--
/**
 *	@brief	获取当前的文本内容
 *
 *	@return	文本内容
 */
- (NSString *)text

{
    return frontLB.text;
}
/**
 *	@brief	text文本的setter属性重写，根据文本内容判断是否滚动
 *
 *	@param 	aText 	要显示的文本内容
 */
- (void)setText:(NSString *)aText
{
    [self setText:aText compare:YES];
}
#pragma mark ---public---
- (void)setTextColor:(UIColor *)color font:(UIFont *)font 
{
    if(color){[self setTextColor:color];}
    if(font){frontLB.font=font;behindLB.font=font;}    
}
- (void)setTextColor:(UIColor *)textColor
{
    frontLB.textColor=textColor;
    behindLB.textColor=textColor;
}
/**
 *	@brief	permitScrolling的setter属性重写
 *
 *	@param 	aPermitScrolling 	布尔值，使能滚动
 */
- (void)setPermitScrolling:(BOOL)aPermitScrolling

{
    //aPermitScrolling=NO;
    if(_permitScrolling != aPermitScrolling)
    {
        _permitScrolling=aPermitScrolling;
        if(aPermitScrolling && (frontLB.frame.size.width>backScrollView.frame.size.width))
        {
            delayInterval=0.0f;
            [self scrollLabel];
        }
    }
}
//add
- (void)setTextColor:(UIColor *)TtColor backColor:(UIColor *)bkColor
{
    if(frontLB.textColor!=TtColor || self.backgroundColor!=bkColor)
    {
        [self setTextColor:TtColor];
        [self setBackgroundColor:bkColor];
    }
}
- (void)setFontSize:(CGFloat)fontSize
{
    frontLB.font=[UIFont fontWithName:@"Helvetica" size:fontSize];
    behindLB.font=[UIFont fontWithName:@"Helvetica" size:fontSize];
    
    [self setText:frontLB.text compare:NO];
}
- (void)setText:(NSString *)aText compare:(BOOL)isCompare
{
    [backScrollView.layer removeAllAnimations];
    [UIView commitAnimations];
    if(!isCompare || ![frontLB.text isEqualToString:aText])
    {
        frontLB.text=aText;
        [self reSizeLabel:frontLB];
        behindLB.text=aText;
        [self reSizeLabel:behindLB];
        
        [self setupScroll];
    }

}
- (void)setupScroll{
    [backScrollView setContentOffset:CGPointMake(0,0) animated:NO];
    if(frontLB.frame.size.width>backScrollView.frame.size.width)
    {
        frontLB.frame = CGRectMake(0, frontLB.top, frontLB.width, frontLB.height);
        behindLB.hidden=NO;
        CGRect frame=behindLB.frame;
        frame.origin.x=frontLB.frame.size.width + frontLB.frame.origin.x + LABEL_SPACE;
        behindLB.frame=frame;
        [self setPermitScrolling:YES];
    }
    else
    {
        behindLB.hidden=YES;
        _permitScrolling=NO;
        CGPoint center=frontLB.center;
        center.x=backScrollView.center.x-backScrollView.frame.origin.x;
        frontLB.center=center;
    }
}
- (void)setSpeed:(float)anSpeed
{
    if(anSpeed != scrollSpeed)
    {
        scrollSpeed=anSpeed;
        [self setText:frontLB.text compare:NO];
    }
}
- (void)setTailImage:(UIImage *)image{
    [frontLB setTailImage:image];
    [behindLB setTailImage:image];
    
    [self reSizeLabel:frontLB];
    [self reSizeLabel:behindLB];

    [self setupScroll];
}
//add
//- (void)setTextContent:(NSString *)anString
//{
//    [UIView  setAnimationsEnabled:NO];
//    [self resetLabel:frontLB];
//    [self resetLabel:behindLB];
//    
//    frontLB.text=anString;
//    [self reSizeLabel:frontLB];
//    behindLB.text=anString;
//    [self reSizeLabel:behindLB];
//    
//    [backScrollView setContentOffset:CGPointMake(0,0) animated:NO];
//    if(frontLB.frame.size.width>backScrollView.frame.size.width)
//    {
//        behindLB.hidden=NO;
//        CGRect frame=behindLB.frame;
//        frame.origin.x=frontLB.frame.size.width + LABEL_SPACE;
//        behindLB.frame=frame;
//        [UIView setAnimationsEnabled:YES];
//        [self setPermitScrolling:YES withDelay:.0f];
//    }
//    else
//    {
//        behindLB.hidden=YES;
//        _permitScrolling=NO;
//        CGPoint center=frontLB.center;
//        center.x=backScrollView.center.x-backScrollView.frame.origin.x;
//        frontLB.center=center;
//    }
//}
//

//- (void)setScrollSpeed:(float)anSpeed
//{
//    if(anSpeed !=scrollSpeed)
//    {
//        scrollSpeed=anSpeed;
//    }
//}
///**
// *	@brief	permitScrolling的setter属性重写
// *
// *	@param 	aPermitScrolling 	布尔值，使能滚动
// */
//
//- (void)setPermitScrolling:(BOOL)aPermitScrolling withDelay:(NSTimeInterval)delay
//{
//    if(_permitScrolling != aPermitScrolling)
//    {
//        _permitScrolling=aPermitScrolling;
//        if(aPermitScrolling && (frontLB.frame.size.width>backScrollView.frame.size.width))
//        {
//            delayInterval=delay;
//            [self scrollLabel];
//        }
//    }
//    
//}

//---
/**
 *	@brief	根据文本内容，设置子视图Label的大小
 *
 *	@param 	label 	子视图Label
 */
- (void)reSizeLabel:(UILabel *)label

{
//    [label sizeToFit];
    CGSize size = [label sizeThatFits:CGSizeMake(10000, label.bounds.size.height)];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,size.width, label.bounds.size.height);
//    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(10000,label.bounds.size.width) lineBreakMode:label.lineBreakMode];
//    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,size.width,label.bounds.size.height);
}
@end
