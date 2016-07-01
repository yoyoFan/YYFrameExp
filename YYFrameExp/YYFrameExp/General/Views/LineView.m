//
//  LineView.m
//  jimao
//
//  Created by fwr on 15/9/23.
//  Copyright © 2015年 etuo. All rights reserved.
//

#import "LineView.h"

#define kLineColor  [UIColor colorFromHexString:@"#FC8A04"].CGColor

@implementation LineView

-(void)addLineWithLineType:(LineViewType)type
{
    if(type & LineViewTypeTop)
    {
        CALayer *layer= [CALayer layer];
        layer.backgroundColor = kLineColor;
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), .5);
        [self.layer addSublayer:layer];
    }
    
    if(type & LineViewTypeLeft)
    {
        CALayer *layer= [CALayer layer];
        layer.backgroundColor = kLineColor;
        layer.frame = CGRectMake(0, 0, .5, CGRectGetHeight(self.bounds));
        [self.layer addSublayer:layer];
    }
    
    if(type & LineViewTypeBottom)
    {
        CALayer *layer= [CALayer layer];
        layer.backgroundColor = kLineColor;
        layer.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), .5);
        [self.layer addSublayer:layer];
    }
    
    if(type & LineViewTypeRight)
    {
        CALayer *layer= [CALayer layer];
        layer.backgroundColor = kLineColor;
        layer.frame = CGRectMake( CGRectGetWidth(self.bounds), 0, .5, CGRectGetHeight(self.bounds));
        [self.layer addSublayer:layer];
    }
}

@end
