//
//  UIView+MyAnimation.h
//  jimao
//
//  Created by Dongle Su on 14-12-3.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MyAnimation)
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated duration:(CGFloat)duration completion:(void(^)(BOOL finished))completion;
- (void)setHidden:(BOOL)hidden afterDuration:(int)after animated:(BOOL)animated duration:(CGFloat)duration;
@end
