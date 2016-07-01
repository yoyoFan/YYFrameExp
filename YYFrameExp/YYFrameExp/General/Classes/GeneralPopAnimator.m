//
//  GeneralPopAnimator.m
//  jimao
//
//  Created by Dongle Su on 15/8/14.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "GeneralPopAnimator.h"
#import "UIView+Shadow.h"

@implementation GeneralPopAnimator
void animateCommon(id<UIViewControllerContextTransitioning> transitionContext, CGFloat duration, UIViewController *fromVC, UIViewController *toVC)
{
    //设置第二个控制器的位置、透明度
    CGRect rc = [transitionContext finalFrameForViewController:toVC];
    rc.origin.x = -rc.size.width/2.0f;
    toVC.view.frame = rc;
    
    [fromVC.view addShadow];
    //把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [[transitionContext containerView] insertSubview:toVC.view belowSubview:fromVC.view];
    

    //动起来。第二个控制器的透明度0~1；让截图SnapShotView的位置更新到最新；
    [UIView animateWithDuration:duration animations:^{
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        
        CGRect rc = [transitionContext initialFrameForViewController:fromVC];
        rc.origin.x = rc.size.width;
        fromVC.view.frame = rc;

    } completion:^(BOOL finished) {
        //告诉系统动画结束
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if (![transitionContext transitionWasCancelled]) {
            if ([toVC.navigationController.navigationItem isEqual:toVC.navigationItem]) {
                [toVC.navigationController.navigationBar popNavigationItemAnimated:NO];
            }
        }
        [fromVC.view removeShadow];
    }];
    
//    [fromVC.navigationController.navigationBar popNavigationItemAnimated:YES];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    animateCommon(transitionContext, [self transitionDuration:transitionContext], fromViewController, toViewController);
    
}
@end
