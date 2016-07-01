//
//  NavigationControllerDelegate.h
//  NavigationTransitionController
//
//  Created by 苏东乐 on 15/7/9.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationControllerDelegate : NSObject <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
//@property (strong, nonatomic) id<UIViewControllerAnimatedTransitioning> animator;

@end
