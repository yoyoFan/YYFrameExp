//
//  UILabel+Html.h
//  jimao
//
//  Created by Dongle Su on 15/8/4.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Html)
- (void)setHtml:(NSString *)htmlString defaultColor:(UIColor *)defaultColor;
- (void)setHtml:(NSString *)htmlString defaultColor:(UIColor *)defaultColor defaultFont:(CGFloat)fontSize;
@end
