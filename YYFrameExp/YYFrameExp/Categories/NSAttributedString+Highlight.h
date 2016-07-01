//
//  NSAttributedString+Highlight.h
//  jimao
//
//  Created by Dongle Su on 15-4-13.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Highlight)
+ (instancetype)attributeStringWithString:(NSString *)string highlight:(NSString *)highlight highlightColor:(UIColor *)highlightColor;
- (NSAttributedString *)attributedStringWithHighlight:(NSString *)highlight highlightColor:(UIColor *)highlightColor;
;
@end
