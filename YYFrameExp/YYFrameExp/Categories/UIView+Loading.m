//
//  UIView+Loading.m
//  quanmama
//
//  Created by 苏东乐 on 15/6/24.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "UIView+Loading.h"

#define kIndicatorId 9876

@implementation UIView (Loading)
- (void)showLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [self createLoadingView];
        [self addSubview:view];
    });

}
- (void)hideLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [self viewWithTag:kIndicatorId];
        [view removeFromSuperview];
    });

}

- (UIView *)createLoadingView{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = self.backgroundColor;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = view.center;
    indicator.hidden = NO;
    [indicator startAnimating];
    [view addSubview:indicator];
    view.tag = kIndicatorId;
    return view;
}
@end
