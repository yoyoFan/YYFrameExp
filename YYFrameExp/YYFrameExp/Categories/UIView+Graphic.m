//
//  UIView+Graphic.m
//  FlowStorm
//
//  Created by Dongle Su on 14-10-16.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UIView+Graphic.h"
#import "MBProgressHUD.h"

@implementation UIView (Graphic)
- (UIImage *)screenshot{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (hud) {
        [hud hide:NO];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
