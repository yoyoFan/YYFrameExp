//
//  SlideMenuViewHelper.m
//  jimao
//
//  Created by pan chow on 15/8/8.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "SlideMenuViewHelper.h"

@implementation SlideMenuViewHelper

+ (SlidePopMenuView *)showSlidePopMenuOnBaseCtrl:(UIViewController *)ctrl
                              rect:(CGRect)frame
                           showImg:(UIImage *)img
                        showString:(NSString *)string
                          tapBlock:(TapBlock)block
{
    SlidePopMenuView *menu = [[SlidePopMenuView alloc] initWithFrame:frame];
    [menu fillMenuWithImg:img title:string];
    menu.tapBlock = block;
    [ctrl.view addSubview:menu];
    
    return menu;
}
+ (SlidePopMenuView *)rightSlideShowPopMenuOnBaseCtrl:(UIViewController *)ctrl
                                            topInView:(CGFloat)top
                                showImg:(UIImage *)img
                             showString:(NSString *)string
                               tapBlock:(TapBlock)block
{
    CGRect frame = CGRectMake(APP_SCREEN_WIDTH - 184, top, 184, 52);
    SlidePopMenuView *ret = [[self class] showSlidePopMenuOnBaseCtrl:ctrl rect:frame showImg:img showString:string tapBlock:^(BOOL isTap, BOOL isFold) {
        block(isTap,isFold);
    }];
    return ret;
}
@end
