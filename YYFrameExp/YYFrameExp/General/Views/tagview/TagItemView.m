//
//  TagItemView.m
//  FlowExp
//
//  Created by pan chow on 14-4-30.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "TagItemView.h"

#define x_Margin 10.0f
#define y_Margin 10.0f

@interface TagItemView ()
{
    UILabel *_lb;
    UIImageView *_deleImgView;
    
   
}
@end
@implementation TagItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled=YES;
        self.shaked=NO;
        self.permitLongPress=NO;
//        UILongPressGestureRecognizer *lp=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//        lp.minimumPressDuration=.6f;
//        [self addGestureRecognizer:lp];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        [self removeConstraints:self.constraints];
    }
    return self;
}
- (void)longPress:(UILongPressGestureRecognizer *)lp
{
    if(!_permitLongPress)
    {
        return;
    }
    if(!_shaked)
    {
        //抖动
        _shaked=YES;
        if([self.delegate respondsToSelector:@selector(tagItemViewLongPressed:toShake:)])
        {
            [_delegate tagItemViewLongPressed:self toShake:YES];
        }
    }
}
- (void)tap:(UITapGestureRecognizer *)tap
{
    if(!_shaked)
    {
        if([self.delegate respondsToSelector:@selector(tagItemViewPressed:)])
        {
            [_delegate tagItemViewPressed:self];
        }
    }
    if(!_permitLongPress)
    {
        return;
    }
    if(_shaked)
    {
        _shaked=NO;
        if([self.delegate respondsToSelector:@selector(tagItemViewLongPressed:toShake:)])
        {
            [_delegate tagItemViewLongPressed:self toShake:NO];
        }
    }
}
- (void)shake
{
    [_deleImgView setHidden:NO];
    _shaked=YES;
    
    CGFloat rotation = 0.03;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
}
- (void)stopShake
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    [_deleImgView setHidden:YES];
    _shaked=NO;
}
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}
- (void)setTitle:(NSString *)title colors:(NSDictionary *)color
{
    
    _lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
    _lb.numberOfLines=0;
    _lb.textAlignment=NSTextAlignmentCenter;
    _lb.font=[UIFont systemFontOfSize:15.0f];
    _lb.backgroundColor=color[@"back"];
    _lb.layer.borderColor=[color[@"border"] CGColor];
    _lb.layer.borderWidth=.5f;
    _lb.textColor=color[@"text"];
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:_lb.textColor];
    NSInteger rIndex=components[0]*100;
    CGSize size = [title sizeWithFont:_lb.font constrainedToSize:CGSizeMake(100, _lb.bounds.size.height) lineBreakMode:_lb.lineBreakMode];
    _lb.frame = CGRectMake(_lb.left,_lb.top, size.width+2, _lb.height);
    _lb.text=title;
    [self addSubview:_lb];
    [self setFrame:CGRectMake(0, 0, _lb.width, self.height)];//+5
    
    /*
    _deleImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete.png"]];
    _deleImgView.frame=CGRectMake(_lb.right-15, _lb.top-5, 20, 20);
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItem:)];
    _deleImgView.userInteractionEnabled=YES;
    [_deleImgView addGestureRecognizer:tap];
    [self addSubview:_deleImgView];
    [_deleImgView setHidden:YES];
     */
    if(_permitLongPress)
    {
         [self setFrame:CGRectMake(0, 0, _lb.width+23, self.height)];//+5
        
        UILabel *delLB=[[UILabel alloc] initWithFrame:CGRectMake(_lb.right, _lb.top, 23, _lb.height)];
        delLB.textAlignment=NSTextAlignmentCenter;
        delLB.font=[UIFont systemFontOfSize:15.0f];
        delLB.backgroundColor=color[@"back"];
        delLB.layer.borderColor=[color[@"border"] CGColor];
        delLB.layer.borderWidth=.5f;
        delLB.textColor=color[@"border"];
        
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItem:)];
        delLB.userInteractionEnabled=YES;
//        [delLB addGestureRecognizer:tap];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=delLB.bounds;
        UIImage *img=nil;
        UIImage *hImg=nil;
        if(rIndex==49)
        {
            img=[UIImage imageNamed:@"del1.png"];
            hImg=[UIImage imageNamed:@"delc1.png"];
        }
        else if(rIndex==27)
        {
            img=[UIImage imageNamed:@"del2.png"];
            hImg=[UIImage imageNamed:@"delc2.png"];
        }
        else
        {
            img=[UIImage imageNamed:@"del3.png"];
            hImg=[UIImage imageNamed:@"delc3.png"];
        }
        [btn setImage:img forState:UIControlStateNormal];
        [btn setImage:hImg forState:UIControlStateHighlighted];
        btn.backgroundColor=[UIColor clearColor];
        [btn addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        [delLB addSubview:btn];
        
        [self addSubview:delLB];
    }
}
- (void)deleteItem:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(tagItemViewDeleteBtnPressed:)])
    {
        [_delegate tagItemViewDeleteBtnPressed:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
