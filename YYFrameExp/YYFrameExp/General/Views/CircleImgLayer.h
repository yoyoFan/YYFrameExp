//
//  CircleImgLayer.h
//  jimao
//
//  Created by pan chow on 15/8/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CircleImgLayer : CALayer

- (void)fillWithImg:(UIImage *)img;
- (void)fillWithImg:(UIImage *)img Circle:(BOOL)isCircle;
@end
