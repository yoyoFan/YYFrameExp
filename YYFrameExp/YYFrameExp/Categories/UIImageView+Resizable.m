//
//  UIImageView+Resizable.m
//  jimao
//
//  Created by pan chow on 14/11/26.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UIImageView+Resizable.h"

@implementation UIImageView (Resizable)

- (void)resizaleImg:(UIImage *)img insets:(UIEdgeInsets)insets
{
    img=[img resizableImageWithCapInsets:insets];
    self.image=img;
}
@end
