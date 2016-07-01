//
//  UpDownPopBtn.m
//  jimao
//
//  Created by pan chow on 14/11/26.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UpDownPopBtn.h"
#import <POP/POP.h>

@implementation UpDownPopBtn

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
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isImageSizeSameWithButton) {
        self.imageView.frame = self.bounds;
    }
}

//- (UIEdgeInsets)titleEdgeInsets
//{
//    return UIEdgeInsetsMake(55.f,
//                            -80.f,
//                            0.f,
//                            0.f);
//}
//- (UIEdgeInsets)imageEdgeInsets
//{
//    return UIEdgeInsetsMake(-14.f,
//                            0.f,
//                            20.f,
//                            0.f);
//}
//- (CGSize)intrinsicContentSize
//{
//    CGSize s = [super intrinsicContentSize];
//    
//    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
//                      s.height + self.titleEdgeInsets.top + self.imageEdgeInsets.bottom);
//    
//}

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
    self.layer.cornerRadius = 4.f;
//        self.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium"
//                                               size:22];
    self.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
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
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}


@end
