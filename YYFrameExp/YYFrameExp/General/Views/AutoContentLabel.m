//
//  AutoContentLabel.m
//  jimao
//
//  Created by pan chow on 15/1/9.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "AutoContentLabel.h"

@implementation AutoContentLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    
    return CGSizeMake(s.width ,s.height>30 ? s.height : 30);
    
}
@end
