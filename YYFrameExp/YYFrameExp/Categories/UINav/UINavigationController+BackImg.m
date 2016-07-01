//
//  UINavigationController+BackImg.m
//  ImgDemo
//
//  Created by pan chow on 14/11/3.
//  Copyright (c) 2014年 pan chow. All rights reserved.
//

#import "UINavigationController+BackImg.h"

@implementation UINavigationController (BackImg)

- (void)setNavigationBarBackgroundImage:(UIImage *)image
{
    if (!image)
        return;
    //    image = [image resizeImageWithNewSize:CGSizeMake(self.navigationBar.frame.size.width, self.navigationBar.frame.size.height)];
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        self.navigationBar.layer.contents = (id)image.CGImage;
    }
    self.navigationBar.opaque = YES;
}

@end
