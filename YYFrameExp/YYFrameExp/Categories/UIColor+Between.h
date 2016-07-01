//
//  UIColor+Between.h
//  jimao
//
//  Created by Dongle Su on 15/8/3.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Between)
+ (UIColor *)colorBetween:(UIColor *)color1 and:(UIColor *)color2 percent:(CGFloat)percent;
@end
