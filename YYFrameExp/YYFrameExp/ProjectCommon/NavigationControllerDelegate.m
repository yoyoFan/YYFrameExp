//
//  NavigationControllerDelegate.m
//  NavigationTransitionController
//
//  Created by 苏东乐 on 15/7/9.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "GeneralPopAnimator.h"

@interface NavigationControllerDelegate ()

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactionController;

@end

@implementation NavigationControllerDelegate{
    UIPanGestureRecognizer* panRecognizer_;
}

- (id)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    if (self.navigationController) {
        [self initNavigation];
    }
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)initNavigation{
    panRecognizer_ = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.navigationController.view addGestureRecognizer:panRecognizer_];
}

- (void)setNavigationController:(UINavigationController *)navigationController{
    _navigationController = navigationController;
    if (navigationController && !panRecognizer_) {
        [self initNavigation];
    }
}

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
    UIView* view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return [GeneralPopAnimator new];
    }

    return nil;
//    if (operation == UINavigationControllerOperationPop) {
//        return self.animator;
//    }
//    return self.animator;
//    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}




@end
