//
//  SlideMenuViewHelper.h
//  jimao
//
//  Created by pan chow on 15/8/8.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlidePopMenuView.h"
@interface SlideMenuViewHelper : NSObject

+ (SlidePopMenuView *)rightSlideShowPopMenuOnBaseCtrl:(UIViewController *)ctrl
                                            topInView:(CGFloat)top
                                              showImg:(UIImage *)img
                                           showString:(NSString *)string
                                             tapBlock:(TapBlock)block;
@end
