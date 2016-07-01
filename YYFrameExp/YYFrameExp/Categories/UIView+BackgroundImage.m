//
//  UIView+BackgroundImage.m
//  jimao
//
//  Created by Dongle Su on 15/8/21.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "UIView+BackgroundImage.h"
#import <objc/runtime.h>


const NSString *tag;

@implementation UIView (BackgroundImage)
- (void)setBackgroundImage:(UIImage *)image forBarMetrics:(UIBarMetrics)barMetrics{
    UIImageView *imageView = objc_getAssociatedObject(self, &tag);
    if (!imageView) {
        imageView = [self createImageView];
    }
    
    imageView.image = image;
}

- (UIImageView *)createImageView{
    UIImageView *view = [[UIImageView alloc] initWithFrame:self.bounds];
    [self insertSubview:view atIndex:0];
    
    objc_setAssociatedObject(self, &tag,
                             view,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return view;
}

@end
