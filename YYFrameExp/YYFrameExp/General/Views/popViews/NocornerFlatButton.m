//
//  NocornerFlatButton.m
//  jimao
//
//  Created by pan chow on 15/1/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "NocornerFlatButton.h"
#import <POP/POP.h>

@implementation NocornerFlatButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)button
{
    return [self buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    
    if(self)
    {
        [self setupFromNib];
    }
    return self;
}
#pragma mark - Instance methods

//- (UIEdgeInsets)titleEdgeInsets
//{
//    return UIEdgeInsetsMake(4.f,
//                            28.f,
//                            4.f,
//                            28.f);
//}

- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    
    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
}

#pragma mark - Private instance methods

- (void)setup
{
    self.backgroundColor = self.tintColor;
    self.layer.cornerRadius = 4.f;
    [self setTitleColor:[UIColor whiteColor]
               forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium"
                                           size:22];
    
    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit];
}
- (void)setupFromNib
{
    self.layer.cornerRadius = .0f;
    
    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit];
}
- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.2f, 2.2f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 14.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}


#pragma mark --- public ---
- (void)redEnable:(BOOL)isEnable
{
    //    if(self.enabled == isEnable)
    //    {
    //        return;
    //    }
    self.enabled=isEnable;
    
    if(isEnable)
    {
        self.backgroundColor=rgb(225, 75, 78);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        self.backgroundColor=rgb(168, 168, 168);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (void)grayInTaskEnable:(BOOL)isEnable
{
    //    if(self.enabled == isEnable)
    //    {
    //        return;
    //    }
    self.enabled=isEnable;
    
    if(isEnable)
    {
        self.backgroundColor=rgb(168, 168, 168);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        self.backgroundColor=rgb(168, 168, 168);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (void)grownEnable:(BOOL)isEnable
{
    self.enabled=isEnable;
    
    if(isEnable)
    {
        self.backgroundColor=rgb(253, 138, 38);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        self.backgroundColor=rgb(168, 168, 168);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}
- (void)whitBorderEnable:(BOOL)isEnable
{
    self.enabled=isEnable;
    
    if(isEnable)
    {
        self.backgroundColor=[UIColor clearColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        NSArray *colors = @[[UIColor redColor],[UIColor whiteColor]];
        self.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.bounds andColors:colors];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    else
    {
        [self setTitleColor:rgb(168, 168, 168) forState:UIControlStateNormal];
    }
}
- (void)grayEnable:(BOOL)isEnable
{
    self.enabled=isEnable;
    
    if(isEnable)
    {
        self.backgroundColor=rgb(186, 186, 186);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //        self.backgroundColor=rgb(220, 219, 217);
        //        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    else
    {
        //        self.backgroundColor=rgb(220, 219, 217);
        //        [self setTitleColor:rgb(181, 180, 178) forState:UIControlStateNormal];
        self.backgroundColor=rgb(186, 186, 186);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


@end
