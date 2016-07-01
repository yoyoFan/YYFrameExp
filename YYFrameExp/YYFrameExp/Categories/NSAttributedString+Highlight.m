//
//  NSAttributedString+Highlight.m
//  jimao
//
//  Created by Dongle Su on 15-4-13.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "NSAttributedString+Highlight.h"
#import <Foundation/NSRegularExpression.h>

@implementation NSAttributedString (Highlight)
+ (instancetype)attributeStringWithString:(NSString *)string highlight:(NSString *)highlight highlightColor:(UIColor *)highlightColor{
    NSArray* results = [[[NSRegularExpression alloc] initWithPattern:highlight options:0 error:nil] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSMutableAttributedString *attribText = [[NSMutableAttributedString alloc] initWithString:string];
    [attribText beginEditing];
    for(NSTextCheckingResult *result in results)
    {
        [attribText addAttribute:NSForegroundColorAttributeName value:highlightColor range:result.range];
    }
    [attribText endEditing];
    return attribText;
}
- (NSAttributedString *)attributedStringWithHighlight:(NSString *)highlight highlightColor:(UIColor *)highlightColor
{
    NSArray* results = [[[NSRegularExpression alloc] initWithPattern:highlight options:0 error:nil] matchesInString:self.string options:0 range:NSMakeRange(0, self.string.length)];
    
    NSMutableAttributedString *attribText = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    [attribText beginEditing];
    for(NSTextCheckingResult *result in results)
    {
        [attribText addAttribute:NSForegroundColorAttributeName value:highlightColor range:result.range];
    }
    [attribText endEditing];
    return attribText;
}
@end
