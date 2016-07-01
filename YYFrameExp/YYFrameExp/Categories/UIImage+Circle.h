//
//  UIImage+Circle.h
//  jimao
//
//  Created by pan chow on 14/12/13.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Circle)

+ (UIImage *)CircleImageWithName:(NSString *)imgName;
+ (UIImage *)CircleImageWithName:(NSString *)imgName borderColor:(UIColor *)color inset:(float)inset;

@end
