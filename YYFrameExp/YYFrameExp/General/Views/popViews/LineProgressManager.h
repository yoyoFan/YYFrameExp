//
//  LineProgressManager.h
//  jimao
//
//  Created by pan chow on 14/11/27.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineProgressManager : NSObject

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong)NSArray *gradientColors;
@property (nonatomic,strong)UIColor *backColor;

@property CGFloat height;

+ (instancetype)sharedInstance;
- (void)showProgressUponView:(UIView *)view;
- (void)showProgressUponView:(UIView *)view margin:(CGFloat)margin;
- (void)hideProgressView;

@end
