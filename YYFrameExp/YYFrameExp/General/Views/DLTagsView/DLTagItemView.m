//
//  DLTagItemView.m
//  tagViewTest
//
//  Created by Dongle Su on 15/8/3.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "DLTagItemView.h"

@implementation DLTagItemView

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    //UIBezierPath *path
    self.layer.borderColor = self.borderColor ? self.borderColor.CGColor : self.textColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.textAlignment = NSTextAlignmentCenter;
    self.clipsToBounds = YES;
}

- (void)setTextColor:(UIColor *)textColor{
    [super setTextColor:textColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.height/2.0f;
}

- (CGSize)intrinsicContentSize{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + kDLTagItemMarginX*2, size.height + kDLTagItemMarginY*2);
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize ret = [super sizeThatFits:size];
    return CGSizeMake(ret.width + kDLTagItemMarginX*2, ret.height + kDLTagItemMarginY*2);
}
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}
@end
