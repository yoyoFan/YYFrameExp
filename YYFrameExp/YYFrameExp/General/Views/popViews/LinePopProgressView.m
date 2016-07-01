//
//  LinePopProgressView.m
//  jimao
//
//  Created by pan chow on 14/11/27.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "LinePopProgressView.h"

@interface LinePopProgressView ()
{
    NSLayoutConstraint *beforeConstraint;
    NSLayoutConstraint *afterConstraint;
}
@property (nonatomic,weak)UIView *onView;
@property (nonatomic,strong)UIView *frontView;
@end

@implementation LinePopProgressView

SINGLETON_GCD(LinePopProgressView);


# pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

# pragma mark - Public

- (void)showProgressUponView:(UIView *)view {
    self.onView=view;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = @(-self.frame.size.width);
    animation.toValue = @(self.frame.size.width * 2);
    animation.duration = 1.2f;
    animation.fillMode = kCAFillModeBoth;
    animation.repeatCount = INFINITY;
    
    [_frontView.layer addAnimation:animation forKey:@"animation"];
    
    
    
    UIView *dView=view.superview;
    if(dView)
    {
        [dView addSubview:self];
    }
    else
    {
        dView=view;
        [dView addSubview:self];
    }
    [self lyt_setWidth:view.width];
    [self lyt_alignLeftToParent];
    
    beforeConstraint=[self lyt_constraintBySettingHeight:0];
    [self addConstraint:beforeConstraint];
    [self updateConstraintsIfNeeded];//---
    [self removeConstraint:beforeConstraint];
    
    afterConstraint=[self lyt_constraintBySettingHeight:_height];
    [self addConstraint:afterConstraint];
    
    [UIView animateWithDuration:0.3f animations:^ {
        [self updateConstraintsIfNeeded];//--
    }];
}

- (void)hideProgressView
{
    [self removeConstraint:afterConstraint];
    [self addConstraint:beforeConstraint];
    
    [UIView animateWithDuration:0.3f animations:^ {
        [self updateConstraintsIfNeeded];
    }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         self.onView=nil;
                     }];
}


# pragma mark - Initialization

- (void)initialize
{
    self.frontView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_frontView];
    
    self.translatesAutoresizingMaskIntoConstraints=NO;
    self.frontView.translatesAutoresizingMaskIntoConstraints=NO;
    [_frontView lyt_alignToParent];
    [self updateConstraintsIfNeeded];
    
     self.height = 50.0f;
    
    self.backColor = [UIColor blackColor];
    self.color=[UIColor redColor];
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor=backColor;
    self.backgroundColor=backColor;
}
- (void)setColor:(UIColor *)color
{
    _color=color;
    self.frontView.backgroundColor=_color;
}
- (void)setGradientColors:(NSArray *)gradientColors
{
    _gradientColors=gradientColors;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _frontView.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(_frontView.bounds.size.width, 0);
    gradient.colors = _gradientColors;
    
    [_frontView.layer insertSublayer:gradient atIndex:0];
    SLog(@"%@",_frontView.layer.sublayers);
}
@end
