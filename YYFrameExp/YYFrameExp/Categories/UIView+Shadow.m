//
//  UIView+Shadow.m
//  jimao
//
//  Created by Dongle Su on 15/8/14.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)
- (void)addShadow{
    CALayer *layer = self.layer;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
    layer.shadowPath = path.CGPath;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.4f;
    layer.shadowRadius = 8.0f;
}

- (void)removeShadow{
    CALayer *layer = self.layer;
    layer.shadowPath = nil;
    layer.shadowColor = nil;
}
@end
