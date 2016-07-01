//
//  ASCIImageHelper.m
//  jimao
//
//  Created by pan chow on 15/5/15.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "ASCIImageHelper.h"

#import <ASCIImage/PARImage+ASCIIInput.h>

@implementation ASCIImageHelper

+ (UIImage *)getASCIImg
{
    NSArray *asciiRepresentation =
  @[
    @"···12·····",
    @"···A##····",
    @"····###···",
    @"·····###··",
    @"······9#3·",
    @"······8#4·",
    @"·····###··",
    @"····###···",
    @"···7##····",
    @"···65·····",
    ];
    return [UIImage imageWithASCIIRepresentation:asciiRepresentation color:[UIColor redColor] shouldAntialias:NO];
}
+ (UIImage *)getAdvansASCIImg
{
    NSArray *asciiRepresentation =
    @[
      @"···12·····",
      @"···A##····",
      @"····###···",
      @"·····###··",
      @"······9#3·",
      @"······8#4·",
      @"·····###··",
      @"····###···",
      @"···7##····",
      @"···65·····",
      ];
    return [UIImage imageWithASCIIRepresentation:asciiRepresentation scaleFactor:30 color:[UIColor redColor] shouldAntialias:NO];
}
+ (UIImage *)getDicASCIImg
{
    NSArray *asciiRepresentation =
    @[
      @"···12·····",
      @"···A##····",
      @"····###···",
      @"·····###··",
      @"······9#3·",
      @"······8#4·",
      @"·····###··",
      @"····###···",
      @"···7##····",
      @"···65·····",
      ];
    return [UIImage imageWithASCIIRepresentation:asciiRepresentation contextHandler:^(NSMutableDictionary *context) {
        [context setObject:@0 forKey:ASCIIContextShapeIndex];
        [context setObject:[UIColor redColor] forKey:ASCIIContextFillColor];
        [context setObject:[UIColor brownColor] forKey:ASCIIContextStrokeColor];
        [context setObject:@.1 forKey:ASCIIContextLineWidth];
        [context setObject:@YES forKey:ASCIIContextShouldClose];
        [context setObject:@NO forKey:ASCIIContextShouldAntialias];
    }];
    return [UIImage imageWithASCIIRepresentation:asciiRepresentation scaleFactor:50 color:[UIColor redColor] shouldAntialias:NO];
}
+ (UIImage *)getArrowASCIImg
{
    return [UIImage arrowImageWithColor:[UIColor redColor]];
}
+ (UIImage *)getChevroneonASCIImg
{
    return [UIImage chevronImageWithColor:[UIColor redColor]];
}
@end
