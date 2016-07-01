//
//  CustomAlertController.m
//  jimao
//
//  Created by pan chow on 14/12/20.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "CustomAlertController.h"
#import <Masonry/Masonry.h>
@interface CustomAlertController ()
{
    UIView *backView;
}

@end

@implementation CustomAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}
- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeBtn:(UIButton *)btn
{
    [self hide];
}
- (void)tap:(UITapGestureRecognizer *)tap
{
    [self hide];
}
- (void)hide
{
    [self dismiss:nil];
}
- (void)showWithTitle:(NSString *)title detail:(NSString *)detail InCtrl:(UIViewController<UIViewControllerTransitioningDelegate> *)ctrl
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8.f;
    backView.clipsToBounds = YES;
    
   
    
    CGFloat top = 8.0f;
    
    UILabel *titleLB=[[UILabel alloc] init];
    titleLB.backgroundColor=[UIColor clearColor];
    titleLB.textAlignment=NSTextAlignmentCenter;
    titleLB.textColor=ColorC5;
    titleLB.font=[UIFont boldSystemFontOfSize:18.0f];
    titleLB.text=title;
    [backView addSubview:titleLB];
    [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(44);
    }];
    top += 44+8;
    
    UILabel *detailLB=[[UILabel alloc] initWithFrame:CGRectMake(8, 8, APP_SCREEN_WIDTH-104-16, 0)];
    detailLB.backgroundColor=[UIColor clearColor];
    detailLB.numberOfLines=0;
    detailLB.textAlignment=NSTextAlignmentLeft;
    detailLB.textColor = ColorC4;
    detailLB.font= UIFont16;
    detailLB.preferredMaxLayoutWidth = APP_SCREEN_WIDTH - 104 -16;
    
   
    [backView addSubview:detailLB];
    
    [detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
       // make.right.mas_equalTo(8);
        make.top.mas_equalTo(60);
        make.width.mas_equalTo(APP_SCREEN_WIDTH-104-16);
    }];
    detailLB.text = detail;
    [detailLB sizeToFit];
    
    top += detailLB.height+8;
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
    
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    top += 44+8;
    
    [self.view addSubview:backView];
    [backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(top);
        make.center.equalTo(self.view);
    }];
    
    self.view.layer.cornerRadius = 8.f;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.transitioningDelegate = ctrl;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    [ctrl.navigationController presentViewController:self
                                            animated:YES
                                          completion:NULL];
}
- (void)showInCtrl:(UIViewController<UIViewControllerTransitioningDelegate> *)ctrl
{
    self.transitioningDelegate = ctrl;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    [ctrl.navigationController presentViewController:self
                                            animated:YES
                                          completion:NULL];

}
@end
