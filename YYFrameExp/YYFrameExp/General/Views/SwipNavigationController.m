//
//  SwipNavigationController.m
//  jimao
//
//  Created by pan chow on 15/1/10.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "SwipNavigationController.h"

@interface SwipNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation SwipNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SLog(@"%s",__FUNCTION__);
    __weak SwipNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    SLog(@"%s",__FUNCTION__);
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    SLog(@"%s",__FUNCTION__);
    
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
