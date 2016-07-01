//
//  UIView+MyAnimation.m
//  jimao
//
//  Created by Dongle Su on 14-12-3.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UIView+MyAnimation.h"
#define kHiddenDuration 2.0

@implementation UIView (MyAnimation)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated duration:(CGFloat)duration completion:(void(^)(BOOL finished))completion{
    self.hidden = NO;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = hidden ? 0.0f : 1.0f;
    } completion:^(BOOL finished) {
        self.hidden = hidden;
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)setHidden:(BOOL)hidden afterDuration:(int)after animated:(BOOL)animated duration:(CGFloat)duration{
    dispatch_time_t trigerTime = dispatch_time(DISPATCH_TIME_NOW, after * NSEC_PER_SEC);
    dispatch_after(trigerTime, dispatch_get_main_queue(), ^(void){
        [self setHidden:hidden animated:animated duration:duration completion:nil];
    });

}
@end
