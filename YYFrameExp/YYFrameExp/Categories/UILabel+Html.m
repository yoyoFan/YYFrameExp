//
//  UILabel+Html.m
//  jimao
//
//  Created by Dongle Su on 15/8/4.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "UILabel+Html.h"
#import "DTCoreText.h"

@implementation UILabel (Html)
- (void)setHtml:(NSString *)htmlString defaultColor:(UIColor *)defaultColor{
    [self setHtml:htmlString defaultColor:defaultColor defaultFont:.0];
}

- (void)setHtml:(NSString *)htmlString defaultColor:(UIColor *)defaultColor defaultFont:(CGFloat)fontSize{
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    CGFloat fontSizeMultiplier = 1.0f;
    CGFloat const DTCoreTextDefaultFontSize = fontSize > .0 ? fontSize : 11.0f;
    NSString * fontName = @"Helvetica";
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    //[NSNumber numberWithFloat:fontSizeMultiplier], NSTextSizeMultiplierDocumentOption,
                                    [NSNumber numberWithFloat:DTCoreTextDefaultFontSize], DTDefaultFontSize,
                                    defaultColor, DTDefaultTextColor,
                                    fontName, DTDefaultFontFamily,
                                    @"purple", DTDefaultLinkColor,
                                    @"red", DTDefaultLinkHighlightColor,
                                    [NSNumber numberWithBool:YES],DTUseiOS6Attributes,
                                    nil];
    
    //        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                        NSHTMLTextDocumentType, NSDocumentTypeDocumentAttribute,
    //                                        [NSNumber numberWithInteger:NSUTF8StringEncoding], NSCharacterEncodingDocumentAttribute,
    //                                        nil];
    //    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:nil];
    self.attributedText = attrString;
}
@end
