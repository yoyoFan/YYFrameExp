//
//  ImageViewer.h
//  FlowExp
//
//  Created by Dongle Su on 14-4-17.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewer : UIScrollView <UIScrollViewDelegate>
{
    CGFloat currentScale;
}

@property(nonatomic, strong) UIImage *image;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
@end
