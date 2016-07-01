//
//  LinePopProgressView.h
//  jimao
//
//  Created by pan chow on 14/11/27.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinePopProgressView : UIView

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong)NSArray *gradientColors;
@property (nonatomic,strong)UIColor *backColor;

@property CGFloat height;

+ (instancetype)sharedInstance;
- (void)showProgressUponView:(UIView *)view;
- (void)hideProgressView;
@end
