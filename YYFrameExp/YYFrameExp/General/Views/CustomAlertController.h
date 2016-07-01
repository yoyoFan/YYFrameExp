//
//  CustomAlertController.h
//  jimao
//
//  Created by pan chow on 14/12/20.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 ctrl
 1，继承<UIViewControllerTransitioningDelegate>
 2，实现
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
 presentingController:(UIViewController *)presenting
 sourceController:(UIViewController *)source
 {
 return [PresentingAnimator new];
 }
 
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
 {
 return [DismissingAnimator new];
 }
即可
 */

@interface CustomAlertController : UIViewController

- (void)showWithTitle:(NSString *)title detail:(NSString *)detail InCtrl:(UIViewController<UIViewControllerTransitioningDelegate> *)ctrl;
- (void)showInCtrl:(UIViewController *)ctrl;
- (void)dismissAnimated:(BOOL)animated;
@end
