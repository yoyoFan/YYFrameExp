//
//  MyPopupView.m
//  jimao
//
//  Created by Dongle Su on 15-3-13.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "MyPopupView.h"
#import <POP/POP.h>
#import <POP/POPLayerExtras.h>

#define PI 3.14159265

@interface MyPopupView ()
@property (nonatomic) CGFloat popAnimationProgress;

@end

@implementation MyPopupView{
    void(^onButtonClicked_)(MyPopupView * popupView, int button);
}

+ (MyPopupView *)popupInView:(UIView *)view
                       title:(NSString *)title
                       content:(NSString *)content
                       leftButtonTitle:(NSString *)leftButton
                       rightButtonTitle:(NSString *)rightButton
             onButtonClicked:(void(^)(MyPopupView * popupView, int button))onClicked{
    MyPopupView *popView = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] firstObject];
    popView.titleLabel.text = title;
    popView.contentLabel.text = content;
    [popView.leftButton setTitle:leftButton forState:UIControlStateNormal];
    [popView.rightButton setTitle:rightButton forState:UIControlStateNormal];
    popView->onButtonClicked_ = onClicked;
    
    
    popView.alpha = .0f;
    popView.frame = view.bounds;
    [view addSubview:popView];
//    [UIView animateWithDuration:0.3 animations:^{
//        popView.alpha = 1.0f;
//    } completion:^(BOOL finished) {
//        
//    }];
    [popView togglePopAnimation:YES completionBlock:nil];
    return popView;
}

- (void)dismiss{
    [self togglePopAnimation:NO completionBlock:^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
    }];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0.0f;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
}
- (void)togglePopAnimation:(BOOL)on completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock {
    POPSpringAnimation *animation = [self pop_animationForKey:@"popAnimation"];

    if (!animation) {
        animation = [POPSpringAnimation animation];
        animation.springBounciness = 5;
        animation.springSpeed = 10;
        animation.property = [POPAnimatableProperty propertyWithName:@"popAnimationProgress" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(MyPopupView *obj, CGFloat values[]) {
                values[0] = obj.popAnimationProgress;
            };
            prop.writeBlock = ^(MyPopupView *obj, const CGFloat values[]) {
                obj.popAnimationProgress = values[0];
            };
            prop.threshold = 0.001;
        }];
        
        [self pop_addAnimation:animation forKey:@"popAnimation"];

    }
    animation.completionBlock = completionBlock;
    animation.toValue = on ? @(1.0) : @(0.0);
}

- (void)setPopAnimationProgress:(CGFloat)progress {
    _popAnimationProgress = progress;
    
    CGFloat transition = POPTransition(progress, 0, 1);
    CGFloat transitionScale = POPTransition(progress, 0, 2*PI);

    CGAffineTransform t = CGAffineTransformMakeScale(transition, transition);
    t = CGAffineTransformRotate(t, transitionScale);
    self.confirmView.transform = t;
    self.alpha = transition;
    
    // bug of pop on ios7.1
//    POPLayerSetScaleXY(self.confirmView.layer, CGPointMake(transition, transition));
//    self.layer.opacity = transition;
//    POPLayerSetRotationZ(self.confirmView.layer, transitionScale);
}

// Utilities

static inline CGFloat POPTransition(CGFloat progress, CGFloat startValue, CGFloat endValue) {
    return startValue + (progress * (endValue - startValue));
}

- (IBAction)closeTaped:(id)sender {
    if (onButtonClicked_) {
        onButtonClicked_(self, 0);
    }
}

- (IBAction)leftButtonTaped:(id)sender {
    if (onButtonClicked_) {
        onButtonClicked_(self, 1);
    }
}

- (IBAction)rightButtonTaped:(id)sender {
    if (onButtonClicked_) {
        onButtonClicked_(self, 2);
    }
}
@end
