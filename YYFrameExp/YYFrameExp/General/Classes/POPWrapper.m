//
//  POPWrapper.m
//  jimao
//
//  Created by Dongle Su on 15-4-1.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "POPWrapper.h"
#import <POP/POP.h>
#import <POP/POPLayerExtras.h>
#import <math.h>

@interface POPWrapper()
@property (nonatomic) CGFloat popAnimationProgress;
@end


@implementation POPWrapper{
    void(^_progressBlock)(CGFloat progress);
}

- (void)togglePopAnimation:(BOOL)on progressBlock:(void (^)(CGFloat progress))progressBlock completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock {
    POPSpringAnimation *animation = [self pop_animationForKey:@"popAnimation"];
    
    _progressBlock = progressBlock;
    
    if (!animation) {
        animation = [POPSpringAnimation animation];
        animation.springBounciness = 8;
        animation.springSpeed = 20;
        animation.property = [POPAnimatableProperty propertyWithName:@"popAnimationProgress" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(POPWrapper *obj, CGFloat values[]) {
                values[0] = obj.popAnimationProgress;
            };
            prop.writeBlock = ^(POPWrapper *obj, const CGFloat values[]) {
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
    
    if (_progressBlock) {
        _progressBlock(progress);
    }
}

@end
