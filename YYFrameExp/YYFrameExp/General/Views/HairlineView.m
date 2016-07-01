//
//  HairlineView.m
//  dynamicTest
//
//  Created by Dongle Su on 15/7/22.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "HairlineView.h"

@implementation HairlineView{
}
//-(void)awakeFromNib {
//}

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
    self.layer.borderColor = [self.backgroundColor CGColor];
    self.layer.borderWidth = (1.0 / [UIScreen mainScreen].scale) / 2;
    
    [super setBackgroundColor:[UIColor clearColor]];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.layer.borderColor = [backgroundColor CGColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
